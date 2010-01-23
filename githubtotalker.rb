require 'rubygems'
require 'sinatra'
require 'json'
require 'net/http'

URL = "http://salestream.talkerapp.com/rooms/506"
TOKEN = "31d75f3b8b4eb016eaa36be5a13f664e90ff9ef2"

get '/' do
  "Hello, this is an app for posting GitHub commit to Talker. by <a href='http://siong1987.com'>siong1987</a>"
end

post '/' do
  payload = JSON.parse(params[:payload])

  repository = payload['repository']['name']
  branch = payload['ref'].split('/').last
  commits = payload['commits']

  url = URI.parse("#{URL}/messages.json")
  
  commits.each do |commit|
    message = "[#{repository}/#{branch}] #{commit['message']} - #{commit['author']['name']} (#{commit['url']})"
    
    req = Net::HTTP::Post.new(url.path)
    req["X-Talker-Token"] = "#{TOKEN}"
    req.set_form_data('message' => message)
  
    Net::HTTP.new(url.host, url.port).start { |http| http.request(req) }
  end
  "Push to Talker"
end

