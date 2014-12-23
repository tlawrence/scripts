module Deployment
  module Generators
    class SourcedItems
    
      def initialize
      
      end
      
      def add_items(params)
        body = Nokogiri::XML::Builder.new do |x|
          attrs = {
                    'xmlns:ovf' => 'http://schemas.dmtf.org/ovf/envelope/1',
                    :xmlns => 'http://www.vmware.com/vcloud/v1.5',
                    
                  }
          x.SourcedItems(attrs){
            params.each do |item|
              x.SourcedItem{
                x.Source(:href => item[:href], :name => item[:name])
                x.VAppScopedLocalId
                x.InstantiationParams
                x.NetworkAssignment
                x.StorageProfile
              }
            end
          }
          
        end.to_xml
        
  
      
      end
    
    end
  end
end