require 'json'

data = JSON.parse(File.open('out.json').read)

totalcosttoday = 0
totalestimated = 0
totalvms = 0
standardretention = 0
highretention = 0

data["vOrgs"].map do |org|
  puts = "#{org['name']}:"
  org["VDCs"].map do |vdc|
    puts "    #{vdc["name"]}"
    vdc["vApps"].map do |vapp|
      puts "       vApp: #{vapp["name"]} => #{vapp["VMs"].count} VMs"
      vapp["VMs"].map do |vm|
      
        totalcosttoday += vm["billedHoursPoweredOn"]
        totalestimated += vm["billedHoursPoweredOff"]
        totalvms += 1
        standardretention += 1 if vm["retentionLength"] == 14
        highretention += 1 if vm["retentionLength"] > 14
        
        puts "           VM: #{vm["name"]}"
        puts "               Hours On: #{vm["billedHoursPoweredOn"]}"
        puts "               Hours Off: #{vm["billedHoursPoweredOff"]}"
        puts "               Cost This Month: £#{vm["monthToDate"]}"
        puts "               Estimated Total: £#{vm["estimatedMonthlyTotal"]}"
        puts "               Hours On: #{vm["retentionLength"]}"
      end
    end
  end
  
end

puts "\n\nTotal Number Of VMs:            #{totalvms}"
puts "Number Of VMs In 14 Day Backup: #{standardretention}"
puts "Number Of VMs In 28 Day Backup: #{highretention}"
puts "Total Cost To Date:             £#{totalcosttoday}"
puts "Total Estimate Cost This Month: £#{totalestimated}"