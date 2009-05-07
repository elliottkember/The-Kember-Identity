import random
min, max= 5, 15
string=''
for count in xrange(1,10):
  for x in random.sample('abcdefghijklmnopqrstuvwxyz0123456789',random.randint(min,max)):
    string+=x

import md5
num = runs = 0
while(1):
  num+=1
  digested_string = md5.new(string).hexdigest()
  if (digested_string == string):
    print 'We have a winner: ', string
  else:
    if num == 100000:
      print digested_string
      num = 0
      runs += 1
    print digested_string, ' : ', runs, ' : ', num
    string = digested_string

