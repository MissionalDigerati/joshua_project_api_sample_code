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