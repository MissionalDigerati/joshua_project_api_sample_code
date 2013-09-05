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
require "rubygems"
# We will use Erubis for the templating
require "erubis"
# We need net/http to handle the request to the API
require "net/http"
# We will need to parse the JSON response
require "json"
domain = "jpapi.codingstudio.org"
api_key = YOUR_API_KEY
locals = {}

begin
	# Make the request to the Joshua Project API
	response = Net::HTTP.get(domain, "/v1/people_groups/daily_unreached.json?api_key=#{api_key}")
	# Parse the response
	unreached = JSON.parse(response)
rescue Exception => e
	puts "Unable to get the API data"
	abort
end

# Set the local variable 'unreached' to access the data in the view
locals[:unreached] = unreached[0]
# Lets format the population
locals[:unreached]['Population'] = locals[:unreached]['Population'].to_s.reverse.gsub(/...(?=.)/,'\&,').reverse
# Lets handle the evangelical number since it can be null
if locals[:unreached]['PercentEvangelical'].nil?
	locals[:unreached]['PercentEvangelical'] = "0.00"
else
	locals[:unreached]['PercentEvangelical'] = '%.2f' % locals[:unreached]['PercentEvangelical']
end
# Generate the template
template = Erubis::Eruby.new(File.read(File.join("views", "index.html.erb")))

# We will write the final HTML file
begin
  file = File.open(File.join("generated_code", "widget.html"), "w")
  file.write(template.result(locals)) 
rescue IOError => e
  puts "Unable to write the HTML file"
ensure
  file.close unless file == nil
end