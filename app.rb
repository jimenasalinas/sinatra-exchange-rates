require "sinatra"
require "sinatra/reloader"
require "http"
require "json"


# define a route
get("/") do

  # build the API url, including the API key in the query string
  key =  ENV['CURRENCY']
  api_url = "https://api.exchangerate.host/list?access_key="+ key

  # use HTTP.get to retrieve the API information
  raw_data = HTTP.get(api_url)

  # convert the raw request to a string
  raw_data_string = raw_data.to_s

  # convert the string to JSON
  parsed_data = JSON.parse(raw_data_string)

  # get the symbols from the JSON
  @symbols = parsed_data['currencies'].keys

  # render a view template where I show the symbols
  erb(:homepage)
end

get("/:from_currency") do
  @original_currency = params.fetch("from_currency").strip

  api_url = "https://api.exchangerate.host/list?access_key=#{ENV["CURRENCY"]}"
  
  # some more code to parse the URL and render a view template

  # use HTTP.get to retrieve the API information
  raw_data = HTTP.get(api_url)

  # convert the raw request to a string
  raw_data_string = raw_data.to_s

  # convert the string to JSON
  parsed_data = JSON.parse(raw_data_string)

  # get the symbols from the JSON
  @symbols = parsed_data['currencies'].keys

  erb(:from_currency)
end

get("/:from_currency/:to_currency") do
  @original_currency = params.fetch("from_currency").strip
  @destination_currency = params.fetch("to_currency").strip #there seems to be some trailing spaces causing an error

  api_url = "https://api.exchangerate.host/convert?access_key=#{ENV["CURRENCY"]}&from=#{@original_currency.gsub(" ", "")}&to=#{@destination_currency.gsub(" ", "")}&amount=1"
  raw_data = HTTP.get(api_url)

  # convert the raw request to a string
  raw_data_string = raw_data.to_s

  # convert the string to JSON
  parsed_data = JSON.parse(raw_data_string)

  # some more code to parse the URL and render a view template
  @result = parsed_data["result"]


    erb(:to_currency)
end
