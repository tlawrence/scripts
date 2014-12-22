require 'ruby_vcloud_sdk'

class Sdk

  def initialize(user,pass,org,url)
    @client = VCloudSdk::Client.new(url, "#{user}@#{org}",pass)
    

  end


  def deploy(catalogue,stemcell,vdc_name,vapp_name)
    vdc = @client.find_vdc_by_name(vdc_name)
    cat = @client.find_catalog_by_name(catalogue)
    begin
      vapp = cat.instantiate_vapp_template(stemcell,vdc_name,vapp_name)
    rescue Exception => e
      puts "Exception Whilst Deploying vApp. Maybe It Already Exists?"
      vapp = vdc.find_vapp_by_name(vapp_name)

    end

    disk = vdc.create_disk('independent_disk_test_1',8192,vapp.vms[0])

    vm = vapp.vms[0]
    vm.attach_disk(disk)
   
  end

  def cleanup(vdc_name,vapp_name)
    vdc = @client.find_vdc_by_name(vdc_name)
    disks = vdc.list_disks
    vapp = vdc.find_vapp_by_name(vapp_name)
    vm = vapp.vms[0]
    vm.independent_disks.each do |ind|
      if ind.attached?
        vm.detach_disk(ind)
      end
    end

    disks.each do |disk|
      if disk.include?("independent_disk_test")
        begin
          vdc.delete_all_disks_by_name(disk)
        rescue Exception => e
        end
      end
    end

    begin
      vapp.power_off
    rescue Exception => e
      puts "vApp Power Off Failed: #{e}"
    ensure
      vapp.delete
    end
  end




end
