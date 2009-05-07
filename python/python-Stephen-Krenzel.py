#!/usr/bin/python
from random import randint
import md5

lower  = 2**(4*31)
upper  = 2**(4*32) - 1
a      = hex(randint(lower, upper))[2:-1]
for i in xrange(300000):
    b = md5.new(a).hexdigest()
    if a == b: 
        print a
        break
    a = b

