#!/usr/bin/ruby

require 'net/http'
require 'json'

url = URI('http://128.199.146.146:9090/api/v1/query?query=(100+*+(1+-+avg+by(instance)(irate(node_cpu%7Bmode%3D%27idle%27%2Cinstance%3D%22188.166.216.22:9100%22%7D%5B1m%5D))))')

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
