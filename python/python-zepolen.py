from hashlib import md5
from random import randint
prev, next = '', hex(randint(0,
0xffffffffffffffffffffffffffffffff))[2:].rstrip('L').zfill(32)
print 'seeded with', next
while prev != next:
 prev, next = next, md5(next).hexdigest()
print 'result: ', next