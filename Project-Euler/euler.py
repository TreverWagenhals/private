from math import *
import time
from euler_funcs import *
from decimal import *
from sets import *
from sympy import sieve
import numpy
from itertools import *
from fractions import Fraction

def problem_99():
    f = open('problem_99.txt', 'r')                                         # Read in the file that contains base and exponent combination values                                           
    largest_line_value = 0
    for i in range(1000):                                                     # Go through all 1000 lines of code
        string_line = f.readline().split(",")                              # Store line in list, splitting base and exponent
        
        base = float(string_line[0])                                        # Save first value to base variable, converting to float                            
        exponent = float(string_line[1])                                    # Save second value to exponent variable, converting to float
        solution = exponent * math.log10(base)                             # A log solution should have the same relative values, so the greatest number can still 
                                                                                # be found without having insanely large numbers
        if solution > largest_line_value:                                  # If solution is greater than previous greatest solution found, update it
             largest_line_value = solution
             largest_line = i + 1                                            # Get the line number for new largest solution. Line is +1 since list starts at 0, not 1
                           
    print largest_line    
    
def problem_13():
    f = open('problem_23.txt', 'r')                         # Open file
    total = 0
    for i in range(0,100):                                   # 100 lines of text, go through each line
        total += int(f.readline())                          # Add line value to total
    print str(total)[0:10]                                  # Print last 10 digits of total
    
def problem_48():
    total = 0
    for i in range(1,1001):                             # Loop through all 1000 values
        total += pow(i, i)                               # Add i^i to total
    print str(total)[-10:]                              # Print last 10 digits of total
    
def problem_56():
    largest = 0                         
    for i in range(1,101):                          # Base value 1-100
        for j in range(1,101):                      # Exponent value 1-100
            sum = 0                                   # Reset sum for current variable digits
            exponent = pow(i,j)                     # Calculate power value
            for k in str(exponent):                 # Loop through value and add each digit to sum
                sum += int(k)
            if sum > largest:                       # If the sum of the digits is larger than the previous largest, update
                largest = sum
             
    print largest
    
def problem_16():
    total = 0
    for i in str(2**1000):                      # Simply loop through all digits in 2^1000 and add them up
        total += int(i)
        
    print total
	

def problem_55():
	ly_count = 0
	for i in range(1,10000):                        # The problem states to use 10000
		it_count = 0                                 # Keep track of how many iterations are gone through to check if a number is ly
		temp = i
		for max_iterations in range(1,51):       # Go through the maximum amount of iterations specified
			temp = temp + int(str(temp)[::-1])  # Add inverse of current value to itself
			if temp == int(str(temp)[::-1]):    # Check to see if the inverse of the new value makes a palindrome
				break
			else:                                   # If it doesn't, add one to the it_counter.
				it_count = it_count + 1 
		
			if it_count == 50:                     # If the counter hits 50, we have found a ly number
				ly_count = ly_count + 1          # Add one to the ly_counter
				
	print ly_count
		
			
			
def problem_87():    
    square_primes = primesfrom2to(int(50000000**.5))                  # Create lists for primes of squares, cubes, and quads
    cube_primes = primesfrom2to(int(50000000**(.3333)))
    quad_primes = primesfrom2to(int(50000000**.25))

    x = set([])                                                             
    
    for j in square_primes:                                         # Sort through square primes, trying each one as the current pow2
        pow2 = pow(j,2)                                              
        for k in cube_primes:                                       # Do the same for cube primes
                pow3 = pow(k,3)
                for l in quad_primes:                               # And quad primes
                        pow4 = pow(l,4)
                        total = pow2 + pow3 + pow4                  # Get the total of these values
                        if total <= 50000000:                       # If the total < 50mil, it is possible and add it to the set 
                            x.add(total)                                                 
    print len(x)
				

def problem_145():
	counter = 0
	def reversible(n):
		if (n % 10 == 0):                    # Quickly rule out any divisble by 10 since term can't end in a 0 for this to work
			return False
		sum = i + int(str(i)[::-1])        # add reversed number to original
		while sum > 0:
			if ((sum % 10) % 2) == 0:      # We want to check each digit, so we divide by 10 to check the next digit. We are checking to see if they are odd,
				return False               # so we divide by 2 to see if they're odd
			sum /= 10                       # decrement amount of digits to continue process. If the sum gets to 0 without finding an even digit, it will print true
		return True
	
	for i in xrange (1, 100000000,2):       # Couldn't think of any method aside from bruteforce. Was able to iterate by 2 though because any number that is a palindrome
		if reversible(i):                    # will begin with even and end in odd, or vice-versa, to make an odd number in the end
			counter = counter + 1           # So, we only need to check for one of the solutions by looking at odds then double it.
			
	print counter*2
			
  
