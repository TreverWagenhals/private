from pycuda import gpuarray
from pycuda.reduction import ReductionKernel
import pycuda.autoinit
import numpy as np
import time
import sys
import optparse
import csv

dataPrepTime     = 0.0
dataUploadTime   = 0.0
gpuComputeTime   = 0.0
throughput       = 0.0
totalComputeTime = 0.0

def createWordcountCudaKernel():
    # 32 is ascii code for whitespace
    mapper = "(a[i] == 32)*(b[i] != 32)"
    reducer = "a+b"
    cudaFunctionArguments = "char* a, char* b"

    kernel = ReductionKernel(np.dtype(np.float32), neutral="0",
                             reduce_expr=reducer, map_expr=mapper,
                             arguments=cudaFunctionArguments)
    return kernel


def createDataset(filename, replication):
    global dataPrepTime
    
    start = time.time()
    dataset = np.fromfile(filename, dtype=np.int8)
    originalData = dataset.copy()

    for k in xrange(replication):
        dataset = np.append(dataset, originalData)

    numpyarray = np.arry(dataset, dtype=np.uint8)

    stop = time.time()
    dataPrepTime = (stop - start) * 1000

    print "Dataset preparation took ", dataPrepTime, " milliseconds"
    print "Dataset size = ", len(dataset)

    # Does declaring the numpy array first and returning it take longer than just returning the numpy array declaration within the return statement?
    # ie. return np.array(dataset, dtype=np.uint8)
    #     instead of
    #     numpyarray = np.arry(dataset, dtype=np.uint8)
    #     return numpyarray
    return numpyarray

def wordCount(kernel, numpyarray):
    global dataUploadTime
    global gpuComputeTime 
    global throughput
    
    print "Uploading array to gpu"
    
    start = time.time()
    gpudataset = gpuarray.to_gpu(numpyarray)
    stop = time.time()
    dataUploadTime = (stop-start)*1000
    print "GPU array upload took ", dataUploadTime, " milliseconds"  
    
    datasetsize = len(numpyarray)
    start = time.time()
    wordcount = kernel(gpudataset[:-1], gpudataset[1:]).get()
    stop = time.time()
    seconds = (stop-start)
    gpuComputeTime = seconds * 1000
    # Data set size is in bytes. To convert to Kilobytes, we divide by 1024. To convert to Megabytes, we again divide by 1024. To get Gigabytes, one more division by 1024
    throughput = (datasetsize/seconds)/(1024*1024*1024)
    print "Word count took ", gpuComputeTime, " milliseconds"
    print "Estimated throughput ", throughput, " Gigabytes/s"
    return wordcount

if __name__ == "__main__":
    parser = optparse.OptionParser()
    parser.add_option('--inputFile', action="store", dest="inputFile", help="Specify the file name to be used as the input dataset. Default is to look for 'dataset.txt' file in current directory", default="dataset.txt")
    parser.add_option('--replicate', action="store", dest="replication", help="Specify how many times the data should be replicated. Useful for easily testing large datasets from small samples. Default behavior is to only use the original dataset, ie. replication=1", default="1")
    parser.add_option('--outputFile', action="store", dest="outputFile", help="Specify where all of the calculations should be saved (.csv file!)", default="wordcount_results.csv")

    options, args = parser.parse_args()

    start = time.time()
    
    if (int(options.replication, 10) == 0):
        for x in [1, 10, 100, 200, 300, 400, 500, 600, 700, 800, 900, 1000]:
            numpyarray = createDataset(options.inputFile, int(options.replication, 10))
            kernel = createWordcountCudaKernal()
            wordcount = wordCount(kernal, numpyarray)
            stop = time.time()
            milliseconds = (stop - start) * 1000
            print "Total Compute Time: ", milliseconds, "ms"
            print "Word Count: ", wordcount
            data = (int(options.replication, 10), dataPrepTime, dataUploadTime, gpuComputeTime, throughput, totalComputeTime)
            with open(options.outputFile, 'a') as outputFile:
                outputFile.write('%i, %f, %f, %f, %f, %f\n' % data)
    else:
        numpyarray = createDataset(options.inputFile, int(options.replication, 10))
        kernel = createWordcountCudaKernal()
        wordcount = wordCount(kernal, numpyarray)
        stop = time.time()
        milliseconds = (stop - start) * 1000
        print "Total Compute Time: ", milliseconds, "ms"
        print "Word Count: ", wordcount
        data = (int(options.replication, 10), dataPrepTime, dataUploadTime, gpuComputeTime, throughput, totalComputeTime)
        with open(options.outputFile, 'a') as outputFile:
            outputFile.write('%i, %f, %f, %f, %f, %f\n' % data)