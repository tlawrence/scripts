require 'rest-client'

class SlackSignup
  def initialize(slack_key,slack_url)
    @slack_key = slack_key
    @slack_url = slack_url
  end
  
  def invite(user)
    first_name = user[0]
    last_name = user[1]
    email = user[2]
    data = {
      :email => email,
      :token => @slack_key,
      :first_name => first_name,
      :last_name => last_name,
      :_attempts => 1,
      :set_active => true
    
    }
    begin
      puts "Inviting user #{email}"
      response = RestClient.post("#{@slack_url}/api/users.admin.invite", data)
    rescue Exception => e
      puts "Error Inviting User #{email}:\n#{e.message}"
    end
    puts "User invited successfully\n#{response}"
  end
  
  
end