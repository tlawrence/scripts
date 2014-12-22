

module Deployment
  class Pooler
  
    def initialize(vcloud)
      @vcloud = vcloud
    end
    
    def populate(params,quantity)
      org = @vcloud.organizations.first
      vdc = org.vdcs.get_by_name(params['vapp']['vdc'])
      net = org.networks.get_by_name(params['vapp']['backbone']['name'])
      catalogue = org.catalogs.get_by_name(params['vapp']['catalogue'])
      image = catalogue.catalog_items.get_by_name(params['vapp']['template'])
      
      instantiate(image,vdc)
    end
    
    def instantiate(image,vdc)
      puts image.name
      options = {
        :vdc_id => vdc.id,
        :deploy => true,
        :powerOn => false,
      }
      
      image.instantiate('test',options)
        
    end
  
  end
end