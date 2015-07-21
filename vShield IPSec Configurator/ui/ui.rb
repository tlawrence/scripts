require 'sinatra'
require 'json'

get '/' do
  erb :login
end

get '/login' do
  erb :login
end

post '/login' do
  #get list of vshields with query service
  vshields = 
    [
      {
        :name => 'nft123',
        :vdc_name => 'WEST_BASIC_IL2'
      },
      {
        :name => 'nft456',
        :vdc_name => 'EAST_BASIC_IL2'
      }
    ]
   
   erb :edge_select , :locals => {'vshields' => vshields}
end

post '/tunnel_info' do
  tunnels = [
    {
      :name => 'tunnel1',
      :peer_id => '83.124.42.12',
      :peer_ip => '83.124.42.12',
      :local_id => '83.124.42.12',
      :local_ip => '83.124.42.12',
      :shared_secret => '123456789skyscape123456789skyscape123456789',
      :local_networks => [
        {
          :name => 'DMZ',
          :gateway => '10.0.1.0',
          :netmask => '255.255.255.0'
        },
        {
          :name => 'DATA',
          :gateway => '10.0.2.0',
          :netmask => '255.255.255.0'
        }
      ],
      :peer_networks => [
        {
          :name => 'LOCAL',
          :gateway => '192.168.1.254',
          :netmask => '255.255.255.0'
        }
      ]
    }
    ]
   
  erb :tunnel_info , :locals => {'vshield_name' => params[:vshield], 'tunnels' => tunnels}
end



get '/api/tunnel_info' do 
  content_type :json
  data = [
    {
      :name => 'tunnel1',
      :peer_id => '83.124.42.12',
      :peer_ip => '83.124.42.12',
      :local_id => '83.124.42.12',
      :local_ip => '83.124.42.12',
      :shared_secret => '123456789skyscape123456789skyscape123456789',
      :local_networks => [
        {
          :name => 'DMZ',
          :gateway => '10.0.1.0',
          :netmask => '255.255.255.0'
        },
        {
          :name => 'DATA',
          :gateway => '10.0.2.0',
          :netmask => '255.255.255.0'
        }
      ],
      :peer_networks => [
        {
          :name => 'LOCAL',
          :gateway => '192.168.1.254',
          :netmask => '255.255.255.0'
        }
      ]
    }
    ].to_json
  
end

post '/api/tunnel_info' do 
out=''
params.each {|t| out << t.to_s}
out
end