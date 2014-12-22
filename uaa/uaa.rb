require 'rest_client'
require 'json'

module SkyscapeCF
  
  class Uaa
    def initialize(user,pass,url)
      @client = RestClient::Resource.new( url,user,pass)
      
      
    end
  
    def login
    query={:response_type => 'code', :client_id => 'login', :client_secret => 'password', :source=> 'login', :redirect_uri=> 'www.google.com', :username => 'user@email' }
      puts @client['oauth/token'].post(query.to_json, :accept => 'application/json' , :content_type => 'application/json'){ |response, request, result, &block|
        if [301, 302, 307].include? response.code
          response.follow_redirection(request, result, &block)
        else
          response.return!(request, result, &block)
        end
      }
    end
    
    def get_tokens
      puts @client['oauth/tokens'].get :accept => 'application/json'
    end
    
    def get_auth_code
      params = {
      :response_type => 'code',
      :client_id => 'servicesmgmt',
      :scope => 'read write password'
      }
      
      puts @client['oauth/authorize?response_type=code&client_id=servicesmgmt &scope=read%20write%20password'].get :accept => :json#  {:params => {:response_type => 'code',:client_id => 'login',:scope => 'read write password'}, :accept => 'application/json'}
      
    end
    
    def get_clients
      puts @client['oauth/authorize'].get :accept => 'application/json'
    end
    
    def get_token_key
      puts @client['token_key'].get :accept => 'application/json'
    end
    
    def authorise_token
    
    end
    
    def all
      #returns all users
    end
    
    def get_user(id)
    
    end
    
    def add_user(params)
    
    end
    
    def del_user(id)
    
    end
    
    def edit_user(id,params)
    
    end
    
    
  end
  
end
