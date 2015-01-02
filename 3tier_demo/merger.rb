require_relative 'generators/sourced_items'
require_relative 'utils'

module Deployment
  class Merger

    def initialize(vcloud,vapp,vdcname)  
      @vcloud = vcloud
      @vapp = vapp
      @vdc = @vcloud.organizations.first.vdcs.get_by_name(vdcname)
    end
    
    def merge_vms(params,spare_vms,adjustments)
      vapp_shells = spare_vms.dup
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
      sourced_items = item_gen.add_items(final_list,@vapp.name)

      begin
        update_vapp(sourced_items)
      rescue => e
        puts "ERROR: #{e.message}. Cleaning Up Pool VMs"
        delete_vapp_shells(vapp_shells)
      ensure
        puts "VMs Merged Succesfully. Cleaning Up."
        delete_vapp_shells(vapp_shells)
      end
      
      puts "Deployment Complete"
    end
    
    def delete_vapp_shells(vapp_shells)
      if vapp_shells then
        vapp_shells.each do |name,ref|
          @vdc.vapps.get_by_name(name).destroy
        end
      end
      
    end

    def update_vapp(body)
      
      id = @vapp.href.split('/').last
      utils = Deployment::Utils.new(@vcloud)
      utils.process_task(@vcloud.request(
          :body    => body,
          :expects => 202,
          :headers => {'Content-Type' => 'application/vnd.vmware.vcloud.recomposeVAppParams+xml'},
          :method  => 'POST',
          :parser  => Fog::ToHashDocument.new,            
          :path    => "/vApp/#{id}/action/recomposeVApp"
      )) 
      
    end    
    
  end
end