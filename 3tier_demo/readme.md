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



##Usage:


