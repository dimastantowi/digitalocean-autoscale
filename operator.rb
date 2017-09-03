#!/usr/bin/ruby

require 'net/http'
require 'json'

# Declare trigger
trigger=75

url_memory = URI("http://128.199.146.146:9090/api/v1/query?query=(((node_memory_MemTotal{}%20-%20node_memory_MemFree{}%20)%20/%20(node_memory_MemTotal{%20})%20)*%20100)%20%3E=%20#{trigger}")

# Get result by json
req_memory = Net::HTTP.get(url_memory)

# Convert Json to hash
data_memory = JSON.parse(req_memory)

# Looping to find memory and cpu > trigger
data_memory['data']['result'].each do |key|

   get_instance = key['metric']['instance']
 
   url_cpu = URI("http://128.199.146.146:9090/api/v1/query?query=(100+*+(1+-+avg+by(instance,job,group)(irate(node_cpu%7Bmode%3D%27idle%27%2Cinstance%3D%22#{get_instance}%22%7D%5B1m%5D))))")
   #url_cpu = URI(merge_url)
   req_cpu = Net::HTTP.get(url_cpu)
   data_cpu = JSON.parse(req_cpu)

   load_cpu = data_cpu['data']['result'][0]['value'][1]
   
   if load_cpu.to_f >= trigger 
       puts "create instance to group #{data_cpu['data']['result'][0]['metric']['group']}"
       puts load_cpu.to_f
   else
       puts "no create"
       puts load_cpu.to_f
   end 

end



