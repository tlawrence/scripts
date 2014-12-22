require_relative 'socialcast'

sc = Socialcast.new


title = "Message title"
message = "Message Body"



puts sc.postmessage(title,message)
