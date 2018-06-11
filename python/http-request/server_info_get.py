#!/usr/bin/python 
# -*- coding: utf-8 -*-

import httplib
import json

test_data = {
        "user":"wuxiaoliu",
        "access_token":"XXX",
        "tablename": "XXX",
        "header": "id,hostname,XXX",
        "length":-1
}

requrl = "http://www.baidu.com/interface/rest"
headerdata = {"Content-type": "application/json"}

# 这里两个参数，写端口也可以，不写端口也可以
#conn = httplib.HTTPConnection("www.baidu.com",80)
conn = httplib.HTTPConnection("www.baidu.com")

conn.request('POST',requrl,json.dumps(test_data),headerdata)

response = conn.getresponse()

res= response.read()

print res
