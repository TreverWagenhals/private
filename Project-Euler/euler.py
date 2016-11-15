import math
import time
from euler_funcs import isPrime
from euler_funcs import primesfrom2to
from euler_funcs import divide
from decimal import *
from sympy import sieve
import numpy
import itertools
from itertools import permutations
from fractions import Fraction  
import csv

def problem_99():
    f = open('problem_99.txt', 'r')
    largest_line_value = 0

    for i in range(1000):
        string_line = f.readline()
        first_value_found = 0
        string_checker = 1
        
        while (first_value_found == 0):
            try: 
                int(string_line[0:string_checker])
            except:
                first_value_found = 1 #The value has been found
                first_value = int(string_line[0:string_checker-1])
                second_value = int(string_line[string_checker:])
                exponent = second_value * math.log10(first_value)
         
                if exponent > largest_line_value:
                    largest_line_value = exponent
                    largest_line = i + 1
                
            string_checker = string_checker + 1
            
    print largest_line    
    
def problem_13():
    f = open('problem_23.txt', 'r')
    total = 0
    for i in range(0,100):
        total += int(f.readline())
    print str(total)[0:10]
    
def problem_48():
    total = 0
    for i in range(1,1001):
        total += pow(i, i)
    print str(total)[-10:]
    
def problem_56():
    largest = 0
    for i in range(1,101):
        for j in range(1,101):
            sum = 0
            exponent = pow(i,j)
            for k in str(exponent):
                sum += int(k)
            if sum > largest:
                largest = sum
             
    print largest
    
def problem_16():
    total = 0
    for i in str(2**1000):
        total += int(i)
        
    print total
	

def problem_55():
	ly_count = 0
	for i in range(1,10000):
		it_count = 0
		temp = i
		for max_iterations in range(1,51):
			temp = temp + int(str(temp)[::-1])
			if temp == int(str(temp)[::-1]):
				break
			else:
				it_count = it_count + 1 
		
			if it_count == 50:
				ly_count = ly_count + 1
				
	print ly_count
		
			
			
def problem_87():    
    square_primes = primesfrom2to(int(50000000**.5))
    cube_primes = primesfrom2to(int(50000000**(.3333)))
    quad_primes = primesfrom2to(int(50000000**.25))

    x = set([])
    
    for j in square_primes:
        pow2 = pow(j,2)
        for k in cube_primes:
                pow3 = pow(k,3)
                for l in quad_primes:
                        pow4 = pow(l,4)
                        total = pow2 + pow3 + pow4
                        if total <= 50000000:
                            x.add(total)                                                 
    print len(x)
				

def problem_145():
	counter = 0
	def reversible(n):
		if (n % 10 == 0):
			return False
		sum = i + int(str(i)[::-1])
		while sum > 0:
			if ((sum % 10) % 2) == 0:
				return False
			sum /= 10
		return True
	
	for i in xrange (1, 100000000):
		if reversible(i):
			counter = counter + 1
			
	print counter
			
  
def problem_30():
	total = 0
	for i in range(2, 9**6):
		temp = 0
		
		for length in str(i):
			temp += int(length)**5
		
		if temp == i:
			total += temp
			
	print "TOTAL IS", total
		
		
# def problem_18():
	# f = open('problem_18.txt', 'r')
	# row = f.readline()
	# total = int(row)
	# print total
	# number = 0
	# for i in range (2, 16):
		# row = f.readline()
		# first_number = int(row[number:number+2])
		# second_number = int(row[number+3:number+5])
			
		# if second_number > first_number:
			# print "The old total was", total, ". The second number (", second_number, ") was larger than the first (", first_number, ")"
			# print total, "+", second_number, "=", total+second_number
			# total += int(second_number)
			# number = number + 3
		# else:
			# print "The old total was", total, ". The first number (", first_number, ") was larger than the second (", second_number, ")"
			# print total, "+", first_number, "=", total+first_number
			# total += int(first_number)
	
	# print total
	
# def problem_18_bottom_top():
	# f = open('problem_18.txt', 'r')
	# row = f.readlines()
	# bottom_row = row[14]
	
	# for j in range(0,43, 3):
		# bottom_variable = bottom_row[j:j+2]
		# number = j
		# total = int(bottom_variable)
		# max_number = 42

		# for i in range (13, -1, -1):
			# row_variables = row[i]
			# if number == 0:
				# total += int(row_variables[number:number+2])
			# elif number == max_number:
				# total += int(row_variables[number-3:number-1])
				# number -= 3
			# else:
				# if i != 0:
					# first_number = int(row_variables[number-3:number-1])
					# second_number = int(row_variables[number:number+2])

					# if first_number > second_number:
						# total += int(first_number)
						# number -= 3
					# else:		
						# total += int(second_number)
				# else:
					# total += 75
					
			# max_number -= 3
					
		# print "The total starting at", bottom_variable, "is", total
		
		
            
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
         
# def problem_12():
    # triangle = 1
    # counter = 0
    # for i in xrange(1, 10000000):
        # triangle += i + 1
        # for j in range (1, triangle+1):
            # if triangle % j == 0:
                # counter = counter + 1
        # if counter == 501:
            # print triangle
            # break
        # else:
            # counter = 0
    
    
def problem_206():
    for i in xrange(1389026670, 1010101070, -100):
        string = str(i**2)
        if string[::2] == "1234567890":
            print i
            break
            
# def problem_80():
    # getcontext().prec = 100
    # digital_total = 0
    # for i in range(1, 101):
        # total = 0
        # total += Decimal(i).sqrt()  
    
        # for k in range(1,98):
            # digital_total += int(str(total)[-k])
    
    # print digital_total

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
     
    """ FIRST ATTEMPT THAT FAILED """
    # primes = primesfrom2to(1000000000)
    # for i in xrange(len(primes)-1, 0, -1):          # we have the array of all primes. we go from last prime to first prime
        # numbers_match = False
        # for j in xrange(0,len(str(primes[i]))):                 # then, we have the length of the particular value in the array
            # if numbers_match == True:
                # break
            # for k in xrange(j+1,len(str(primes[i]))):           # next, we need to check that the current number in the value does not match any other numbers in the number
                # if str(primes[i])[k] == str(primes[i])[j]:
                    # numbers_match = True
                    # break
                    
        # if numbers_match == False:                      # There are no matching numbers at this point. we still need to check to see if they increment though
            # for m in range(0, len(str(primes[i])) - 1):
                # if int(sorted(str(primes[i]))[m])+1 != int(sorted(str(primes[i]))[m+1]):
                    # incremental = False
                    # break
                    
                # if incremental == True:    
                    # print str(primes[i])
                    
                    
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
    
start_time = time.time()
problem_31()
print (time.time() - start_time), "Seconds"