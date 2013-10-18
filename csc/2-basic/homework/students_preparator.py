#!/usr/bin/python
#coding: utf-8

import sys
import codecs
import numpy

def numerical_with_avg_in_text(values):
	ret = []
	text_count = sum([1 for val in values if not val.replace(".", "", 1).isdigit()])
	num_count = sum([1 for val in values if val.replace(".", "", 1).isdigit()])
	textsPercent = text_count / float(num_count + text_count) 
	if textsPercent > 0.2:
		print "WARN: ",textsPercent," texts in numerical" 
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
		vals = clazz(factor[1:], {"Санкт-Петербург": 0}, 1)
		result_header = "Питер"
		result_names.append(result_header)
		result_matrix.append(vals)
	elif "Тип школы" == name:
		result_names.append("Крутая школа")
		vals = clazz(factor[1:], {"СОШ": 0, "Лицей": 1, "Гимназия": 1})
		result_matrix.append(vals)
	elif len(set(factor[1:])) == 1:
		continue
	elif "Оценка по мнению родителей" == name:
		f = []
		for parent,real in zip(factor[1:], result_matrix[1]):
			if not parent.replace(".","").isdigit():				
				f.append(0)
			elif float(parent) > real:
				f.append(1)
			else:
				f.append(-1)
		result_names.append("Оценка родителей выше");
		result_matrix.append(f)
	else:
		result_names.append(name)		
		vals = numerical_with_avg_in_text(factor[1:])
		result_matrix.append(vals)
	if len(result_names) != len(result_matrix):
		raise Exception(len(result_names),"!=",len(result_matrix))
pos  = 1
for factor,name in zip(result_matrix,result_names):
	print "'"+name+"',"
	pos = pos + 1
	#print factor
	[float(f) for f in factor]

if len(sys.argv) >=3:
	f = open(sys.argv[2], 'w')	
	for factor in zip(*result_matrix):
		f.write(",".join(str(f) for f in factor))
		f.write("\n")
	
