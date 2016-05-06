require_relative 'portal.rb'
require 'objspace'

class Demo

  def initialize(user,pass,host)
    portal = Portal.new(user,pass,host)
    
    
    org = "Deep Dive Trial"
    vdc = "SkyScape - The Deep Dive West (IL2-TRIAL-BASIC)"

    #portal.orgs  
    
    #portal.vdcs("Demo") ##CURRENTLY AFFECTED BY BUG - RETURNS ALL VDCS
    
    #puts portal.vapps(org,vdc)
    
    #puts portal.vms(org,vdc)

    #portal.vms_with_backup.each do |vm|
    #  puts "VM: #{vm[:name]} VDC: #{vm[:vdc]} BACKUPS: #{vm[:backups].length}"
    #end
    before =  Time.now
    ##data =  portal.get_vms
    data = portal.get_services("76")
    #data = portal.get_accounts
    
    #puts data
    after = Time.now
    
    duration = after - before
    
    
    
    puts duration.to_f
    
    puts ObjectSpace.memsize_of(data)
    File.open('out.json', 'w') { |file| file.write(data) }
    
    #puts data["IPT"]["vms"].length
    #puts portal.get_call("REQ1003488")

    #puts portal.create_call('incident', 'StephenBoroughCouncil', 'compute', 'Production Service > unavailable or unresponsive', 'Call Subject', 'Call Description')
  end
end