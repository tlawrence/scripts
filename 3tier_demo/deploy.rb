require 'yaml'
require_relative 'fog.rb'

module Deployment
  class Deploy
    def initialize(config, vcdconfig)
      @config = YAML.load(File.open(config))
      @vcdconfig = vcdconfig

    end

    def deploy()


      @vcd = Vcloud.new(@vcdconfig[:user],@vcdconfig[:pass],@vcdconfig[:org],@vcdconfig[:url])
      backbone = @config['vapp']['backbone']
      vdcname = @config['vapp']['vdc']
      unless @vcd.netexists?(backbone['name'])
        puts 'Creating Backbone Network'
        @vcd.createnet(backbone['name'], vdcname, backbone['gateway'], backbone['mask'], backbone['dns'])
      else
        puts 'Backbone Net Found'
      end

      puts 'Creating vApp & Networks'
      @vcd.create_or_update_vapp(@config)

      
     #puts 'Configuring Edge Gateway Rules/Routes'
     #@vcd.configure_edge_gateway(@config['vapp']['vms'])

    end

  end
end