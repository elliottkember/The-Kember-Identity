# Kember Identity Finder
# Origin unknown
# Soon to be replaced - very, very buggy. Whoever wrote this fails.

import random
alphabet = 'abcdefghijklmnopqrstuvwxyz1234'
min = 5
max = 15
total = 1000000
string=''
for count in xrange(1,total):
  for x in random.sample(alphabet,random.randint(min,max)):
    string+=x

import md5
num = 0
while(1):
  num+=1
  digested_string = md5.new(string).hexdigest()
  if (digested_string == string):
    print "We have a winner: "+string
  else:
    if num == 100000:
      print digested_string
      num = 0
    string = digested_string