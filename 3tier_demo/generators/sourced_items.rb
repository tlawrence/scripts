module Deployment
  module Generators
    class SourcedItems
    
      def initialize
      
      end
      
      def add_items(params,vapp_name)
        body = Nokogiri::XML::Builder.new do |x|
          attrs = {
                    'xmlns:ovf' => 'http://schemas.dmtf.org/ovf/envelope/1',
                    :xmlns => 'http://www.vmware.com/vcloud/v1.5',
                    :name => vapp_name
                  }
          x.RecomposeVAppParams(attrs){
            params.each do |item|
              x.SourcedItem(:sourceDelete => true){
                x.Source(:href => item[:href], :name => item[:name])
                #x.VAppScopedLocalId
                x.InstantiationParams{
                  x.NetworkConnectionSection{
                      x['ovf'].Info "Info"
                      x.NetworkConnection(:needsCustomization => true, :network => item[:tier]){
                      x.NetworkConnectionIndex 0
                      x.IsConnected true
                      x.IpAddressAllocationMode "POOL"
                    }
                  }
                }
                #x.NetworkAssignment
                #x.StorageProfile
              }
            end
          }
          
        end.to_xml
        
  
      
      end
    
    end
  end
end