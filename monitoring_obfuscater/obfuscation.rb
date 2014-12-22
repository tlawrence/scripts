###DATA BELOW WOULD BE PASSED INTO SCRIPT FROM MONITORING SYSTEM###
hostname = 'cust-web-01'
status = 'CRITICAL'
started = '2014-27-11 00:01:00'
timenow = '2014-27-11 00:02:00'
threshold = '70%'
current = '75%'
###################################################################

#aliases is a key/value map of customer system name to codename
aliases = {'cust' => 'indigo', 'cust2'=> 'violet'}

#split customer id from hostname
hostparts = hostname.split('-')

#lookup codename from aliases map
codename = aliases[hostparts[0]]

#use rest of hostname in message
host = hostname.gsub("#{hostparts[0]}-","")


#put it all together
message = "Alert:\nSystem: #{codename}\nHost: #{host}\nStatus: #{status}\nStarted: #{started}\nTimenow: #{timenow}\nThreshold:#{threshold}\nCurrent: #{current}"

#print it out
puts message

