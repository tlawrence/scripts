require 'fog'
require_relative 'creds'

vcloud = Fog::Compute::VcloudDirector.new(
  :vcloud_director_username => user,
  :vcloud_director_password => pass,
  :vcloud_director_host => url,
  :vcloud_director_show_progress => false, # task progress bar on/off
)
#100.times do 
#  puts "\n\n######################################"
#  running = 0
#  vcloud.get_task_list(vcloud.organizations.first.id).body[:Task].each do |task|
#  	unless task[:status] == "success"
#		puts "\nStart: #{task[:startTime]}\nStatus: #{task[:status]}"
#		if task[:Error] then puts "Reason: #{task[:Error][:message]}" end
#	end
#	if task[:status] == "running"
#		running += 1
#	end
#  end
#  puts "Running Tasks: #{running}"
#end



1000.times do
  puts "\n\n############################################"
  running = vcloud.get_execute_query("task" ,{:filter => 'status==running'}).body
  failed = vcloud.get_execute_query("task" ,{:filter => 'status==error'}).body

  puts  "Running Tasks: #{running[:total]}"
  if running[:TaskRecord] then
    running[:TaskRecord].each do |task|
      puts "\n\n#{task[:startDate]} \nOperation: #{task[:name]}\nObject: #{task[:objectName]}"
    end
  end


  puts "\n\n++++++++++++++++++++++++++++++++++++++++++++++\n\n"

  puts  "Failed Tasks: #{failed[:total]}"
  if failed[:TaskRecord] then
    failed[:TaskRecord].each do |task|
      puts "\n\n#{task[:startDate]} \nOperation: #{task[:name]}\nObject: #{task[:objectName]}\nMessage: #{task[:details]}"
    end
  end
  puts "############################################"
  sleep(2)
end
