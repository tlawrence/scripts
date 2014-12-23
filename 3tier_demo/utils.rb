
module Deployment
  class Utils
  

    def self.process_task(entity)
      puts "Task Processor received object of type: #{entity.class}"
    
      if(entity.body[:Tasks]) then
        id = entity.body[:Tasks][:Task][:href].split('/').last
        puts "Processing task ID #{id}"  
        task = @vcloud.get_task(id).body

        until ['success','error','canceled','aborted'].include?(task[:status])
          puts "Task #{task[:operation]} status: #{task[:status]}"
          task = @vcloud.get_task(id).body
          sleep 5
        end

      end
    end
    
  end
end