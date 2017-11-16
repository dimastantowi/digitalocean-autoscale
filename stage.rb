#!/usr/bin/ruby

require 'net/http'
require 'json'

# Declare trigger
$trigger = 80

# Minutes
$minutes = 5

# Class stage
class Stage
   def cpu(job)
     @job = job
     url_cpu = URI("http://128.199.146.146:9090/api/v1/query?query=100+*+(1+-+avg+by(instance%2Cjob%2Cgroup)(irate(node_cpu%7Bjob%3D%27#{@job}%27%2Cmode%3D%27idle%27%7D%5B1m%5D)))")
     req_cpu = Net::HTTP.get(url_cpu)
     cpu = JSON.parse(req_cpu)
     
     group = cpu['data']['result'][0]['metric']['group']
     value = cpu['data']['result'][0]['value'][1]
     return group, value
   end

   def memory(job)
      @job = job
       url_memory = URI("http://128.199.146.146:9090/api/v1/query?query=(((node_memory_MemTotal{job=%27#{@job}%27}%20-%20node_memory_MemFree{job=%27#{@job}%27}%20)%20/%20(node_memory_MemTotal{job=%27#{@job}%27})%20)*%20100)%20%20%3E=%20#{$trigger}")
       req_memory = Net::HTTP.get(url_memory)
       memory = JSON.parse(req_memory)

       group = memory['data']['result'][0]['metric']['group']
       value = memory['data']['result'][0]['value'][1]
       return group, value
   end 

   def stage(job)
       @job = job

       stage = 1

       while stage <= 3 do
          
           mem_result =  memory(@job)[1]
           cpu_result = cpu(@job)[1]
           
	    if mem_result.to_f && cpu_result.to_f >= $trigger
               puts mem_result
               puts cpu_result
            end

           sleep(1)
           stage += 1
       end
                     
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
    value = key['value'][1]

    start_job = Stage.new()
    start_job.stage(job)

end
