__kernel void simpleMultiplyAdd(int numIterations, __global float *outputPi, __local float* local_result, int numWorkers)
{
    // Get global ID for worker
    const uint gid = get_global_id(0);
    const uint lid = get_local_id(0);
 
    float sum = 0.0f;
    
    for (int i=0; i<numIterations; i++) 
    {
        if (i % 2 == 0)
            sum += 1 / (1 + 2*i + (2*numIterations*gid));
        else
            sum -= 1 / (1 + 2*i + (2*numIterations*gid));
    }
    
    local_result[gid] = sum;    
    
    barrier(CLK_LOCAL_MEM_FENCE);
    
    if (get_local_id(0) == 0)
    {        
        outputPi = 0;
        for (int i = 0; i < numWorkers; i++)
        {
            *outputPi += local_result[i]; 
        }
    }    
}