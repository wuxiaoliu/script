#!/usr/bin/env python
# -*- coding: utf-8 -*- 

import json,xlwt

def readjson(file):
    with open(file,'r') as fr:
        data = json.load(fr) # 用json中的load方法，将json串转换成字典
    return data

def writeM():
    a = readjson('student_score.json')
    # 这里我们要 python object 所以 需要 json load
    print(a)
    # 表头 我们要 一个 list 列表
    title = ["ID","name","language score","math score","english score","total score","average score"]
    book = xlwt.Workbook() # 创建一个excel对象
    sheet = book.add_sheet('Sheet1',cell_overwrite_ok=True) # 添加一个sheet页
    for i in range(len(title)): # 循环列
        sheet.write(0,i,title[i]) # 将title数组中的字段写入到0行i列中
        # sheeet.write(A,B,C) 
        # A 是 第A行
        # B 是 第B列
        # C 是 value
    for line in a: #　循环字典
        print('line:',line)
        sheet.write(int(line),0,line) #　将line写入到第int(line)行，第0列中
        summ = a[line][1] + a[line][2] + a[line][3] # 成绩总分
        sheet.write(int(line),5,summ) # 总分
        sheet.write(int(line),6,summ/3) # 平均分
        # range() 函数可创建一个整数列表 list
        # 所以这里在循环list，里面的整数
        for i in range(len(a[line])):
            sheet.write(int(line),i+1,a[line][i])
    book.save('demo.xls')

if __name__ == '__main__':
    writeM()
