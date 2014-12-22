$credfolder = "c:\scripts\vm control\creds"



write-host "Enter Org ID"
$orgid = read-host

write-host "Enter Credentials"
$creds = get-credential

if ((test-path $credfolder) -eq $False)
{
	mkdir $credfolder
}

$creds.Password | ConvertFrom-SecureString | Set-Content  -Path "$credfolder\$orgid.cred"
Add-Content -Path "$credfolder\$orgid.cred" -value $creds.UserName
