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
    
    

  end
  
  def login(user,pass)
    data = {:email => user, :password => pass}.to_json
    res = @resource.post '/api/authenticate' , data
    res.headers['set-cookie']
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