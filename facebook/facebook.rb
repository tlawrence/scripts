require 'koala'

class Facebook

  def initialize(token)
    @fb = Koala::Facebook::API.new(token)
  end
  
  def allcomments(friend)
    @fb.fql_query
  end
  
end

