
module Deployment
  class Utils
  
    def initialize(vcloud)
      @vcloud = vcloud
    end
    
    def process_task(entity)

      raise "Could Not Locate Task Reference" unless entity.body[:Tasks]||entity.body[:name] == 'task'
      
      if(entity.body[:Tasks]) then
        id = entity.body[:Tasks][:Task][:href].split('/').last
      elsif(entity.body[:name] == 'task')
        id = entity.body[:href].split('/').last
      end
      
      puts "  Processing task ID #{id}"  
      task = @vcloud.get_task(id).body

      until ['success','error','canceled','aborted'].include?(task[:status])
        puts "  Task #{task[:operation]} status: #{task[:status]} progress: #{task[:progress]}"
        task = @vcloud.get_task(id).body
        sleep 5
      end

      
    end
    
  end
end