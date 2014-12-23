require 'yaml'
require 'nokogiri'
require_relative 'generators/sourced_items'
require_relative 'merger'

merger = Deployment::Merger.new('dummy')

vm_list = {
            'vm1' => 'https://vcloud/vm/1',
            'vm2' => 'https://vcloud/vm/2',
            'vm3' => 'https://vcloud/vm/3',
            'vm4' => 'https://vcloud/vm/4',
            'vm5' => 'https://vcloud/vm/5',
            'vm6' => 'https://vcloud/vm/6'
         }
         
adjustments = {
                'web' => 1,
                'app' => 2,
                'db' => 3
              }
params = YAML.load(File.open('environment.yml'))         

merger.merge_vms(params,vm_list,adjustments)