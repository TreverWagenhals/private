from __future__ import print_function
import sys
from operator import add
from pyspark import SparkContext


if __name__ == "__main__":
    if len(sys.argv) != 3:
        print("Usage: wordcount_gpu.py <infile> <outfile>", infile=sys.stderr, outfile=sys.stderr)
        exit(-1)
    sc = SparkContext(appName="PythonWordCount_gpu")
    lines = sc.textFile(sys.argv[1])
    tokens = lines.flatMap(lambda x: x.split(' '))
    #split tasks into 2 parts, one for cpu, the other one for gpu
    cpu_tokens, gpu_tokens = tokens.randomSplit([2, 3], 17)
    cpu_counts = cpu_tokens.map(lambda x: (x, 1)).reduceByKey(add)
    gpu_counts = gpu_tokens.gpu(False).map(lambda x: (x, 1)).reduceByKey(add)

    # union the compute from cpu and gpu
    counts = cpu_counts.union(gpu_counts).reduceByKey(add).sortByKey(True, 1)
    counts.saveAsTextFile(sys.argv[2])

    sc.stop()