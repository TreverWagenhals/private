__kernel void calculatePi(int numIterations, __global float *outputPi, __local float* local_result, int numWorkers)
{
    __private const uint gid = get_global_id(0);
    __private const uint lid = get_local_id(0);
    __private const uint offset = numIterations*gid*2; 
    __private float sum = 0.0f;

    // Have the first worker initialize local_result
    if (gid == 0)
    {
        for (int i = 0; i < numWorkers; i++)
        {
            local_result[i] = 0.0f;
        }
    }

    // Have all workers wait until this is completed
    barrier(CLK_GLOBAL_MEM_FENCE);
    
    // Have each worker calculate their portion of pi
    // This is a private value
    for (int i=0; i<numIterations; i++) 
    {
        if (i % 2 == 0)
	{
            sum += 1 / (1 + 2*i + offset);
	}
        else
	{
            sum -= 1 / (1 + 2*i + offset);
	}
    }
    
    // Have each worker move their value to the appropriate
    // local_result slot so that the first worker can see it
    // when reducing next
    local_result[gid] = sum;    

    // Make sure all workers complete this task before continuing
    barrier(CLK_LOCAL_MEM_FENCE);

    // Have the first worker add up all of the other worker's values
    // to get the final value
    if (lid == 0)
    {
        outputPi[0] = 0;
        for (int i = 0; i < numWorkers; i++)
        {
            outputPi[0] += local_result[i]; 
        }
	
        outputPi[0] *= 4;
    }    
}