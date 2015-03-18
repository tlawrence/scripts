require_relative 'deploy.rb'

vcdconfig= {
  :user => 'xxx.xxx.xxxxx',
  :org => 'x-xxx-x-xxxxxx',
  :pass => 'password',
  :url => 'apiurl.cloudprovider.com'
}


configfile = ARGV[0]

vcd = Deployment::Deploy.new(configfile,vcdconfig)

vcd.deploy