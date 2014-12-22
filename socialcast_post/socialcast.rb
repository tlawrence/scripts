require 'rest-client'
require 'yaml'

class Socialcast
  @config
  @client
  def initialize
    @config = symbolize_keys(YAML.load(File.open('.creds')))
    RestClient.log = 'rest.log'
    @client = RestClient::Resource.new( @config[:url], @config[:user], @config[:password])
    
   
    
    
  end

  def postmessage(title,message)
  
    response = JSON.parse(@client['api/messages.json'].post({:message=>{:body=> message, :title => title, :group_id=> getgroup}}))
    
  end
  
  def listgroups
    groups = {}
    data = JSON.parse(@client['api/groups.json'].get)
    data['groups'].each {|group| groups[group['name']] = group['id']}
    
    groups
  end
  
  def getgroup
    self.listgroups[@config[:group]]
    
  end
  
  def getgroupbyname(name)
    
    
    name = listgroups[name] 
    
    data = JSON.parse(@client["api/groups/#{name}.json"].get)
  end
  private
  
  
  
  def symbolize_keys(myhash)
    myhash.keys.each do |key|
      myhash[(key.to_sym rescue key) || key] = myhash.delete(key)
    end
    myhash
  end
  
end
