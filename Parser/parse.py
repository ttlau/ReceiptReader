#!/usr/bin/env python
# Script: parse.py

import re,sys


def parse(filename):
	"""Parse in a *.txt file to get parsed data from receipts

	Returns a dictionary of menu items to prices. Dictionary 
	will include subtotal as well as total and tax
	"""
	# Extracts information from text file
	with open(filename) as f:
		for line in f:
			if re.search('([0-9]*\.[0-9][0-9])', line):
				price = float(re.search('[0-9]*\.[0-9][0-9]', line).group(0))
				name = line[:line.index(str(price))].strip('$').strip(' ')
				if re.search('[0-9]*', name):
					number = int(re.search('[0-9]*', name).group(0))
					if name.index(str(number)) > 0:
						number = int(name[0:name.index(str(number))]+name[name.index(str(number))+len(str(number)):])
					elif name.index(str(number)) == 0:
						number = name[len(str(number)):name.index(str(number))]
					else:
						number = int(name[0:])

				else:
					number = 1
				print number + " x " + "Name: " + name
				print "Price: " + str(price)






if __name__ == "__main__":
	print 'Argument List:', str(sys.argv)
	print 'Number of arguments:', len(sys.argv), 'argument(s).'
	assert len(sys.argv)==2, "Incorrect number arguments. Format should be: ./parse.py results.txt"
	assert re.search('.*\.txt', sys.argv[1])
	parse(sys.argv[1])
	