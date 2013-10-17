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

def clazz(values, clazzDict, defaultClazz = None):
	ret = []
	for val in values:
		if val in clazzDict:
			ret.append(clazzDict[val])			
		else:
			if defaultClazz != None:
				ret.append(defaultClazz)
			else:
				raise Exception("no def expected!!! ", val)	
	return ret

def multy_binary(values):
	ids = dict()
	id = 1
	clazz_set = set(values)
	for clazz in clazz_set:
		if clazz not in ids:				 
			ids[clazz] =  id
			id = id + 1
	ret = []
	for val in values:
		clazzes = [1 if val == clazz else 0 for clazz in clazz_set]
		ret.append(clazzes)
	return zip(*ret)
	
	
src_file = codecs.open(sys.argv[1], "r", "utf-8")
src_str = src_file.read().encode("utf-8") 
src_matrix = [[line for line in src_lines.split(",")] for src_lines in src_str.split('\n')]
src_file.close()
factors_matrix = zip(*src_matrix) 
result_matrix = []
result_names = []
for factor in factors_matrix:
	name = factor[0]
	if "Пол" == name:
		result_header = "Мужчина"
		result_names.append(result_header)
		haha = [x if x != 'M' else 'М' for x in factor[1:]]
		vals = clazz(haha, {"Ж":0, "М":1})
		result_matrix.append(vals)
	elif "Школа номер" == name:
		result_header = "239"
		result_names.append(result_header)
		vals = clazz(factor[1:], {"239": 1}, 0)
		result_matrix.append(vals)	
	elif "Школа город" == name:
		vals = clazz(factor[1:], {"Санкт-Петербург": 1}, 0)
		result_header = "Питер"
		result_names.append(result_header)
		result_matrix.append(vals)
	elif "Тип школы" == name:
		r_names = set(factor[1:])
		result_names.extend(r_names)
		vals = multy_binary(factor[1:])
		result_matrix.extend(vals)
	else:
		result_names.append(name)
		vals = numerical_with_avg_in_text(factor[1:])
		result_matrix.append(vals)
pos  = 0
for factor,name in zip(result_matrix,result_names):
	print pos, name
	pos = pos + 1
	# print factor
	[float(f) for f in factor]

if len(sys.argv) >3:
	f = open(sys.argv[2], 'w')	
	for factor in result_matrix:
		f.write(",".join(str(f) for f in factor))
		f.write("\n")
	
