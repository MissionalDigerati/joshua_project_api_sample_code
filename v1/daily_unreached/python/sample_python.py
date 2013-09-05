#!/usr/bin/python
# import the necessary libraries
import json
import urllib2
import string
import sys
# set some important variables
domain = "http://jpapi.codingstudio.org"
api_key = "4a2bab35f1c7"
# request the API for the Daily Unreached People Group
try:
    response = urllib2.urlopen(domain+"/v1/people_groups/daily_unreached.json?api_key="+api_key)
    # parse the JSON response
    data = json.load(response)
except:
    print "Unable to get the API data"
    sys.exit()

# get the template file
index_file = open('templates/index.html')
template = string.Template(index_file.read())
# format numbers
data[0]['Population'] = format(int(data[0]['Population']), ',d')
if data[0]['PercentEvangelical'] is None:
	data[0]['PercentEvangelical'] = '0'
data[0]['PercentEvangelical'] = float(data[0]['PercentEvangelical'])
try:
    widget_file = open('generated_code/widget.html','w')
    # substitute the dictionary data with the template variables
    widget_file.write(template.substitute(data[0]))
except:
    print "Unable to write the HTML file"
    sys.exit()