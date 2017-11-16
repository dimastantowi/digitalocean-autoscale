#!/usr/bin/ruby

require 'net/http'
require 'json'

# Declare trigger
$trigger = 75

# Class stage

class Stage

   def stage1(job)
       @job = job
       url_memory = URI("http://128.199.146.146:9090/api/v1/query?query=(((node_memory_MemTotal{job=%27#{@job}%27}%20-%20node_memory_MemFree{job=%27#{@job}%27}%20)%20/%20(node_memory_MemTotal{job=%27#{@job}%27})%20)*%20100)%20%20%3E=%20#{$trigger}")
       req_memory = Net::HTTP.get(url_memory)
       memory = JSON.parse(req_memory)

       group = memory['data']['result'][0]['metric']['group']
       value = memory['data']['result'][0]['value'][1]
 
       puts group
       puts value
   end
   
end 



url = URI("http://128.199.146.146:9090/api/v1/query?query=(((node_memory_MemTotal{}%20-%20node_memory_MemFree{}%20)%20/%20(node_memory_MemTotal{%20})%20)*%20100)%20%3E=%20#{$trigger}")

# Get result by json
req = Net::HTTP.get(url)

# Convert Json to hash
data_url = JSON.parse(req)

# Looping to find memory > trigger
data_url['data']['result'].each do |key|
    job = key['metric']['job']
    
    a = Stage.new()
    a.stage1(job)
end

