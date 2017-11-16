#!/usr/bin/ruby

require 'net/http'
require 'json'

url = URI('http://128.199.146.146:9090/api/v1/query?query=(((node_memory_MemTotal{}%20-%20node_memory_MemFree{}%20)%20/%20(node_memory_MemTotal{%20})%20)*%20100)%20%3E=%2050')

#Get result by json
req = Net::HTTP.get(url)

# Convert Json to hash
data = JSON.parse(req)

#group = data['data']['result'][0]['metric']['group']
#value = data['data']['result'][0]['value'][1]
#puts group
#puts value

data['data']['result'].each do |key|
   puts key['metric']['group']
   puts key['value'][1]
end