def problem_30():
	total = 0
	for i in range(2, 9**6):                # The limit is 9^6 because past 9^6, then the amount of digits in the starting value are by a factor of at least 10 larger
		temp = 0                              # than the power of all digits added together. So, this is where it becomes impossible for a solution to be found.
		
		for length in str(i):              # Go through the value, and raise each digit to the power of 5 and add up
			temp += int(length)**5
		
		if temp == i:                       # If power value equals original, increase counter
			total += temp
			
	print "TOTAL IS", total
	
def problem_18_67(problem):             # Managed to combine to problems into one since they are the same, just call on different triangles of different sizes
    if problem == 18:
        size_of_triangle = 15
        f = open('problem_18.txt', 'r')     # Read in proper text file and triangle size based on problem number specified
    elif problem == 67:
        size_of_triangle = 100
        f = open('problem_67.txt', 'r')
        
    rows = []
    
    for i in range(0,size_of_triangle):                         # Add each row of the text to the list, splitting the values based on spaces
        rows.append(f.readline().strip().split(" "))
        map(int, rows[i])                                         # Make everything an int for future use
    rows = [map(int, x) for x in rows]
    
    for row in range(size_of_triangle-1,0,-1):
        if rows[row][row] > rows[row][row-1]:
            rows[row-1][row-1] += rows[row][row]
        else:
            rows[row-1][row-1] += rows[row][row-1]
        for element in range(row - 2, -1, -1):
                    if rows[row][element] > rows[row][element+1]:
                        rows[row-1][element] += rows[row][element]
                    else: 
                        rows[row-1][element] += rows[row][element+1]
                    
    print rows[0]
            
def problem_42():
	f = open('problem_42.txt', 'r')
	words = f.readline()
	words = (words.replace(",", ""))
	quote = '"'
	total = 0
	counter = 0
	for i in words:

		if i != quote:
			total += ord(i) - 64
			
		else:
			verify_triangle = 0
			for j in range(1, 19):
				verify_triangle += j
				if verify_triangle == total:
					counter = counter + 1
			
			total = 0
			
	print counter
				
	
def problem_21():
    total = 0
    for i in range(1, 10000):
        first_sum = 0
        second_sum = 0
        for j in range(1, i/2 + 1):
            if i % j == 0:
                first_sum += j

        for k in range(1, first_sum/2 + 1):
            if first_sum % k == 0:
                second_sum += k

        if (second_sum == i) and (first_sum != i):
            total += i
            
    print total
    
def problem_97():
    print str((28433 * 2**7830457 + 1)%10**10)[-10:]
    
def problem_9():
    for a in range(999,0,-1):
        for b in range(1,999-a):
            for c in range(1,999-a):
                if ((a**2 + b**2 == c**2) and (a+b+c == 1000)):
                    print a*b*c
                    return 0
         
def problem_12():
    triangle = 1
    def divisors(n):
        count = 2
        i = 2
        while(i**2 < n):
            if (n % i == 0):
                count += 2
            i += 1
        if i **2 == n:
            count += 1
        return count  

    for i in xrange(1, 10000000):
        counter = 0
        triangle += i + 1
        if divisors(triangle) > 500:
            print triangle
            break
    
    
def problem_206():
    for i in xrange(1389026670, 1010101070, -100):
        string = str(i**2)
        if string[::2] == "1234567890":
            print i
            break
            
def problem_80():
    getcontext().prec = 102
    total = 0
    for i in range(1, 101):
        if (i != 1) and (i != 4) and (i != 9) and (i != 16) and (i != 25) and (i != 36) and (i != 49) and (i != 64) and (i != 81) and (i != 100):
            square = str(Decimal(i).sqrt())  
            total += int(square[0])
            for decimals in range(101, 2, -1):
                total += int(square[-decimals])
    print total

