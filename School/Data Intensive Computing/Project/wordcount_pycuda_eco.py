from pycuda import gpuarray
from pycuda.reduction import ReductionKernel
import pycuda.autoinit
import numpy as np
import time


def createCudawckernal():
    # 32 is ascii code for whitespace
    mapper = "(a[i] == 32)*(b[i] != 32)"
    reducer = "a+b"
    cudafunctionarguments = "char* a, char* b"
    wckernal = ReductionKernel(np.dtype(np.float32), neutral="0",
                               reduce_expr=reducer, map_expr=mapper,
                               arguments=cudafunctionarguments)
    return wckernal


def createBigDataset(filename):
    print "Reading data"
    dataset = np.fromfile(filename, dtype=np.int8)
    originaldata = dataset.copy()
    for k in xrange(100):
        dataset = np.append(dataset, originaldata)
    print "Dataset size = ", len(dataset)
    return np.array(dataset, dtype=np.uint8)


def wordCount(wckernal, bignumpyarray):
    print "Uploading array to gpu"
    gpudataset = gpuarray.to_gpu(bignumpyarray)
    datasetsize = len(bignumpyarray)
    start = time.time()
    wordcount = wckernal(gpudataset[:-1], gpudataset[1:]).get()
    stop = time.time()
    seconds = (stop-start)
    estimatepersecond = (datasetsize/seconds)/(1024*1024*1024)
    print "Word count took ", seconds*1000, " milliseconds"
    print "Estimated throughput ", estimatepersecond, " Gigabytes/s"
    return wordcount

if __name__ == "__main__":
    print 'Downloading the .txt file'
    from urllib import urlretrieve
    txtfileurl = 'https://s3.amazonaws.com/econpy/shakespeare.txt'
    urlretrieve(txtfileurl, 'shakespeare.txt')
    print 'Go Baby Go!'
    bignumpyarray = createBigDataset("shakespeare.txt")
    wckernal = createCudawckernal()
    wordcount = wordCount(wckernal, bignumpyarray)
    print 'Word Count: %s' % wordcount