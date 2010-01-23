#!/usr/bin/env ruby

require "json"

payload_file = File.new("github_payload")
hash = eval(payload_file.read)

payload_json = JSON.generate(hash["payload"])

exec "curl --data-binary 'payload=#{payload_json}' http://localhost:9393/"
