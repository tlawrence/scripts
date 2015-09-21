$org = "000-000-000"
$vapp_name = "vapp name"
$vdc_name = "virtual datacentre name"
$vm_name = "virtual machine name"
$destination_storage_name = "target storage profile name"
$url = "api hostname (eg api.yourcloud.com)"

write-host "Logging In"
$creds = get-credential
connect-ciserver $url -org $org -credential $creds


write-host "Getting Source vApp"

$vapp = get-civapp $vapp_name|get-CiView
$vm = $vapp.Children.Vm|where {$_.name -eq $vm_name}

write-host "Getting Target Storage Profile Details"

$vdc = Get-OrgVdc $vdc_name|Get-CIView


$storage_profile = $vdc.VdcStorageProfiles.VdcStorageProfile|where {$_.name -eq $destination_storage_name}


write-host "Updating (May take a long time)"

$vm.StorageProfile = $storage_profile
$vm.UpdateServerData()