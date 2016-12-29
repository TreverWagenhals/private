import math
from collections import OrderedDict
def problem_71a():
   loops = input("")
   for i in range(0, loops):
      word = (raw_input())
      if len(word) > 10:
           word = word[0] + str(len(word) - 2) + word[-1]
      print word
      

def problem_1a():
    width, length, flagstone = raw_input().split()
    print  int(math.ceil(float(width) / float(flagstone)) * math.ceil(float(length) / float(flagstone)))
    
def problem_4a():
    weight = 0
    while weight < 1 or weight > 100:
        weight = input("")
    if weight % 2 == 0 and weight != 2:
        print "YES"
    else: print "NO"
    
    
def problem_158a():
    total = 0
    smallest = 1000
    participants, min = raw_input().split()
    score = raw_input().split()
    for x in score:
       if int(x) > 0 and total < int(min):
           total += 1
           if total == int(min):
               smallest = int(x)
       elif int(x) >= smallest:
           total += 1
               
    print total
    
def problem_118a():
    vowels = ['a', 'A', 'e', 'E', 'i', 'I', 'o', 'O', 'u', 'U']
    s = raw_input()
    
        
    print new_string 
    
def problem_50a():
    m, n = raw_input().split()
    print int(m) * int(n) / 2
    
def problem_231a():
    total = 0 
    problems = input("")
    for i in range(0, problems):
      Petya, Vasya, Tonya = raw_input("").split()
      if int(Petya)+int(Vasya)+int(Tonya) >= 2:
           total += 1
    print total
    

def problem_282a():
    total = 0
    runs = input("")
    for i in range(0, runs):
        command = raw_input()
        if command == '++X' or command == 'X++':
            total += 1
        elif command == '--X' or command == 'X--':
            total -= 1
    print total
    
def problem_96a():
    s = raw_input()
    yes = False
    for i in range(0, len(s)):
        total = 0
        for k in range(i, len(s)):
            if s[i] == s[k]:
               total += 1
            else: total = 0
            if total == 7:
                yes = True
              
    if yes:
       print "YES"
    else: print "NO"
            
def problem_112a():
    equal = True
    first = raw_input()
    second = raw_input()
    for i in range(0, len(first)):
        if first[i].upper() != second[i].upper():
            equal = False
            if ord(first[i].upper()) > ord(second[i].upper()):
               print "1"
            else: print "-1"
            break
    if equal:
        print "0"
          
          
def problem_339a():
    new_equation = ""
    equation = raw_input().replace("+", " ").split()
    for x in sorted(equation):
        new_equation += x + "+"
    print new_equation[0:-1]
    
def problem_116a():
    total = 0
    max = 0
    stops = input("")
    for i in range(0, stops):
      exit, enter = map(int, raw_input().split())
      total -= exit
      total += enter
      if total > max: max = total
    print max
    
def problem_131a():
    new_word = ""
    word = raw_input()
    for x in range(0, len(word)):
        if x == 0 and word != word.upper():
            new_word += word[x].upper()
        elif x == 0 and word == word.upper():
            new_word = word.lower()
            break
        elif word[x] != word[x].lower():
            new_word += word[x].lower()
        else:
            new_word = word
            break
    print new_word
    
def problem_266a():
    total = 0
    stones = input("")
    order = raw_input()
    for i in range(0, len(order)-1):
        if order[i] == order[i+1]:
            total += 1
    print total

def problem_133a():
    instructions = ['H','Q','9']
    command = False
    text = raw_input()
    for x in instructions:
        if x in text:
            command = True
            print "YES"
            break
    if command == False: print "NO"
    
def problem_281a():
    new_word = ""
    word = raw_input()
    for i in range(0, len(word)):
        if i == 0:
            new_word += word[i].upper()
        else:
            new_word += word[i]
    print new_word
    
def problem_122a():
    number = raw_input("")
    lucky = True
    for x in number:
        if x == '4' or x == '7':
            pass
        else:
            lucky = False
            if int(number) % 4 == 0 or int(number) % 7 == 0 or int(number) % 47 == 0 or int(number) % 74 == 0 or int(number) % 474 == 0:
                print "YES"
                break
            else:
               print "NO"
               break
    if lucky == True:
        print "YES"
                
def problem_58a():
    hello = ['h', 'e', 'l', 'l', 'o']
    letters = 0
    text = raw_input()
    for i in text:
        if letters == 5:
            break
        elif i == hello[letters] and letters < 5:
            letters += 1
    if letters == 5:
        print "YES"
    else: print "NO"
    
def problem_236a():
    text = raw_input()
    if len(set(text)) % 2 == 0:
        print "CHAT WITH HER!"
    else: print "IGNORE HIM!"
    
def problem_263a():
    total = 0
    for i in range(1,6):
        row = raw_input().split()
        if "1" in row:
            total += abs(3-i)
            for k in range(1,6): 
               if row[k-1] == "1":
                   total += abs(3-k)
    print total
            
def problem_467a():
    total = 0
    rooms = input("")
    for i in range(0, rooms):
         people, space = map(int, raw_input().split())
         if space - people >= 2:
            total += 1
    print total
    
def problem_546a():
    total = 0
    cost, money, bananas = map(int, raw_input().split())
    for i in range(1, bananas+1):
        total += cost * i
    if total - money > 0:    
      print total - money
    else: print "0"
    
def problem_148a():
    punch = input("")
    tail = input("")
    paws = input("")
    mom = input("")
    dragons = input("")
    total = 0
    for i in range(1,dragons+1):
        if i % punch == 0 or i % tail == 0 or i % paws == 0 or i % mom == 0:
            total += 1
    print total
    
