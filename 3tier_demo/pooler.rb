require 'securerandom'
require_relative 'utils'

module Deployment
  class Pooler
  
    def initialize(vcloud)
      MAX_THREADS = 10
      @vcloud = vcloud
    end
    
    def populate(params,quantity)
      org = @vcloud.organizations.first
      vdc = org.vdcs.get_by_name(params['vapp']['vdc'])
      net = org.networks.get_by_name(params['vapp']['backbone']['name'])
      catalogue = org.catalogs.get_by_name(params['vapp']['catalogue'])
      image = catalogue.catalog_items.get_by_name(params['vapp']['template'])
      
      
      names = generate_names(quantity)
      
      
      names.map {|vm| instantiate(vm,image,vdc)}
    end
    
    def instantiate(name,image,vdc)
      
      options = {
        :vdc_id => vdc.id,
        :deploy => true,
        :powerOn => false,
      }
      puts " Deploying Pool VM: #{name}"
      vapp_id = image.instantiate(name,options)
      raise "Failed to Create Pool VM: #{name}" unless vapp_id
      puts " Completed Deployment Of Pool VM: #{name}"
      
    end
    
    def generate_names(quantity)
      
      names = []
      quantity.times {names.push SecureRandom.uuid}
      
      names
      
    end
  
  end
end