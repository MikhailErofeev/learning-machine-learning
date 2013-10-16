#!/usr/bin/python
#coding: utf-8

import sys
import codecs
import numpy

def numerical_with_avg_in_text(values):
	ret = []
	m = numpy.mean([float(val) for val in values if val.replace(".", "", 1).isdigit()])
	for val in values:
		if val.replace(".", "", 1).isdigit():
			ret.append(float(val))
		else:
			ret.append(m)
	return ret

def binary(values):
	ids = dict()
	id = 0
	vals_set = set(values)
	if len(vals_set) != 2:
		raise Exception("not binary!!!")
	for val in vals_set:
		if val not in ids:				 
			ids[val] =  id
			id = id + 1
	ret = []
	for val in values:
		ret.append(ids[val])
	return ret
	


val = dict()
val["М"] = 1
if "Ж" not in val:
	print val

	
src_file = codecs.open(sys.argv[1], "r", "utf-8")
src_str = src_file.read().encode("utf-8") 
src_matrix = [[line for line in src_lines.split(",")] for src_lines in src_str.split('\n')]
src_file.close()
factors_matrix = zip(*src_matrix) 
result_matrix = []
for factor in factors_matrix:
	name = factor[0]
	print name
	if "Средний школьный балл" == name:
		vals = numerical_with_avg_in_text(factor[1:])
		print vals,
		result_matrix.append(vals)
	elif "Пол" == name:
		haha = [x if x != 'M' else 'М' for x in factor[1:]]
		vals = binary(haha)
		print vals,
		result_matrix.append(vals)	
	else:
		for f in factor[1:]:
			print(f+","),
	print
	#print factor[1:]