def problem_110a():
    lucky_numbers = 0
    number = raw_input("")
    for x in number:
        if int(x) == 7 or int(x) == 4:
            lucky_numbers += 1
    if (lucky_numbers == 7 or lucky_numbers == 4):
        print "YES"
    else: print "NO"

def problem_266b():
    new_order = ""
    students, seconds = map(int, raw_input().split())
    order = raw_input()
    for i in range(0, seconds):
        if "BG" in order:
            order = order.replace("BG", "GB")
    print order
    
def problem_271a():
    numbers = []
    for i in xrange(1000,9100):
        add = "".join(OrderedDict.fromkeys(str(i)))
        if len(add) == 4:
            numbers.append(add)
    choice = raw_input()    

    for x in numbers:
        if int(x) > int(choice):
            print numbers[numbers.index(x)]
            break
            
def problem_136a():
    order = ""
    people = input("")
    new_list = [0]*(people+1)
    presents = raw_input().split()
    for i in range(0, people):
        new_list[int(presents[i])-1] = i + 1 
    
    for k in range(0, people):
        order += str(new_list[k]) + " "
    
    print order
    
    
def problem_337a():
    smallest = 1000
    n, m = map(int, raw_input().split())
    pieces = sorted(map(int, raw_input().split()))
    for i in range(0,(m-n)+1):
        difference = pieces[i+n-1] - pieces[i]
        if difference < smallest:
            smallest = difference
    print smallest
    
def problem_69a():
    x, y, z = 0, 0, 0
    vectors = input("")
    for i in range(0, vectors):
        points = map(int, raw_input().split())
        x += points[0]
        y += points[1]
        z += points[2]
    if x == 0 and y == 0 and z == 0:
        print "YES"
    else: print "NO"
    
def problem_41a():
    word = raw_input()
    reverse = raw_input()
    if word == reverse[::-1]:
        print "YES"
    else: print "NO"
    
def problem_580a():
    longest = 0
    numbers = input("")
    money = map(int, raw_input().split())
    
    if numbers == 1:
        print "1"
    else:
       for i in range(0, numbers-1):
           string = 1
           for x in range(i, numbers-1):
               if money[x+1] >= money[x]:
                   string += 1
               else: break
           if string > longest: longest = string
       print longest    
       
def problem_479a():
    a = input("")
    b = input("")
    c = input("")
    possibilities = [a+(b*c), a*(b+c), (a+b)*c, a*b*c, a+b+c]
    print sorted(possibilities)[-1]
    
def problem_486a():
    function = input("")
    if function % 2 == 0:
        print function / 2
    else: print (function + 1) / (-2)
    
def problem_82a():
    line = ["Sheldon", "Leonard", "Penny", "Rajesh", "Howard"]
    person = input("")
    total = 5
    multiplier = 2
    while True:
        if person <= 5:
            print line[person-1]
            break
        if total < person:
            if (total + (5 * multiplier)) >= person:
                print line[((person - total) - 1) / multiplier]
                break
            else:
                total += (5*multiplier)
                multiplier *= 2
                
def problem_451a():
    n, m = map(int, raw_input().split())
    if min(n,m) % 2 == 0:
        print "Malvika"
    else: print "Akshat"
    
def problem_208a():
    remix = raw_input()
    remix = remix.replace("WUB", " ")
    remix = remix.replace("  ", " ")
    while True:
        if remix[0] == " ":
            remix = remix[1::]
        else: break
    while True:
        if remix[-1] == " ":
            remix = remix[0:-1]
        else: break
    print remix
            
def problem_379a():
    candles, remake = map(int, raw_input().split())
    total = candles
    while candles != 0:
        total += (candles / remake)
        candles /= remake
    print total
    
def problem_460a():
    socks, days = map(int, raw_input().split())
    total, i = 0, 1
    while i < socks+1:
        total += 1
        if i % days == 0:
            socks += 1
        i += 1
    print total
    
def problem_344a():
    magnets = input("")
    first = raw_input()
    total = 1
    for i in range(magnets-1):
        next = raw_input()
        if next[0] == first[1]:
            total += 1
        first = next
    print total
    
def problem_61a():
    first = raw_input()
    second = raw_input()
    print '{0:b}'.format(int(first, 2) ^ int(second, 2)).zfill(len(first))
    
def problem_617a():
    distance = input("")
    if distance % 5 == 0: print distance / 5  
    else: print distance / 5 + 1

def problem_510a():
    rows, columns = map(int, raw_input().split())
    dots_first = True
    for i in range(1, rows+1):
        if i % 2 != 0: print "#"*columns
        elif dots_first:
            print "."*(columns-1) + "#"
            dots_first = False
        else:
            print "#" + "."*(columns-1)
            dots_first = True
            
def problem_228a():
    print 4 - len(set(raw_input().split()))
    
def problem_520a():
    length = input("")
    string = raw_input().lower()
    
    if len(set(string)) == 26: print "YES"
    else: print "NO"
    
def problem_141a():
    new = raw_input()
    combined = "".join(sorted(raw_input() + new))
    letters = raw_input()
    if "".join(sorted(letters)) in combined and len(letters) >= len(combined): print "YES"
    else: print "NO"
    
def problem_466a():
    n, m, a, b = map(int, raw_input().split())
    if n % m != 0: print n / m * b + a
    else: print n / m * b
problem_466a()