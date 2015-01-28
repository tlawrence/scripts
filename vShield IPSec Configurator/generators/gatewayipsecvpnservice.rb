require 'yaml'
require 'nokogiri'

module Ipsec
  module Generators
    class GatewayIpsecVpnService
    
      def initialize(tunnels)
        @tunnel_data = YAML.load_file(tunnels)
      end
      
      def generate
        Nokogiri::XML::Builder.new do |x|
          x.GatewayIpsecVpnService{
            x.IsEnabled true
            x.Endpoint{
              x.Network(:type => 'application/vnd.vmware.admin.network+xml', :href => 'https://api.vcd.portal.skyscapecloud.com/api/admin/network/3c284ec8-2850-ba77-098c-7f697a3d8769')
              x.PublicIp @tunnel_data.first['local_ip']
            }
            @tunnel_data.each do |tunnel|
              x.Tunnel{
                x.Name tunnel['name']
                x.Description
                x.IpsecVpnThirdPartyPeer{
                  x.PeerId tunnel['peer_id']
                }
                x.PeerIpAddress tunnel['peer_ip']
                x.PeerId tunnel['peer_id']
                x.LocalIpAddress tunnel['local_ip']
                x.LocalId tunnel['local_id']
                tunnel['local_networks'].each do |local|
                  x.LocalSubnet{
                    x.Name local['name']
                    x.Gateway local['gateway']
                    x.Netmask local['netmask']
                  }
                end
                tunnel['peer_networks'].each do |peer|
                  x.PeerSubnet{
                    x.Name peer['name']
                    x.Gateway peer['gateway']
                    x.Netmask peer['netmask']
                  }
                end
                x.SharedSecret tunnel['shared_secret']
                x.SharedSecretEncrypted false
                x.EncryptionProtocol 'AES256'
                x.Mtu '1500'
                x.IsEnabled true
                x.IsOperational true
                
              }
            end
          }
        end.to_xml
            
      end
    end
  end
end