def problem_92():
    counter = 0
    list_of_89 = []
    for i in xrange(1, 568):
        final = i
        while (final != 1) and (final != 89):
            temp = 0
            for j in str(final):
                temp += int(j)*int(j)
            
            final = temp           
            
        if final == 89:
            list_of_89.append(i)

    for k in xrange(1, 10000000):
         temp = 0
         for l in str(k):
            temp += int(l)*int(l)
            
         if temp in list_of_89:
              counter = counter + 1
              
    print counter
    
def problem_25():
    fib1 = 0
    fib2 = 1
    counter = 1
    while len(str(fib2)) != 1000:
        temp = fib2
        fib2 = fib1 + fib2
        fib1 = temp
        counter = counter + 1
    print counter
    
def problem_19():
    current_day = 2
    counter = 0
    months = [31,28,31,30,31,30,31,31,30,31,30,31]
    leap_months = [31,29,31,30,31,30,31,31,30,31,30,31]
    for year in range(1901,2001):
        if year % 4 != 0:
            for month in range(0, 12):
                current_day += (months[month] % 7)
                if current_day % 7 == 0:
                    counter = counter + 1
        else:
            for month in range(0, 12):
                current_day += (leap_months[month] % 7)
                if current_day % 7 == 0:
                    counter = counter + 1

    print counter
          
def problem_53():
     counter = 0
     for n in range(1, 101):
        for r in range(1, n+1):
            if(math.factorial(n) / (math.factorial(r)*math.factorial(n-r)) >= 1000000):
                    counter = counter + 1
     print counter
     
     
def problem_41():
    perms = [''.join(p) for p in permutations('7654321')]
    for j in range(0,len(perms)):
        if isPrime(int(perms[j])):
            print perms[j]
            break
                        
def problem_39():
    sum = 0
    longest_len = 0
    for p in range(12, 1001):
        num_solutions = 0
        for a in range(3, p):
            if(p*(p-2*a) % (2*(p-a)) == 0):
                num_solutions += 1
        if (num_solutions > longest_len):
            longest_len = num_solutions
            sum = p
    print sum
    
def problem_22():
    total = 0
    f = open('problem_22.txt', 'r')
    sorted_list = sorted((str(f.readline())).split(","))
    for i in range(0, len(sorted_list)):
        name_total = 0
        for c in sorted_list[i][1:-1]:
            name_total += (ord(c) - 64)
        total += (name_total * (i+1))
        
    print total
    
def problem_23():
    total = 0
    final = 0
    abundant_list = []
    numbers_as_two_abundants = []
    for i in range(12, 20162):
        divisor_total = 0
        for j in range(1,(i/2 + 1)):
            if i % j == 0:
                divisor_total += j
        
        if divisor_total > i:
            abundant_list.append(i)

    for k in range(0, len(abundant_list)):
        for l in range(k, len(abundant_list)):
            if abundant_list[k] + abundant_list[l] < 20162:
                numbers_as_two_abundants.append((abundant_list[k] + abundant_list[l]))
            else:
                break
            
    numbers_as_two_abundants = set(numbers_as_two_abundants)
    for m in range(1, 20162):
        if m not in numbers_as_two_abundants:
            final += m
            
    print final
                
def problem_26():
    longest_recurring = 0
    for i in range(2,1000):
        try:
            number = divide(1, i).split("[")
            if len(number[1][0:-1]) > longest_recurring:
                longest_recurring = len(number[1][0:-1])
                number_with_longest_recurring = i
        except:
            pass

    print number_with_longest_recurring
    
def problem_31():
    counter = 0
    for p200 in range(0,2):
        for p100 in range(0,3):
            for p50 in range(0,5):
                for p20 in range(0, 11):
                    for p10 in range(0, 21):
                        for p5 in range(0, 41):
                            for p2 in range(0, 101):
                                total = 200*p200 + 100*p100 + 50*p50 + 20*p20 + 10*p10 + 5*p5 + 2*p2
                                if total > 200:
                                    break
                                else:
                                    counter += 1
    print counter
    
    """ SOLUTION THAT I FOUND AFTER THAT I REALLY LIKE """
    COINS, COINS[0] = [0]*201, 1
    for x in [1,2,5,10,20,50,100,200]:
        for y in xrange(x, 201):
            COINS[y] += COINS[y-x]
    print COINS[200]
        
def problem_24():
    print list(itertools.permutations([0,1,2,3,4,5,6,7,8,9], 10))[999999]
    
def problem_20():
    print sum([int(i) for i in str(math.factorial(100))])
    
