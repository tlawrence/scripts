require_relative 'generators/gatewayipsecvpnservice'


ipsec = Ipsec::Generators::GatewayIpsecVpnService.new(ARGV.first)

puts ipsec.generate