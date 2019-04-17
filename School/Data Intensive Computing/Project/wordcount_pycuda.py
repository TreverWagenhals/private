import pycuda.autoinit
import numpy
from pycuda import gpuarray, reduction
import time
import sys
import optparse
import csv

dataPrepTime     = 0
dataUploadTime   = 0
throughput       = 0
totalComputeTime = 0


def createCudaWordCountKernel():
    initvalue = "0"
    mapper = "(a[i] == 32)*(b[i] != 32)" # 32 is ascii code for whitespace
    reducer = "a+b"
    cudafunctionarguments = "char* a, char* b"
    wordcountkernel = reduction.ReductionKernel(numpy.float32, neutral = initvalue,
                                            reduce_expr=reducer, map_expr = mapper,
                                            arguments = cudafunctionarguments)
    return wordcountkernel

def createDataset(filename, replication):
    print "reading data"
    start = time.time()
    dataset = file(filename).read()
    words = " ".join(dataset.split()) # in order to get rid of \t and \n
    chars = [ord(x) for x in words]
    bigdataset = []

    for k in xrange(replication):
        bigdataset += chars

    print "Dataset size = ", len(bigdataset)
    print "Creating numpy array of dataset"
    numpyarray = numpy.array(bigdataset, dtype=numpy.uint8)
    stop = time.time()
    milliseconds = (stop - start) * 1000

    print "Dataset preparation took ", milliseconds, " milliseconds"
    return numpyarray

def wordCount(wordcountkernel, bignumpyarray):
    print "Uploading array to gpu"
    
    start = time.time()
    gpudataset = gpuarray.to_gpu(bignumpyarray)
    stop = time.time()
    dataUploadTime = (stop-start)*1000
    print "GPU array upload took ", dataUploadTime, " milliseconds"    
    
    datasetsize = len(bignumpyarray)
    start = time.time()
    wordcount = wordcountkernel(gpudataset[:-1],gpudataset[1:]).get()
    stop = time.time()
    gpuComputeTime = (stop-start)*1000
    throughput = (datasetsize/seconds)/(1024*1024*1024)
    print "word count took ", gpuComputeTime, " milliseconds"
    print "estimated throughput ", throughput, " Gigabytes/s"
    return wordcount

if __name__ == "__main__":
    parser = optparse.OptionParser()
    parser.add_option('--inputFile', action="store", dest="inputFile", help="Specify the file name to be used as the input dataset", default="dataset.txt")
    parser.add_option('--replicate', action="store", dest="replication", help="Specify how many times the data should be replicated. Useful for easily testing large datasets from small samples", default="1")
    parser.add_option('--outputFile', action="store", dest="outputFile", help="Specify where all of the calculations should be saved (.csv file!)", default="wordcount_results.csv")

    options, args = parser.parse_args()

    start = time.time()
    numpyarray = createDataset(options.inputFile, int(options.replication, 10))
    wordcountkernel = createCudaWordCountKernel()
    wordcount = wordCount(wordcountkernel, numpyarray)
    stop = time.time()
    totalComputeTime = (stop - start) * 1000
    print "Total Compute Time: ", totalComputeTime, "ms"
    print "Word Count: ", wordcount
    data = (int(options.replication, 10), dataPrepTime, dataUploadTime, gpuComputeTime, throughput, totalComputeTime)
    with open(options.outputFile, 'a') as outputFile:
        outputFile.write('%i, %f, %f, %f, %f, %f\n' % data)
    
    