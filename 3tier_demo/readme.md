#vCloud Environment Deployer
##A tool to provision securely separated VMs in vCloud Director

##How it works

The tool is designed to take a configuration file (YAML format) which describes one or more vApps that are segregated into "tiers" (web / app / db etc). The tools will construct a vApp with separate vApp Edge firewalls for each tier and then populate each tier with the number of VMs specified in the configuration file using a template vm from a catalogue.
The firewall for each tier will be configured as per the configuration file.

##The Following YAML File:

![yml file example](https://github.com/tlawrence/scripts/blob/master/3tier_demo/images/yaml_file.jpg)

##When Deployed, Becomes:

![schematic](https://github.com/tlawrence/scripts/blob/master/3tier_demo/images/deployed_vapp.jpg)

##YAML Properties:
There is a sample configuration file called "environment.yml" in this repository. Most of the setting are self explanatory but a full list of settings is below. When deploying, ensure you honour the white space indentation as demonstrated in the 'environment.yml'

* name
  *  The name the vApp will be given in vCloud Director
* vdc
  * The name of the vCloud Virtual Datacentre which will host the vApp & Source Template
* catalogue
  * The name of the vcloud catalogue which holds the template VM that will be used to populate the vApp
* template
  * The name of the template VM that will be used to populate the vApp
* public_ip
  * Not yet implemented. Address to NAT to the front end of the App. 
* bastion_ip
  * IP address of a bastion vm or 'jump box' which will be used to access the VMs in this vApp. A firewall rule wil be added to each tier allowing SSH traffic from this VM
* backbone
  * configuration of the Org VDC Network which each firewall in the vApp will be connected to
    * name
      * The name as it appears in vCloud Director of the Org VDC Network. Must be unique within the vCloud Organisation
    * gateway
      * The desired default gateway for the network. vCloud will use this and the subnet mask to decipher the subnet id.
    * mask
      * The desired subnet mask for the backbone network
    * dns
      * Required but not yet fully implemented. DNS resolver that vApp VMs will inherit
* vms
  * This is the section where you define each tier of the app. It is an array (yaml uses the "-" symbol to separate array elements) so you can add as many tiers as you need
    * name
      * The name of the tier (web / app / db etc). The vApp network will be named using this label
    * quantity
      * How many VMs to fill this tier with. If you increase this figure and re-run the script then additional vms will be added to the tier to ensure compliance with the configuration. Reducing the number of VMs in the tier is not yet implemented
    * external
      * This must be an unused IP address on the backbone network. It will be added as the external interface of the tier's vShield Edge firewall
    * gateway
      * The desired default gateway for the tier's subnet. Currently the default tier subnet size is /24
    * rules
      * This section defines firewall rules for the tier. the rules section is an array allowing many rules to be added. A rule for SSH from the bastion IP is added by default and does not need to be specified here
        * name
          * A useful name for the firewall rule (eg http). Name is the array item definition and must be prefixed with a "-" 
        * source
          * Can be external (e.g anything outside the tier) / a singe IP address or a subnet in slash notation (e.g 10.0.1.0/24)
        * port
          * The destination port for the rule. 
        * protocol
          * The protocol for the rule. Valid options are TCP , UDP , ICMP or ANY



##Usage:
Firstly clone this repository:
`git clone https://github.com/tlawrence/scripts.git`

In the root of the repository there is a 'bootstrap.rb' file which you can fill in with your vCloud credentials. 
The project uses the Ruby Gem "Bundler" to handle any dependencies so ensure Ruby and the bundler gem are installed `gem install bundler` then from the root directory run:

`bundle exec ruby bootstrap.rb environment.yml`

This tells bundler to run the 'bootstrap.rb' script using the Ruby interpreter and the gems listed in 'Gemfile'. 'environemnt.yml' (your vApp config) is passed as an argument to 'bootstrap.rb'. the script will output useful information to the console.




