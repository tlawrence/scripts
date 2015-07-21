require 'faraday'
require 'faraday'
require 'faraday_middleware'
require 'json'

class Portal
  def initialize(user,pass,host)
    
    @resource = Faraday.new(:url => "https://#{host}", :ssl => {:verify => false}) do |c|
      c.use Faraday::Adapter::NetHttp     # perform requests with Net::HTTP
      c.use Faraday::Response::Logger
      c.request :json
    end
    
    @resource.headers = {'Accept' => 'application/json', 'Content-Type' => 'application/json'}
    cookies = login(user,pass)
    @resource.headers['Cookie'] = cookies
    
    @data = JSON.parse(get_vms)
    

  end
  
  def login(user,pass)
    data = {:email => user, :password => pass}.to_json
    res = @resource.post '/api/authenticate' , data
    res.headers['set-cookie']
  end
  
  def orgs
    @data.each {|n| puts n[0]}
  end
  
  def vapps(org,vdc)
    out = []
    @data[org]["vapps"].each do |v|
    
      out.push v[vdc] unless v[vdc].nil?
    
    end
    
    out
  end
  
  def vdcs(org)
    @data[org]["vms"].each {|n| puts n.keys[0]}
  end
  
  def vms(org,vdc)
    out = []
    @data[org]["vms"].each do |v|
    
      out.push v[vdc] unless v[vdc].nil?
    
    end
    
    out
  end
  
  def vms_with_backup
    out = []
    @data[@data.keys[0]]["vms"].each do |vdc|
      vdc.each do |k,v|
        v.each do |vm|
          data = {
            :vdc => k,
            :name => vm["name"],
            :backups => vm["backups"]
          }
          out.push(data) if vm["backups"].length > 0
        end
      end
    end
    
    out
  end
  
  def get_vms
    res = @resource.get '/api/my_vm'
    res.body
  end
  
  def get_calls
    res = @resource.get '/api/my_calls'
    res.body
  end
  
  def get_call(call_id)
    res = @resource.get "/api/my_calls/#{call_id}"
    res.body
  end
  
  def create_call(prob_type, service_name, prob_area, classification, summary, detail)
    data = {prob_type => { :problem_area => prob_area, :service => service_name, :classification => classification, :summary => summary, :further_details => detail}}.to_json
    puts data
    res = @resource.post '/api/my_calls' , data
    puts res.body
    res.status
  end
  
end