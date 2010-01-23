require 'sinatra'
require 'json'
require 'net/http'

# Set your URL and TOKEN key here
URL = "http://youraccount.talkerapp.com/rooms/ROOM_ID"
TOKEN = "token"

post '/' do
  payload = JSON.parse(params[:payload])

  repository = payload['repository']['name']
  branch = payload['ref'].split('/').last
  commits = payload['commits']

  url = URI.parse("#{URL}/messages.json")
  
  commits.each do |commit|
    # You can modify the way the message gets sent to you here
    message = "[#{repository}/#{branch}] #{commit['message']} - #{commit['author']['name']} (#{commit['url']})"
    
    req = Net::HTTP::Post.new(url.path)
    req["X-Talker-Token"] = "#{TOKEN}"
    req.set_form_data('message' => message)
  
    Net::HTTP.new(url.host, url.port).start { |http| http.request(req) }
  end
  "Push to Talker"
end

get '/' do
  "Hello, this is an app for posting GitHub commit to Talker. by <a href='http://siong1987.com'>siong1987</a>"
end

