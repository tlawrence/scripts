require 'uaa'
require 'rest-client'
require 'json'

class Report
  def initialize (domain, user, pass,client, http_opts=nil)
    @uaa_url = "https://uaa.#{domain}"
    @api_url = "https://api.#{domain}"
    http_opts = {} unless http_opts
    @token = get_token(user,pass,client,http_opts)
  end


  def get_token(user,pass,client,http_opts=nil)

    token_issuer = CF::UAA::TokenIssuer.new(@uaa_url, client, nil, http_opts)


    token = token_issuer.implicit_grant_with_creds({username: user, password: pass},nil,@uaa_url)

     token = "bearer #{token.info["access_token"]}"
  end

  def get_resource(resource)

    response = JSON.parse(RestClient.get "#{@api_url}/v2/#{resource}", {:authorization => @token})
    resources = response['resources']
    page_count = response['total_pages']
    next_url = response['next_url']
    if page_count > 1 then
      until next_url == nil
        response = get_multipage_resource(next_url)
        resources << response['resources']
        next_url = response['next_url']        
      end
    end
    resources
  end

  def get_multipage_resource(resource)
    puts "Getting #{resource}"
    response = JSON.parse(RestClient.get "#{@api_url}#{resource}", {:authorization => @token})
  end

  def get_orgs
    get_resource('organizations')
  end

  def get_events(org_guid,since=nil)
    if since == nil
      get_resource("events?=organization_guid=#{org_guid}")
    else
      get_resource("events?=organization_guid=#{org_guid};timestamp>#{since}")
    end
  end
end
