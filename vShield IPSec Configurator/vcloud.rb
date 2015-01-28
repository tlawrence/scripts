require 'fog'

module Ipsec
  class Vcloud
    def initialize(creds)
    
      @vcloud = Fog::Compute::VcloudDirector.new(
        :vcloud_director_username => "#{creds[:user]}@#{creds[:org]}",
        :vcloud_director_password => creds[:pass],
        :vcloud_director_host => creds[:url],
        :vcloud_director_show_progress => false, # task progress bar on/off
      )
      
      puts @vcloud.organizations.first.body
    end
    
    
  end
end