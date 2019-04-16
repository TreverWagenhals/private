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
    kernel = ReductionKernel(np.dtype(np.float32), neutral="0",
                             reduce_expr=reducer, map_expr=mapper,
                             arguments=cudaFunctionArguments)
    return kernel


def createDataset(filename, replication):
    print "Reading data"
    dataset = np.fromfile(filename, dtype=np.int8)
    originalData = dataset.copy()
    
    for k in xrange(replication):
        dataset = np.append(dataset, originalData)
    print "Dataset size = ", len(dataset)
    return np.array(dataset, dtype=np.uint8)


def wordCount(kernel, numpyarray):
    print "Uploading array to gpu"
    gpudataset = gpuarray.to_gpu(numpyarray)
    datasetsize = len(numpyarray)
    start = time.time()
    wordcount = kernel(gpudataset[:-1], gpudataset[1:]).get()
    stop = time.time()
    seconds = (stop-start)
    estimatepersecond = (datasetsize/seconds)/(1024*1024*1024)
    print "Word count took ", seconds*1000, " milliseconds"
    print "Estimated throughput ", estimatepersecond, " Gigabytes/s"
    return wordcount

if __name__ == "__main__":
    parser = optparse.OptionParser()
    parser.add_option('--inputFile', action="store", dest="inputFile", help="Specify the file name to be used as the input dataset. Default is to look for 'dataset.txt' file in current directory", default="dataset.txt")
    parser.add_option('--replicate', action="store", dest="replication", help="Specify how many times the data should be replicated. Useful for easily testing large datasets from small samples. Default behavior is to only use the original dataset, ie. replication=1", default=1)

    options, args = parser.parse_args()

    numpyarray = createDataset(options.inputFile, options.replication)
    kernel = createCudaKernal()
    wordcount = wordCount(kernal, numpyarray)
    print 'Word Count: %s' % wordcount