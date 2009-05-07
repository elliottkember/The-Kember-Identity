import random
import hashlib

def main():
	print('starting the search')
	searches = 0
	matches = list()
	try:
		while True:
			searches += 1
			string = makeString()
			if isMatch(string):
				print('We have success! ' + string + ' is the winner!')
				matches.append(string, searches)
			else:

				print
				if searches%100000 == 0:
					print("still looking after " +str(searches))
				
	except KeyboardInterrupt:
		print("\nUser aborted process.")
		if len(matches) > 0:
			print("Matches found: ")
			print(matches)
		else:
			print("No matches found. :(")
			
def makeString():
	string=''
	alphabet = 'abcdef1234567890'
	for count in range(0,32):
		for x in random.sample(alphabet, 1):
			string += x
	
	return bytes(string, encoding='utf-8')
	

def isMatch(string):
	digested_string = hashlib.md5(string).digest()
	if (digested_string == string):
		return True
	else:
		return False
		
if __name__ == "__main__":
	main()

