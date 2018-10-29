__kernel void simpleMultiplyAdd(
    __global float *outputD,
    int widthA,
    int heightA,
    int widthB,
    int heightB,
    __global float *inputA,
    __global float *inputB,
    __global float *inputC)
{
    /* get global position in Y direction */
    int row = get_global_id (1);
    /* get global position in X direction */
    int col = get_global_id (0);

    float sum = 0.0f;

    // Calculate a single element of the dot product of inputA and inputB
    for (int i=0; i<widthA; i++) {
        sum += inputA[row*widthA + i] * inputB[i*widthB + col];
    }

    // add inputC to the dot product of inputA and inputB to get the final outputD
    outputD[row*widthB + col] = sum + inputC[row*widthB + col];
}