def problem_47():
    consecutive = 0
    for j in range(1,1000000):
        prime_counter = 0
        fac = factors(j)
        for primes in fac:
            if isPrime(int(primes)):
                prime_counter += 1
        if prime_counter >= 4:
            if consecutive == 0:
                consecutive += 1
                first = j
            elif consecutive == 1 and j == first + 1:
                consecutive += 1
                second = j
            elif consecutive == 2 and j == second + 1:
                consecutive += 1
                third = j
            elif consecutive == 3 and j == third + 1:
                print j - 3
                break
        else:
            consecutive = 0 
        
def problem_45():
    triangle = set()
    pentagonal = set()
    hexagonal = set()
    for k in range(1, 100000):
        triangle.add(k*(k+1)/2)
        pentagonal.add(k * (k * 3 - 1) / 2)
        hexagonal.add(k*(k*2 -1))
    
    print triangle.intersection(pentagonal.intersection(hexagonal))
    
    
def problem_49():
    prime_list = []
    for i in range(1000, 10001):    # The problem states a 4 digit value, so only get 4 digit value prime numbers and store in list
        if isPrime(i):
            prime_list.append(i)
            
    for j in range(0, len(prime_list)):                             # Iterate through each list of primes
        for k in range(j+1, len(prime_list)):                       # Go through all values greater than current prime value j
            difference = prime_list[k] - prime_list[j]             # determine difference between these values greater than j and j
            if prime_list[k] + difference in prime_list:           # check to see if there is a third value that increments by variable difference in the list
                if sorted(str(prime_list[j])) == sorted(str(prime_list[k])) == sorted(str(prime_list[k] + difference)): # Now that we found an incremental pattern, verify if numbers are identical
                    print str(prime_list[j]) + str(prime_list[k]) + str(prime_list[k] + difference)     # Concatenate all three values and print it
                    
def problem_15():
    """ PROGRAMMING APPROACH USING CONCEPT OF PASCAL TRIANGLE """
    def pascal(n, show = True):
        global r1
        r1 = [1]
        r2 = [1, 1]
        degree = 1
        while degree <= n:
            r1 = r2
            r2 = [1] + [sum(pair) for pair in zip(r2, r2[1:]) ] + [1]
            degree += 1
            if show == True:
                print r1
            
    def grid_combinations(squares, show):
        global r1
        pascal(squares*2, show)
        print r1[squares]
    
    grid_combinations(20, show = False)
    
    """ ONE LINER USING STATISTICAL APPROACH """
    print factorial(40) / (factorial(20)**2)
    
def problem_28():
    total = 1                               # The center is the only one that doesn't have 4 corners, so I set the start as the center value
    current = 1                             # current keeps track of the value of the current corner. Because 1 is the start, so too is the current
    for i in range(3, 1002, 2):           # The grid is 1001x1001. Because there are 2 corners per row/column, we need to iterate by 2
        for k in range(1,5):               # There are 4 values for each square created
            current += (i-1)                # Updates the value of the current corner. As rows are added, the current value increases by (i-1)
            total += current                # add current value to total value to get all corners
            
    print total
    
def problem_29():
    terms = set()
    for a in range(2,101):                  # Go through all values for a in the formula a^b
        for b in range(2, 101):             # Go through all values for b in the formaul a^b
            terms.add(a**b)                 # Add the value to a set, which automatically removes duplicates
            
    print len(terms)
    
def problem_34():
    total = 0
    # Initially, I had just guessed 100,000 as the limit. I found the answer rather quickly because
    # the limit was actually ~41k due to the solution. Using math to determine the actual limit though,
    # the answer would be somewhere above 9!. Just to be safe and lazy, I chose 10!. Although, going back after
    # the actual limit was found to be 9!*7. This is where the having an additional digit for a the starting value
    # would not increase the number of digits in the factorial sum.
    for loops in range(1,factorial(10)):                                
        sum = 0                                 # Reset factorial sum for each number loop                          
        for k in str(i):                       # Add the factorial of each digit in current number to sum
            sum += factorial(int(k))       
            if sum > i:                         # Don't waste time factoring if sum already exceeds initial number
                break
            elif sum == i:                      # If sum = initial number, a solution has been found, add to total
                total += i
                
    print total
        

start_time = time.time()
problem_145()
print (time.time() - start_time), "Seconds"