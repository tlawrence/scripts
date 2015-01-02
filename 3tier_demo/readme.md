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
..*  The name the vApp will be given in vCloud Director



##Usage:


