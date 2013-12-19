# We will use Erubis for the templating
require "erubis"
# We need net/http to handle the request to the API
require "net/http"
# We will need to parse the JSON response
require "json"
# set some important variables
domain = "jpapi.codingstudio.org"
api_key = YOUR_API_KEY
api_path = "/v1/people_groups/daily_unreached.json?api_key=#{api_key}"
# locals = {}

begin
	# Make the request to the Joshua Project API
	response = Net::HTTP.get(domain, api_path)
	# Parse the response
	data = JSON.parse(response)
	unreached = data[0]
rescue Exception => e
	# We had an error
	puts "Unable to get the API data"
	puts e.message
	abort
end
# format the population to a comma seperated value
unreached['Population'] = unreached['Population'].to_s.gsub(/(\d)(?=(\d{3})+$)/,'\1,')
# Lets handle the evangelical number since it can be nil
if unreached['PCEvangelical'].nil?
	unreached['PCEvangelical'] = "0.00"
else
	# format the percent to a floating point (decimal)
	unreached['PCEvangelical'] = '%.2f' % unreached['PCEvangelical']
end
# Generate the template
template_file = File.read("templates/index.html.erb")
template = Erubis::Eruby.new(template_file)
# run the Erubis substitution
widget_code = template.result({unreached: unreached})
# We will write the final HTML file
begin
	# open the final file
	file = File.open("generated_code/widget.html", "w")
	# write the new file
	file.write(widget_code)
rescue IOError => e
	# We had an error
 	puts "Unable to write the HTML file"
	puts e.message
	abort
ensure
	# ensure the file closes if this fails
	file.close unless file == nil
end