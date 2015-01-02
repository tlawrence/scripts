require 'fog'
require_relative 'generators/compose_vapp'
require_relative 'generators/recompose_vapp'
require_relative 'pooler'
require_relative 'merger'

module Deployment
  class Vcloud

    def initialize(user,pass,org,url)
      @vcloud = Fog::Compute::VcloudDirector.new(
        :vcloud_director_username => "#{user}@#{org}",
        :vcloud_director_password => pass,
        :vcloud_director_host => url,
        :vcloud_director_show_progress => false, # task progress bar on/off
      )

      @org = @vcloud.organizations.first
    end

    def netexists?(name)
      puts "Checking if network: #{name} exists"
      @org.networks.get_by_name(name)
    end
    
    def vappexists?(vappname, vdcname)
      puts "Checking if vapp: #{vappname} exists"
      vapp = @org.vdcs.get_by_name(vdcname).vapps.get_by_name(vappname)
      
      unless vapp then 
        return false
      else
        vapp
      end
      
      
    end
    
    def process_task(entity)
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
    
    def create_or_update_vapp(config)
    
      name = config['vapp']['name']
      vdcname = config['vapp']['vdc']
      parentnet = config['vapp']['backbone']['name']
      bastion_ip = config['vapp']['bastion_ip']
      vappnets = config['vapp']['vms']
    
      vapp =  vappexists?(name,vdcname)
      if vapp then 
        puts "Updating vApp #{name}"
        update_vapp(name,vdcname, parentnet, vappnets, bastion_ip, vapp.id)
      else
        puts "Creating vApp #{name}"
        create_vapp(name,vdcname, parentnet, vappnets, bastion_ip)
      end
      
      
      puts 'Checking VM Counts For Each Tier (may take a while)'
      adjustments = calculate_adjustments(vapp,name,vappnets)
      total_new_vms = 0
      adjustments.each do |k,v|
        if v > 0 then
          total_new_vms += v
        end
      end
      
      created_vms = create_spare_vms(config, total_new_vms)
      
      merge_spare_vms(config, created_vms, adjustments, vapp, vdcname)
      
      
      
    end
    
    def create_spare_vms(config, quantity)
      puts "Creating #{quantity} new vms"
      pooler = Deployment::Pooler.new(@vcloud)
      
      pooler.populate(config,quantity)
      #
      
    end
    
    def merge_spare_vms(config, created_vms, adjustments, vapp,vdcname)
      puts "Merging #{created_vms.count} new vms"
      merger = Deployment::Merger.new(@vcloud,vapp,vdcname)
      
      merger.merge_vms(config,created_vms,adjustments)
    end
    
    def calculate_adjustments(vapp, name, tiernames)
      actual_count = connected_vms(vapp,name)
      adjustments = {}
      tiernames.each do |net|
        name = net['name']
        delta = net['quantity'] - actual_count[name]
        
        puts "Tier: #{name}\n  Desired #vms: #{net['quantity']}\n  Actual #vms: #{actual_count[name]}\n  Delta: #{delta}\n"
        
        adjustments[name] = delta
        
      end

      adjustments
    end
        
    def connected_vms(vapp, netname)
      actual = {}
      vapp.vms.each do |vm|
        actual[vm.network.network] = 0 unless actual[vm.network.network]
        actual[vm.network.network] += 1
      end


      actual
    end
    
    def update_vapp(name,vdcname, parentnet, vappnets, bastion_ip, vappid)
      body = Generators::Recompose.generate(name,vdcname, parentnet, vappnets, bastion_ip, @org)
      
      process_task(@vcloud.request(
          :body    => body,
          :expects => 202,
          :headers => {'Content-Type' => 'application/vnd.vmware.vcloud.recomposeVAppParams+xml'},
          :method  => 'POST',
          :parser  => Fog::ToHashDocument.new,            
          :path    => "/vApp/#{vappid}/action/recomposeVApp"
      )) 
      
    end
    
    def create_vapp(name,vdcname, parentnet, vappnets, bastion_ip)
      body = Generators::Compose.generate(name,vdcname, parentnet, vappnets, bastion_ip, @org)
      
      process_task(@vcloud.request(
              :body    => body,
              :expects => 201,
              :headers => {'Content-Type' => 'application/vnd.vmware.vcloud.composeVAppParams+xml'},
              :method  => 'POST',
              :parser  => Fog::ToHashDocument.new,            
              :path    => "/vdc/#{vdc_id(vdcname)}/action/composeVApp"
      )) 
    
    end

    
    
    def add_vms()
    end

    def configure_edge_gateway()
    end

    def vdc_id(vdcname)
      @org.vdcs.get_by_name(vdcname).id
    end

    def createnet(name,vdc,gateway,mask,dns)
      vdcid = vdc_id(vdc)
      gatewayhref = @vcloud.get_org_vdc_gateways(vdcid).body[:EdgeGatewayRecord].first[:href]
      options = {
        :Configuration => {
          :IpScopes => {
            :IpScope => {
              :IsInherited => false,
              :Gateway => gateway,
              :Netmask => mask,
              :Dns1 => dns
            }
          },
          :FenceMode => 'natRouted'
        },
        :EdgeGateway => {
          :href => gatewayhref
        }
      }
      
      process_task(@vcloud.post_create_org_vdc_network(vdcid, name, options))

    end


    def configurenetwork()
      vapp =  @org.vdcs.first.vapps.get_by_name('template')
      vapp.vms.each do |vm|
        net = vm.network

        options = {
          :ip_address_allocation_mode => 'MANUAL',
    :network_connection_index => "#{net.network_connection_index}",
    :IpAddress => '172.21.0.1',
    :is_connected => 1,
        }      
    puts vapp.id
    puts vapp.href

        @vcloud.put_network_connection_system_section_vapp(vapp.id,options)

      end   
    end

    def deployvm(name,vdc,cat,template,net,ip)
     catalog = @org.catalogs.get_by_name(cat)
     vdcid = @org.vdcs.get_by_name(vdc).id
     networkid = @org.networks.get_by_name(net).id

     options = {
       :vdc_id => vdcid,
       :network_id => networkid,
       :deploy => true,
       :powerOn => false,
     }
     item = catalog.catalog_items.get_by_name(template)
  puts item.vapp_template
     #item.instantiate(name,options)
    end


    def poweron(name)
      @vcloud.organizations.first.vdcs.first.vapps.each do |vapp|
        if vapp.name == name then
          response = @vcloud.post_power_on_vapp(vapp.id)
          task = @vcloud.get_task(response[:body][:href].split('/').last)
          puts task[:body]
          puts "Powered On #{name}"
          
        end
      end
    end

    def poweroff(name)
      @vcloud.organizations.first.vdcs.first.vapps.each do |vapp|
        if vapp.name == name then
          response = vapp.power_off
          puts response.body
          puts "powered off #{name}"
        end
      end
    end

  def orgbody
      puts @vcloud.organizations.first.body
   
  end
  end
end

