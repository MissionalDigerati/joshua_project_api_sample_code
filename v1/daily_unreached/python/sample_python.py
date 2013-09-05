#!/usr/bin/python
# This file is part of Joshua Project API.
# 
# Joshua Project API is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
# 
# Joshua Project API is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
# 
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see 
# <http://www.gnu.org/licenses/>.
#
# @author Johnathan Pulos <johnathan@missionaldigerati.org>
# @copyright Copyright 2013 Missional Digerati
# 
# import the necessary libraries
import json
import urllib2
import string
import sys
# set some important variables
domain = "http://jpapi.codingstudio.org"
api_key = YOUR_API_KEY
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