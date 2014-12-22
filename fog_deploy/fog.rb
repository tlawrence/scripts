require 'fog'


class Deploy

  def initialize(user,pass,org,url)
    @vcloud = Fog::Compute::VcloudDirector.new(
      :vcloud_director_username => "#{user}@#{org}",
      :vcloud_director_password => pass,
      :vcloud_director_host => url,
      :vcloud_director_show_progress => true, # task progress bar on/off
    )

    @org = @vcloud.organizations.first
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


