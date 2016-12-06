from math import *
import time
from decimal import *
from sets import *
from euler_funcs import *
from sympy import sieve
import numpy as np
from itertools import *
from fractions import Fraction
from operator import *
from operator import xor
from statistics import mode

class Problem(object):
   def problem_99(self):
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
       
       
   def problem_50(self):
       highest = 0
       longest_counter = 0
       primes = primesfrom2to(10000)
       for i in range(0, len(primes)):
           total = int(primes[i])
           counter = 0
           
           for k in range(i+1, len(primes)):
               total += int(primes[k])
               counter += 1
               if isPrime(total):
                  if total > highest and counter > longest_counter and total < 1000000:
                     highest = total
                     longest_counter = counter
                  elif total >= 1000000:
                      break

       print highest
       
   def problem_13(self):
       f = open('problem_23.txt', 'r')                         # Open file
       total = 0
       for i in range(0,100):                                   # 100 lines of text, go through each line
           total += int(f.readline())                          # Add line value to total
       print str(total)[0:10]                                  # Print last 10 digits of total
       
   def problem_48(self):
       total = 0
       for i in range(1,1001):                             # Loop through all 1000 values
           total += pow(i, i)                               # Add i^i to total
       print str(total)[-10:]                              # Print last 10 digits of total
       
   def problem_56(self):
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
       
   def problem_16(self):
       total = 0
       for i in str(2**1000):                      # Simply loop through all digits in 2^1000 and add them up
           total += int(i)
           
       print total
      

   def problem_55(self):
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
         
            
            
   def problem_87(self):    
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
               

   def problem_145(self):
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
      
       for i in xrange (1, 10000000,2):       # Couldn't think of any method aside from bruteforce. Was able to iterate by 2 though because any number that is a palindrome
           if reversible(i):                    # will begin with even and end in odd, or vice-versa, to make an odd number in the end
               counter = counter + 1           # So, we only need to check for one of the solutions by looking at odds then double it.
            
       print counter*2
            
     
   def problem_30(self):
       total = 0
       for i in range(2, 9**6):                # The limit is 9^6 because past 9^6, then the amount of digits in the starting value are by a factor of at least 10 larger
          temp = 0                              # than the power of all digits added together. So, this is where it becomes impossible for a solution to be found.
         
          for length in str(i):              # Go through the value, and raise each digit to the power of 5 and add up
             temp += int(length)**5
         
          if temp == i:                       # If power value equals original, increase counter
             total += temp
            
       print "TOTAL IS", total
      
   def problem_18_67(self,problem):             # Managed to combine to problems into one since they are the same, just call on different triangles of different sizes
       if problem == 18:
           size_of_triangle = 15
           f = open('problem_18.txt', 'r')     # Read in proper text file and triangle size based on problem number specified
       elif problem == 67:
           size_of_triangle = 100
           f = open('problem_67.txt', 'r')
           
       triangles = []
       
       for i in range(0,size_of_triangle):                         # Add each row of the text to the triangle list, splitting the values based on spaces
           triangles.append(f.readline().strip().split(" "))
           map(int, triangles[i])                                         # Make everything an int for future use
       triangles = [map(int, x) for x in triangles]
       
       for row in range(size_of_triangle-1,0,-1):                # Iterate through the current row variables, decreasing the length of variables by 1 each time as you go up
           if triangles[row][row] > triangles[row][row-1]:      # Checks to see if the number to the left of the current variable is greater than the variable or not         
               triangles[row-1][row-1] += triangles[row][row]
           else:
               triangles[row-1][row-1] += triangles[row][row-1]
           for element in range(row - 2, -1, -1):
               if triangles[row][element] > triangles[row][element+1]:     # Checks to see if the variable to the right of the current variable is greater than the variable or not
                  triangles[row-1][element] += triangles[row][element]
               else:                                                               # Based on the results, it adds the value to the value directly above it a row and the process repeats.
                  triangles[row-1][element] += triangles[row][element+1]
                       
       print triangles[0]
               
   def problem_42(self):
       f = open('problem_42.txt', 'r')
       words = f.readline()
       words = (words.replace(",", ""))
       quote = '"'
       total = 0
       counter = 0
       for i in words:                                # go through each character in txt file

           if i != quote:                             # Ignore quotes when adding ascii value. Once you hit a quote, it will continue on with the next step
              total += ord(i) - 64
            
           else:
              verify_triangle = 0
              for j in range(1, 19):                 # Loop through, creating the triangle numbers and checking if the word is a triangle number 
                  verify_triangle += j
                  if verify_triangle == total:
                     counter = counter + 1          # Add to counter if it is
            
              total = 0                              # Reset counter for next word
            
       print counter
               
      
   def problem_21(self):
       total = 0
       for i in range(1, 10000):
           first_sum = 0
           second_sum = 0
           for j in range(1, i/2 + 1):                      # Find all numbers first number is divisible by and add up for second number
              if i % j == 0:
                  first_sum += j

           for k in range(1, first_sum/2 + 1):            # Find all sums second number is divisible by and and add up 
              if first_sum % k == 0:
                  second_sum += k

           if (second_sum == i) and (first_sum != i):    # Check if the second sum equals the first number
              total += i
               
       print total
       
   def problem_97(self):
       print str((28433 * 2**7830457 + 1)%10**10)[-10:]        # Complete the calculation, truncating 10^10 0s to quicken the math. Print out last 10 characters of int
       
   def problem_9(self):
       for a in range(999,0,-1):                                        # Change value of one of the triangles
           for b in range(1,999-a):                                     # Change other triangle values, keeping them total less no greater than 1000
              for c in range(1,999-a):
                  if ((a**2 + b**2 == c**2) and (a+b+c == 1000)):    # If the triangle loop is a pythagorean triangle and the sum is 1000, print and exit program
                     print a*b*c
                     return 0
            
   def problem_12(self):
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
       
       
   def problem_206(self):
       for i in xrange(1389026670, 1010101070, -100):
           string = str(i**2)
           if string[::2] == "1234567890":
              print i
              break
               
   def problem_80(self):
       getcontext().prec = 102
       total = 0
       for i in range(1, 101):
           if (i != 1) and (i != 4) and (i != 9) and (i != 16) and (i != 25) and (i != 36) and (i != 49) and (i != 64) and (i != 81) and (i != 100):
              square = str(Decimal(i).sqrt())  
              total += int(square[0])
              for decimals in range(101, 2, -1):
                  total += int(square[-decimals])
       print total

   def problem_92(self):
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
       
   def problem_25(self):
       fib1 = 0
       fib2 = 1
       counter = 1
       while len(str(fib2)) != 1000:
           temp = fib2
           fib2 = fib1 + fib2
           fib1 = temp
           counter = counter + 1
       print counter
       
   def problem_19(self):
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
             
   def problem_53(self):
        counter = 0
        for n in range(1, 101):
           for r in range(1, n+1):
               if(math.factorial(n) / (math.factorial(r)*math.factorial(n-r)) >= 1000000):
                       counter = counter + 1
        print counter
        
        
   def problem_41(self):
       perms = [''.join(p) for p in permutations('7654321')]
       for j in range(0,len(perms)):
           if isPrime(int(perms[j])):
               print perms[j]
               break
                           
   def problem_39(self):
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
       
   def problem_22(self):
       total = 0
       f = open('problem_22.txt', 'r')
       sorted_list = sorted((str(f.readline())).split(","))
       for i in range(0, len(sorted_list)):
           name_total = 0
           for c in sorted_list[i][1:-1]:
               name_total += (ord(c) - 64)
           total += (name_total * (i+1))
           
       print total
       
   def problem_23(self):
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
       
   def problem_8(self):
       total = 0
       product = 1
       number = ""
       f = open('problem_8.txt', 'r') 
       for i in f:
           number += i.strip()
           
       for k in range(0, 986):
           for l in range(0, 13):
               product *= int(number[k+l])

           if product > total:
               total = product
           
           product = 1
           
       print total
           
   def problem_26(self):
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
       
   def problem_31(self):
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
       COINS = [1] + [0]*200
       for x in [1,2,5,10,20,50,100,200]:
           for y in xrange(x, 201):
               COINS[y] += COINS[y-x]
       print COINS[200]
           
   def problem_24(self):
       print list(itertools.permutations([0,1,2,3,4,5,6,7,8,9], 10))[999999]
       
   def problem_20(self):
       print sum([int(i) for i in str(math.factorial(100))])
       
   def problem_47(self):
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
           
   def problem_45(self):
       triangle = set()
       pentagonal = set()
       hexagonal = set()
       for k in range(1, 100000):
           triangle.add(k*(k+1)/2)
           pentagonal.add(k * (k * 3 - 1) / 2)
           hexagonal.add(k*(k*2 -1))
       
       print triangle.intersection(pentagonal.intersection(hexagonal))
       
       
   def problem_49(self):
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
                       
   def problem_15(self,show):
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
       
       grid_combinations(20, show)
       
       """ ONE LINER USING STATISTICAL APPROACH """
       print factorial(40) / (factorial(20)**2)
       
   def problem_28(self):
       total = 1                               # The center is the only one that doesn't have 4 corners, so I set the start as the center value
       current = 1                             # current keeps track of the value of the current corner. Because 1 is the start, so too is the current
       for i in range(3, 1002, 2):           # The grid is 1001x1001. Because there are 2 corners per row/column, we need to iterate by 2
           for k in range(1,5):               # There are 4 values for each square created
               current += (i-1)                # Updates the value of the current corner. As triangles are added, the current value increases by (i-1)
               total += current                # add current value to total value to get all corners
               
       print total
       
   def problem_29(self):
       terms = set()
       for a in range(2,101):                  # Go through all values for a in the formula a^b
           for b in range(2, 101):             # Go through all values for b in the formaul a^b
               terms.add(a**b)                 # Add the value to a set, which automatically removes duplicates
               
       print len(terms)
       
   def problem_34(self):
       total = 0
       # Initially, I had just guessed 100,000 as the limit. I found the answer rather quickly because
       # the limit was actually ~41k due to the solution. Using math to determine the actual limit though,
       # the answer would be somewhere above 9!. Just to be safe and lazy, I chose 10!. Although, going back after
       # the actual limit was found to be 9!*7. This is where having an additional digit for the starting value
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

   def problem_81(self):
       f = open('problem_81.txt', 'r') 
       for i in range(80):
           line = f.readline()
           print line
           
           
   def problem_27(self):
       counter = 0
       largest_chain = 0
       for a in range(-999, 1000, 2):
           for b in range(1000):
               n = 0
               while True:
                   if isPrime(abs((n**2) + (a*n) + b)):
                       n += 1
                   else:
                       if n > largest_chain:
                           largest_chain = n
                           prod = a*b
                       break
       print prod
           
   def problem_43(self):
       total = 0
       perms = (list(permutations([0,1,2,3,4,5,6,7,8,9], 10)))
       
       for i in range(0, len(perms) - 1):
           if (perms[i][7]*100 + perms[i][8]*10 + perms[i][9]) % 17 == 0:
               if (perms[i][6]*100 + perms[i][7]*10 + perms[i][8]) % 13 == 0:
                   if (perms[i][5]*100 + perms[i][6]*10 + perms[i][7]) % 11 == 0:
                       if (perms[i][4]*100 + perms[i][5]*10 + perms[i][6]) % 7 == 0:
                           if (perms[i][3]*100 + perms[i][4]*10 + perms[i][5]) % 5 == 0:
                               if (perms[i][2]*100 + perms[i][3]*10 + perms[i][4]) % 3 == 0:
                                   if (perms[i][1]*100 + perms[i][2]*10 + perms[i][3]) % 2 == 0:
                                       solution = ''.join(c for c in str(perms[i]) if c in '0123456789')
                                       total += int(solution)
       print total
       
   def problem_36(self):
       def is_palindrome(number):
           if int(str(number)[::-1]) == number:
               return True
           else: return False
           
       sum = 0
       for i in range(1000000):
           if is_palindrome(i):
               if is_palindrome(int(bin(i)[2:])):
                   sum += i
       print sum
       
   def problem_44(self):
      def pentagonal(n):
          return n * (3 * n - 1) / 2

      pentagonals = set(pentagonal(n) for n in range(1, 3000))
      c = combinations(pentagonals, 2)
      for p in c:
          if p[0]+p[1] in pentagonals and abs(p[0]-p[1]) in pentagonals:
              print abs(p[0]-p[1])
              break
          
       
   def problem_37(self):
       primes = primesfrom2to(1000000)
       total = 0
       for i in range(1, len(primes)):        
           string_prime = 0                                                                                # Sort through the prime numbers list
           for j in range(1, len(str(primes[i]))):                                                     # Sort throught the string of digits in each element
               if isPrime(int(str(primes[i])[j::])) and isPrime(int(str(primes[i])[0:j])):       # If a portion is prime in both directions, continue
                   string_prime += 1
                   if string_prime == len(str(primes[i])) - 1:
                       total += int(primes[i])
               else:
                   break
       print total
    
   def problem_52(self):
        n = 3
        while True:
           if all("".join(sorted(str(x))) == "".join(sorted(str(n))) for x in (n*2,n*3,n*4,n*5,n*6)):
               print n
               break
           n += 3 
           
   def problem_58(self):
       composite = 1
       prime = 0
       side_length = 1
       current = 1                             # current keeps track of the value of the current corner. Because 1 is the start, so too is the current
       i = 3
       while True:
           for k in range(1,5):               # There are 4 values for each square created
               current += (i-1)                # Updates the value of the current corner. As triangles are added, the current value increases by (i-1)

               if isPrime(current):
                  prime += 1
               else:
                  composite += 1
                  
           side_length += 2
           if float(prime) / float(composite + prime) < float(0.10):
               print side_length
               break
               
           i += 2
    
   def problem_76(self):
       NUMBERS = [1] + [0]*100
         
       for x in range(1,100):
           for y in xrange(x, 101):
               NUMBERS[y] += NUMBERS[y-x]
       print NUMBERS[100]
       
       
   # def problem_54(self):
       # f = open('problem_54.txt', 'r')                                         # Read in the file that contains base and exponent combination values                                           
       # for i in range(1000):                                                     # Go through all 1000 lines of code
           # cards = []
           # string_line = f.readline().strip().split(" ")
           # for i in string_line:
               # cards.append(i[0])
           
           # player_one = sorted(cards[0:5])
           # player_two = sorted(cards[6:10])
           
           # print player_one
           
           
   # def problem_357(self):
        # global total
        # total = 0
        # def divisors_isPrime(number):
           # global total
           # for x in range(1, (number/2) +1):
               # if number % x == 0:
                  # if not isPrime(x+ (number / x)):
                     # return False
           # print number, "meets this"          
           # total += number
                     
        # for i in xrange(2, 100001, 4):
           # divisors_isPrime(i)
           
        # print total + 1
        
    # def problem_85(self):
        # def pascal(n, show = True):
        # global r1
        # r1 = [1]
        # r2 = [1, 1]
        # degree = 1
        # while degree <= n:
            # r1 = r2
            # r2 = [1] + [sum(pair) for pair in zip(r2, r2[1:]) ] + [1]
            # degree += 1
            # if show == True:
                # print r1
                
   def problem_112(self):
       not_bouncy = 2178
       bouncy = 19602
       
       i = 21781
       while True:
           if i != int("".join(sorted(str(i)))) and i != int("".join(reversed(sorted(str(i))))):
               bouncy += 1
           else:
               not_bouncy += 1

           if float(bouncy) / float(bouncy + not_bouncy) > 0.99:
               print i - 1
               break
               
           i += 1
           
   def problem_79(self):
        numbers = set()
        f = open('problem_79.txt', 'r') 
        for i in f:
           numbers.add(i.strip())
        print list(numbers)[0]
        
   def problem_33(self):
       num = 1
       den = 1
       for denominator in range(10, 100):
            for numerator in range(10, denominator):
                if int(str(denominator)[0]) == int(str(numerator)[1]) and int(str(denominator)[1]) != 0:
                  if float(numerator)/float(denominator) == float(int(str(numerator)[0])) / float(int(str(denominator)[1])):
                     num *= int(str(numerator)[0])
                     den *= int(str(denominator)[1])
                     
       print den / num
       
   def problem_59(self):
       encryption = [79,59,12,2,79,35,8,28,20,2,3,68,8,9,68,45,0,12,9,67,68,4,7,5,23,27,1,21,79,85,78,79,85,71,38,10,71,27,12,2,79,6,2,8,13,9,1,13,9,8,68,19,7,1,71,56,11,21,11,68,6,3,22,2,14,0,30,79,1,31,6,23,19,10,0,73,79,44,2,79,19,6,28,68,16,6,16,15,79,35,8,11,72,71,14,10,3,79,12,2,79,19,6,28,68,32,0,0,73,79,86,71,39,1,71,24,5,20,79,13,9,79,16,15,10,68,5,10,3,14,1,10,14,1,3,71,24,13,19,7,68,32,0,0,73,79,87,71,39,1,71,12,22,2,14,16,2,11,68,2,25,1,21,22,16,15,6,10,0,79,16,15,10,22,2,79,13,20,65,68,41,0,16,15,6,10,0,79,1,31,6,23,19,28,68,19,7,5,19,79,12,2,79,0,14,11,10,64,27,68,10,14,15,2,65,68,83,79,40,14,9,1,71,6,16,20,10,8,1,79,19,6,28,68,14,1,68,15,6,9,75,79,5,9,11,68,19,7,13,20,79,8,14,9,1,71,8,13,17,10,23,71,3,13,0,7,16,71,27,11,71,10,18,2,29,29,8,1,1,73,79,81,71,59,12,2,79,8,14,8,12,19,79,23,15,6,10,2,28,68,19,7,22,8,26,3,15,79,16,15,10,68,3,14,22,12,1,1,20,28,72,71,14,10,3,79,16,15,10,68,3,14,22,12,1,1,20,28,68,4,14,10,71,1,1,17,10,22,71,10,28,19,6,10,0,26,13,20,7,68,14,27,74,71,89,68,32,0,0,71,28,1,9,27,68,45,0,12,9,79,16,15,10,68,37,14,20,19,6,23,19,79,83,71,27,11,71,27,1,11,3,68,2,25,1,21,22,11,9,10,68,6,13,11,18,27,68,19,7,1,71,3,13,0,7,16,71,28,11,71,27,12,6,27,68,2,25,1,21,22,11,9,10,68,10,6,3,15,27,68,5,10,8,14,10,18,2,79,6,2,12,5,18,28,1,71,0,2,71,7,13,20,79,16,2,28,16,14,2,11,9,22,74,71,87,68,45,0,12,9,79,12,14,2,23,2,3,2,71,24,5,20,79,10,8,27,68,19,7,1,71,3,13,0,7,16,92,79,12,2,79,19,6,28,68,8,1,8,30,79,5,71,24,13,19,1,1,20,28,68,19,0,68,19,7,1,71,3,13,0,7,16,73,79,93,71,59,12,2,79,11,9,10,68,16,7,11,71,6,23,71,27,12,2,79,16,21,26,1,71,3,13,0,7,16,75,79,19,15,0,68,0,6,18,2,28,68,11,6,3,15,27,68,19,0,68,2,25,1,21,22,11,9,10,72,71,24,5,20,79,3,8,6,10,0,79,16,8,79,7,8,2,1,71,6,10,19,0,68,19,7,1,71,24,11,21,3,0,73,79,85,87,79,38,18,27,68,6,3,16,15,0,17,0,7,68,19,7,1,71,24,11,21,3,0,71,24,5,20,79,9,6,11,1,71,27,12,21,0,17,0,7,68,15,6,9,75,79,16,15,10,68,16,0,22,11,11,68,3,6,0,9,72,16,71,29,1,4,0,3,9,6,30,2,79,12,14,2,68,16,7,1,9,79,12,2,79,7,6,2,1,73,79,85,86,79,33,17,10,10,71,6,10,71,7,13,20,79,11,16,1,68,11,14,10,3,79,5,9,11,68,6,2,11,9,8,68,15,6,23,71,0,19,9,79,20,2,0,20,11,10,72,71,7,1,71,24,5,20,79,10,8,27,68,6,12,7,2,31,16,2,11,74,71,94,86,71,45,17,19,79,16,8,79,5,11,3,68,16,7,11,71,13,1,11,6,1,17,10,0,71,7,13,10,79,5,9,11,68,6,12,7,2,31,16,2,11,68,15,6,9,75,79,12,2,79,3,6,25,1,71,27,12,2,79,22,14,8,12,19,79,16,8,79,6,2,12,11,10,10,68,4,7,13,11,11,22,2,1,68,8,9,68,32,0,0,73,79,85,84,79,48,15,10,29,71,14,22,2,79,22,2,13,11,21,1,69,71,59,12,14,28,68,14,28,68,9,0,16,71,14,68,23,7,29,20,6,7,6,3,68,5,6,22,19,7,68,21,10,23,18,3,16,14,1,3,71,9,22,8,2,68,15,26,9,6,1,68,23,14,23,20,6,11,9,79,11,21,79,20,11,14,10,75,79,16,15,6,23,71,29,1,5,6,22,19,7,68,4,0,9,2,28,68,1,29,11,10,79,35,8,11,74,86,91,68,52,0,68,19,7,1,71,56,11,21,11,68,5,10,7,6,2,1,71,7,17,10,14,10,71,14,10,3,79,8,14,25,1,3,79,12,2,29,1,71,0,10,71,10,5,21,27,12,71,14,9,8,1,3,71,26,23,73,79,44,2,79,19,6,28,68,1,26,8,11,79,11,1,79,17,9,9,5,14,3,13,9,8,68,11,0,18,2,79,5,9,11,68,1,14,13,19,7,2,18,3,10,2,28,23,73,79,37,9,11,68,16,10,68,15,14,18,2,79,23,2,10,10,71,7,13,20,79,3,11,0,22,30,67,68,19,7,1,71,8,8,8,29,29,71,0,2,71,27,12,2,79,11,9,3,29,71,60,11,9,79,11,1,79,16,15,10,68,33,14,16,15,10,22,73]
       decryption = ""
       total = 0
       first, second, third, first_decryption, second_decryption, third_decryption = [], [], [], [], [], []
       
       for i in range(0, len(encryption), 3):
           first.append(encryption[i])
           
       for j in range(1, len(encryption), 3):
           second.append(encryption[j])
           
       for k in range(2, len(encryption), 3):
           third.append(encryption[k])
       
       first_key = xor(mode(first), 32)
       second_key = xor(mode(second), 32)
       third_key = xor(mode(third), 32)
       
       for l in first:
           total += xor(l, first_key)
           first_decryption.append(unichr(xor(l, first_key)))

       for m in second:
           total += xor(m, second_key)
           second_decryption.append(unichr(xor(m, second_key)))
           
       for n in third:
           total += xor(n, third_key)
           third_decryption.append(unichr(xor(n, third_key)))
            
       for character in range(0, 401):
           decryption += (first_decryption[character])
           try:
                decryption += (second_decryption[character])
                decryption += (third_decryption[character])
           except:
                pass
                
       print "The key is:", unichr(first_key) + unichr(second_key) + unichr(third_key)
       print decryption
       print total
       
   def problem_35(self):
       circular = 13
       prime_rotate = True
       def rotate(strg,n):
           return strg[n:] + strg[:n]
           
       primes = primesfrom2to(1000000)
       
       for k in range(25, len(primes)):
           for l in range(1, len(str(primes[k])) +1):
               if not isPrime(int(rotate(str(primes[k]), l))):
                  prime_rotate = False
                  break

           if prime_rotate == True:
               circular += 1
          
           prime_rotate = True
       print circular
       
   def problem_11(self):
       text = []
       largest = 0
       f = open('problem_11.txt', 'r')
       for i in range(1,21):
           text.append(f.readline().strip().split(" "))
       
       for row in range(0, 20):
           for column in range(0,20):
              
              if column < 17:
                 total = int(text[row][column]) * int(text[row][column+1]) * int(text[row][column+2]) * int(text[row][column+3])
                 if total > largest:
                     largest = total
              
              if row < 17:
                  total = int(text[row][column]) * int(text[row+1][column]) *int(text[row+2][column]) * int(text[row+3][column])
                  if total > largest:
                     largest = total
              
              if column < 17 and row < 17:
                  total = int(text[row][column]) * int(text[row+1][column+1]) * int(text[row+2][column+2]) * int(text[row+3][column+3])
                  if total > largest:
                     largest = total
                     
              if row > 2 and column < 17:
                  total = int(text[row][column]) * int(text[row-1][column+1]) * int(text[row-2][column+2]) * int(text[row-3][column+3])
                  if total > largest:
                      largest = total
        
       print largest
       
   def problem_32(self):
        products = []
        for i in xrange(2,10000):
            for j in xrange(1,1000000000):
               if len(str(i) + str(j) + str(i*j)) > 9:
                  break
               
               elif len(str(i) + str(j) + str(i*j)) == 9:
                  if "".join(sorted(str(i) + str(j) + str(i*j))) == '123456789':
                     if i*j not in products:
                         products.append(i*j)
                         
        print sum(products)
                  
   def problem_38(self):
        largest = 0
        for i in xrange(1, 10000):
           pan = str(i)
           multiple = 2
           while len(pan) < 9:
               pan += str(i*multiple)
               multiple += 1
          
           if len(pan) == 9 and "".join(sorted(pan)) == '123456789' and largest < pan:
              largest = pan
              
        print largest
        
   def problem_40(self):
       fraction = "1"
       for i in range(1,1000000):
           fraction += str(i)
       
       print int(fraction[1]) * int(fraction[10]) * int(fraction[100]) * int(fraction[1000]) * int(fraction[10000]) * int(fraction[100000]) * int(fraction[1000000])
   
   def problem_63(self):
       total = 1
       for i in range(2,10):
           power = 1
           while power <= len(str(i ** power)):
               if len(str(i**power)) == power:
                  total += 1
               power += 1
               
       print total
                  
               
       
if __name__ == '__main__':   
   start_time = time.time()
   problem_class = Problem()
   problem_class.problem_57()
   print (time.time() - start_time), "Seconds"