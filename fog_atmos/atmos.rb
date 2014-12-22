require 'fog'


class Atmos

  def initialize(url,uid,secret)
    puts "Connecting To Atmos #{url}"
    @stor = Fog::Storage.new(

	{

	#:provider                 => 'AWS',
	#:aws_access_key_id        => uid,
  	#:aws_secret_access_key    => secret,
  	#:host                     => url,
  	#:port                     => '8443',
  	#:path_style               => 'true'

	:provider => 'Atmos',
	:atmos_storage_endpoint => url,
        :atmos_storage_secret => secret,
        :atmos_storage_token => uid
	}
	)

  end

  def dirall
    @stor.directories.each {|folder| self.dir(folder)}
  end


  def dir(folder)
    folder.directories.each {|folder| puts "Folder: #{folder.key}";self.dir(folder);}
    folder.files.each {|file| puts "File: #{file.key}"}
  end


end
