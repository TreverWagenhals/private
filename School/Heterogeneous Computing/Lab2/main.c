#include <stdio.h>
#include <stdlib.h>
#include <math.h>

#ifdef __APPLE__
    #include <OpenCL/opencl.h>
#else
    #include <CL/cl.h>
#endif

#ifdef AOCL
    #include "CL/opencl.h"
    #include "AOCLUtils/aocl_utils.h"

    using namespace aocl_utils;
    void cleanup();
#endif

#define MAX_SOURCE_SIZE (0x100000)
#define DEVICE_NAME_LEN 128
static char dev_name[DEVICE_NAME_LEN];

int main()
{
    cl_uint platformCount;
    cl_platform_id* platforms;
    cl_device_id device_id;
    cl_uint ret_num_devices;
    cl_int ret = 0;
    cl_context context = NULL;
    cl_command_queue command_queue = NULL;
    cl_program program = NULL;
    cl_kernel kernel = NULL;

    cl_uint num_comp_units;
    size_t global_size;
    size_t local_size;

    float *result;
    FILE *fp;
    char fileName[] = "./mykernel.cl";
    char *source_str;
    size_t source_size;

    FILE *text_handle;
    char *text;
    size_t text_size;
    int chars_per_item;

    #ifdef __APPLE__
        /* Get Platform and Device Info */
        clGetPlatformIDs(1, NULL, &platformCount);
        platforms = (cl_platform_id*) malloc(sizeof(cl_platform_id) * platformCount);
        clGetPlatformIDs(platformCount, platforms, NULL);
        // we only use platform 0, even if there are more plantforms
        // Query the available OpenCL device.
        ret = clGetDeviceIDs(platforms[0], CL_DEVICE_TYPE_DEFAULT, 1, &device_id, &ret_num_devices);
        ret = clGetDeviceInfo(device_id, CL_DEVICE_NAME, DEVICE_NAME_LEN, dev_name, NULL);
        printf("device name= %s\n", dev_name);
    #else

        #ifdef AOCL  /* Altera FPGA */
            // get all platforms
            clGetPlatformIDs(0, NULL, &platformCount);
            platforms = (cl_platform_id*) malloc(sizeof(cl_platform_id) * platformCount);
            // Get the OpenCL platform.
            platforms[0] = findPlatform("Intel(R) FPGA");
            if(platforms[0] == NULL) {
              printf("ERROR: Unable to find Intel(R) FPGA OpenCL platform.\n");
              return false;
            }
            // Query the available OpenCL device.
            getDevices(platforms[0], CL_DEVICE_TYPE_ALL, &ret_num_devices);
            printf("Platform: %s\n", getPlatformName(platforms[0]).c_str());
            printf("Using one out of %d device(s)\n", ret_num_devices);
            ret = clGetDeviceIDs(platforms[0], CL_DEVICE_TYPE_DEFAULT, 1, &device_id, &ret_num_devices);
            printf("device name=  %s\n", getDeviceName(device_id).c_str());
        #else
            #error "unknown OpenCL SDK environment"
        #endif
    #endif

    /* Determine global size and local size */
    clGetDeviceInfo(device_id, CL_DEVICE_MAX_COMPUTE_UNITS, sizeof(num_comp_units), &num_comp_units, NULL);
    printf("num_comp_units=%u\n", num_comp_units);

    #ifdef __APPLE__
        clGetDeviceInfo(device_id, CL_DEVICE_MAX_WORK_GROUP_SIZE, sizeof(local_size), &local_size, NULL);
    #endif
    /* local size reported Altera FPGA is incorrect */
    #ifdef AOCL
        local_size = 16;
    #endif
    printf("local_size=%lu\n", local_size);
    global_size = num_comp_units * local_size;
    printf("global_size=%lu, local_size=%lu\n", global_size, local_size);

    /* Create OpenCL context */
    context = clCreateContext(NULL, 1, &device_id, NULL, NULL, &ret);

    /* Create Command Queue */
    command_queue = clCreateCommandQueue(context, device_id, 0, &ret);

    #ifdef __APPLE__
        /* Load the source code containing the kernel*/
        fp = fopen(fileName, "r");
        if (!fp) 
        {
            fprintf(stderr, "Failed to load kernel.\n");
            exit(1);
        }
        
        source_str = (char*)malloc(MAX_SOURCE_SIZE);
        source_size = fread(source_str, 1, MAX_SOURCE_SIZE, fp);
        fclose(fp);

        /* Create Kernel Program from the source */
        program = clCreateProgramWithSource(context, 1, (const char **)&source_str, (const size_t *)&source_size, &ret);
        if (ret != CL_SUCCESS) 
        {
          printf("Failed to create program from source.\n");
          exit(1);
        }
    #else

        #ifdef AOCL  /* on FPGA we need to create kernel from binary */
           /* Create Kernel Program from the binary */
           std::string binary_file = getBoardBinaryFile("mykernel", device_id);
           printf("Using AOCX: %s\n", binary_file.c_str());
           program = createProgramFromBinary(context, binary_file.c_str(), &device_id, 1);
        #else
            #error "unknown OpenCL SDK environment"
        #endif

    #endif

    /* Build Kernel Program */
    ret = clBuildProgram(program, 1, &device_id, NULL, NULL, NULL);
    if (ret != CL_SUCCESS) 
    {
      printf("Failed to build program.\n");
      exit(1);
    }

    /* Create OpenCL Kernel */
    kernel = clCreateKernel(program, "string_search", &ret);
    if (ret != CL_SUCCESS) 
    {
      printf("Failed to create kernel.\n");
      exit(1);
    }

    /* Create buffers to hold the text characters and count */
    cl_mem result_buffer = clCreateBuffer(context, CL_MEM_READ_WRITE | CL_MEM_COPY_HOST_PTR, sizeof(result), result, NULL);

    int iterations = 16;
    int *numIterations = &iterations;
    size_t *numWorkers = &global_size;
    /* Create kernel argument */
    ret = clSetKernelArg(kernel, 0, sizeof(int), &numIterations);
    ret |= clSetKernelArg(kernel, 1, sizeof(cl_mem), &result_buffer);
    ret |= clSetKernelArg(kernel, 2, sizeof(float), NULL);
    ret |= clSetKernelArg(kernel, 3, sizeof(size_t), &numWorkers);
    if(ret < 0) 
    {
       printf("Couldn't set a kernel argument");
       exit(1);
    };

    /* Enqueue kernel */
    ret = clEnqueueNDRangeKernel(command_queue, kernel, 1, NULL, &global_size, &local_size, 0, NULL, NULL);
    if(ret < 0) 
    {
       perror("Couldn't enqueue the kernel");
       printf("Error code: %d\n", ret);
       exit(1);
    }

    /* Read and print the result */
    ret = clEnqueueReadBuffer(command_queue, result_buffer, CL_TRUE, 0, sizeof(result), &result, 0, NULL, NULL);
    if(ret < 0) 
    {
       perror("Couldn't read the buffer");
       exit(1);
    }
    
    printf("Final calculated value: %f \n", result);

    clReleaseMemObject(result_buffer);
    clReleaseCommandQueue(command_queue);
    clReleaseKernel(kernel);
    clReleaseProgram(program);
    clReleaseContext(context);

    return 0;
}

#ifdef AOCL
    // Altera OpenCL needs this callback function implemented in main.c
    // Free the resources allocated during initialization
    void cleanup() {}
#endif