#!/usr/bin/env python
# Script: parse.py

import re,sys,json


def parse(filename):
	"""Parse in a *.txt file to get parsed data from receipts

	Returns a dictionary of menu items to prices. Dictionary 
	will include subtotal as well as total and tax


	"""
	itemDict = {}
	# Extracts information from text file
	with open(filename) as f:
		for line in f:
			if re.search('([0-9]*\.[0-9][0-9])', line):
				price = float(re.search('[0-9]*\.[0-9][0-9]', line).group(0))
				name = line[:line.index(str(price))].strip('$').strip(' ')
				if re.search('[0-9]+', name):
					quantity = int(re.search('[0-9]+', name).group(0))
					if name.index(str(quantity)) > 0:
						name = name[0:name.index(str(quantity))]+name[name.index(str(quantity))+len(str(quantity)):]
					elif name.index(str(quantity)) == 0:
						name = name[len(str(quantity)):]

				else:
					quantity = 1
			name = name.strip(' ')
			itemDict[name] = {"Quantity":quantity, "Price":price}
	return itemDict






if __name__ == "__main__":
	print 'Argument List:', str(sys.argv)
	print 'Number of arguments:', len(sys.argv), 'argument(s).'
	assert len(sys.argv)==2, "Incorrect number arguments. Format should be: ./parse.py results.txt"
	assert re.search('.*\.txt', sys.argv[1])
	print json.dumps(parse(sys.argv[1]), sort_keys=True, indent=4, separators=(',',':'))
	