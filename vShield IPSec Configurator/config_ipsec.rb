require_relative 'generators/gatewayipsecvpnservice'
require_relative 'vcloud'

module Ipsec
  class Configure
    def initialize(vcd_config,tunnels)
      gen = Generators::GatewayIpsecVpnService.new(tunnels)
      
      puts gen.generate
      
      vcd = Vcloud.new(vcd_config)

      
      
    end
  end
end