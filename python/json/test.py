#!/usr/bin/env python
# -*- coding: utf-8 -*- 

# 上面使用 UTF-8 编码

import json

# python 字典类型转换为 json 对象

data = {
    'number': 1,
    'name': 'wxl',
    'url': {
        'site1': 'AA',
        'site2': 'BB'
    }
}

# 对数据进行编码为json
json_str = json.dumps(data) 
print data
# type 输出 变量的 类型
print type(data)
# repr 将变量输出为可打印的字符串
data3 = repr(data) 
print type(data3)
print type(json_str)
print ("Python origin data:", repr(data))
print ("JSON object:", json_str)

# 获取 key 的 value
# 编码为 python object
json_data = json.loads(json_str)

print json_data.get('number')
print json_data['url'].get('site1')
print json_data['url'].get('site', 'AAA')
print json_data['url']['site2']
print json_data.get('url',0)
