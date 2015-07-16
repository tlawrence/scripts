  
module Deployment
  module Generators
    class Recompose
      def self.generate(name,vdcname, parentnet, vappnets, bastion_ip, org)
          
        
        
          body = Nokogiri::XML::Builder.new do |x|
            attrs = {
                    'xmlns:ovf' => 'http://schemas.dmtf.org/ovf/envelope/1',
                    :xmlns => 'http://www.vmware.com/vcloud/v1.5',
                    :name => name
                    }
            x.RecomposeVAppParams(attrs){
              x.InstantiationParams{
                x.NetworkConfigSection{
                  x['ovf'].Info "Info"
                  vappnets.each do |net|
                    x.NetworkConfig(:networkName => net['name']){
                      x.Configuration{
                        x.IpScopes{
                          x.IpScope{
                            x.IsInherited false
                            x.Gateway net['gateway']
                            x.Netmask '255.255.255.0'
                            x.Dns1 '8.8.8.8'
                            x.Dns2
                            x.DnsSuffix
                            x.IpRanges{
                              x.IpRange{
                                x.StartAddress net['gateway'].gsub(/1$/,'2')
                                x.EndAddress net['gateway'].gsub(/1$/,'100')
                              }
                            }
                            x.AllocatedIpAddresses
                            x.SubAllocations
                            #x.IsEnabled true
                            
                            
                          }
                        }
                        x.ParentNetwork(:href =>  org.networks.get_by_name(parentnet).href)
                        x.FenceMode  "natRouted"
                        x.RetainNetInfoAcrossDeployments false
                        x.Features{
                          x.NatService{
                            x.IsEnabled false
                          }
                          x.FirewallService{
                            net['rules'].each do |rule|
                              x.FirewallRule{
                                x.IsEnabled true
                                x.Description rule['name']
                                x.Policy 'allow'
                                x.Protocols{
                                  case rule['protocol']
                                  when 'TCP'
                                    x.Other 'TCP'
                                  when 'UDP'
                                    x.Other 'UDP'
                                  when 'ICMP'
                                    x.Icmp true
                                  when 'ANY'
                                    x.Any true
                                  end
                                }
                                x.IcmpSubType
                                x.Port rule['port']
                                x.DestinationIp 'internal'
                                x.SourcePort -1
                                x.SourceIp rule['source']
                              }
                            end
                            x.FirewallRule{
                              x.IsEnabled true
                              x.Description 'SSH'
                              x.Policy 'allow'
                              x.Protocols{
                                x.Other 'TCP'
                              }
                              x.IcmpSubType
                              x.Port 22
                              x.DestinationIp 'internal'
                              x.SourcePort -1
                              x.SourceIp bastion_ip
                            }
                        }
                      }
                      x.SyslogServerSettings
                      x.RouterInfo{
                        x.ExternalIp '10.0.1.101'
                      }
                      }
                    }
                  end
                }
              }
            }
        
          end.to_xml
      end
    end
  end
end

