require_relative 'generators/sourced_items'

module Deployment
  class Merger

    def initialize(vcloud)  
      @vcloud = vcloud
    end
    
    def merge_vms(params,spare_vms,adjustments)
    
      final_list = []
      adjustments.each do |tier,qty|
        if qty > 0 then
          qty.times do
            vm = spare_vms.shift
            item = {
                      :name => "#{tier}-#{vm[0]}",
                      :tier => tier,
                      :href => vm[1]
                    }
                   
            final_list.push(item)
          end
        end
      
      end
      
      item_gen = Deployment::Generators::SourcedItems.new()
      sourced_items = item_gen.add_items(final_list)
      
      
    end

  end
end