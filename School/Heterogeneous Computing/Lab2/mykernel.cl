__kernel void calculatePi(int numIterations, __global float *outputPi, __local float* local_result, int numWorkers)
{
    __private const uint gid = get_global_id(0);
    __private const uint lid = get_local_id(0);
    __private uint offset = numIterations*gid*2; 
    __private float sum = 0.0f;
    __private int i;

    // Have the last worker initialize local_result
    if (gid == numWorkers-1)
    {
        for (i = 0; i < numWorkers; i++)
        {
            local_result[i] = 0.0f;
        }
    }

    // Have all workers wait until this is completed
    barrier(CLK_LOCAL_MEM_FENCE | CLK_GLOBAL_MEM_FENCE);
    
    // Have each worker calculate their portion of pi
    // This is a private value
    for (i = 0; i < numIterations; i++) 
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
    barrier(CLK_LOCAL_MEM_FENCE | CLK_GLOBAL_MEM_FENCE);

    // Have the last worker add up all of the other worker's values
    // to get the final value
    // Last worker use verifies that the worker and memory allocation are correct
    if (gid == numWorkers-1)
    {
        outputPi[0] = 0;
        for (i = 0; i < numWorkers; i++)
        {
            outputPi[0] += local_result[i]; 
        }
	
        outputPi[0] *= 4;	
    }    
}