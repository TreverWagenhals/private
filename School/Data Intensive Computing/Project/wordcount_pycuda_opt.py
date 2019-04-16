from pycuda import gpuarray
from pycuda.reduction import ReductionKernel
import pycuda.autoinit
import numpy as np
import time
import sys
import optparse

def createWordcountCudaKernel():
    # 32 is ascii code for whitespace
    mapper = "(a[i] == 32)*(b[i] != 32)"
    reducer = "a+b"
    cudaFunctionArguments = "char* a, char* b"
    start = time.time()
    kernel = ReductionKernel(np.dtype(np.float32), neutral="0",
                             reduce_expr=reducer, map_expr=mapper,
                             arguments=cudaFunctionArguments)
    stop = time.time()
    # difference between stop and start time is in seconds. Multiply by 1000 to convert to milliseconds
    milliseconds = (stop - start) * 1000
    print "Kernel creation took ", milliseconds, " milliseconds"
    return kernel


def createDataset(filename, replication):
    start = time.time()
    dataset = np.fromfile(filename, dtype=np.int8)
    originalData = dataset.copy()

    for k in xrange(replication):
        dataset = np.append(dataset, originalData)

    numpyarray = np.arry(dataset, dtype=np.uint8)

    stop = time.time()
    milliseconds = (stop - start) * 1000

    print "Dataset preparation took ", milliseconds, " milliseconds"
    print "Dataset size = ", len(dataset)

    # Does declaring the numpy array first and returning it take longer than just returning the numpy array declaration within the return statement?
    # ie. return np.array(dataset, dtype=np.uint8)
    #     instead of
    #     numpyarray = np.arry(dataset, dtype=np.uint8)
    #     return numpyarray
    return numpyarray

def wordCount(kernel, numpyarray):
    print "Uploading array to gpu"
    gpudataset = gpuarray.to_gpu(numpyarray)
    datasetsize = len(numpyarray)
    start = time.time()
    wordcount = kernel(gpudataset[:-1], gpudataset[1:]).get()
    stop = time.time()
    seconds = (stop-start)
    # Data set size is in bytes. To convert to Kilobytes, we divide by 1024. To convert to Megabytes, we again divide by 1024. To get Gigabytes, one more division by 1024
    estimatepersecond = (datasetsize/seconds)/(1024*1024*1024)
    print "Word count took ", seconds*1000, " milliseconds"
    print "Estimated throughput ", estimatepersecond, " Gigabytes/s"
    return wordcount

if __name__ == "__main__":
    parser = optparse.OptionParser()
    parser.add_option('--inputFile', action="store", dest="inputFile", help="Specify the file name to be used as the input dataset. Default is to look for 'dataset.txt' file in current directory", default="dataset.txt")
    parser.add_option('--replicate', action="store", dest="replication", help="Specify how many times the data should be replicated. Useful for easily testing large datasets from small samples. Default behavior is to only use the original dataset, ie. replication=1", default=1)

    options, args = parser.parse_args()

    start = time.time()
    numpyarray = createDataset(options.inputFile, options.replication)
    kernel = createWordcountCudaKernal()
    wordcount = wordCount(kernal, numpyarray)
    stop = time.time()
    milliseconds = (stop - start) * 1000
    print "Total compute time of program was ", milliseconds, " milliseconds"
    print "Word Count: ", wordcount