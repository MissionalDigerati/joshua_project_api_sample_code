#!/usr/bin/python
# import the necessary libraries
import json
import urllib.request
import urllib.error
import string
import sys
# set some important variables
domain = "http://jpapi.codingstudio.org"
api_key = "4a2bab35f1c7"
api_url = domain+"/v1/people_groups/daily_unreached.json?api_key="+api_key
try:
    # request the API for the Daily Unreached People Group
    request = urllib.request.urlopen(api_url)
except urllib.error.HTTPError as e:
    print('The server couldn\'t fulfill the request.')
    print('Error code: ', e.code)
    exit
except urllib.error.URLError as e:
    print('We failed to reach a server.')
    print('Reason: ', e.reason)
    exit
else:
    # decode the response
    response = request.read().decode("utf8")
    # load the JSON
    data = json.loads(response)
    unreached = data[0]
    # format population to be a comma seperated integer
    unreached['Population'] = format(int(unreached['Population']), ',d')
    # check if percent of Evangelicals is None
    if unreached['PercentEvangelical'] is None:
        unreached['PercentEvangelical'] = '0'
    # format percent of Evangelicals to percent
    unreached['PercentEvangelical'] = float(unreached['PercentEvangelical'])
    # get the template file
    index_file = open('templates/index.html').read()
    # initialize a new template
    template = string.Template(index_file)
    # make the substitution
    final_code = template.substitute(unreached)
    # create the widget.html file
    widget_file = open('generated_code/widget.html','w')
    widget_file.write(final_code)