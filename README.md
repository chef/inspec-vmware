# InSpec PowerCLI

This repository contains a collection of InSpec resources used to interact with the VMware platform.

## Using the VMware Target

### Via Arguments
```
inspec exec inspec-powercli -t vmware://USERNAME@VISERVER --password MY_PASSWORD
```

### Via Environment Variables
```
export VISERVER=10.0.0.10
export VISERVER_USERNAME=demouser
export VISERVER_PASSWORD=s0m3t1ngs3cuRe
inspec exec inspec-powercli -t vmware://
```

### Via the InSpec Shell

```
inspec shell -t vmware://USERNAME@VISERVER --password MY_PASSWORD --depends ./inspec-powercli
```

## Installing PowerCLI

### Windows 2012R2
```
Invoke-WebRequest -Uri "https://download.microsoft.com/download/C/4/1/C41378D4-7F41-4BBE-9D0D-0E4F98585C61/PackageManagement_x64.msi" -OutFile PackageManagement.msi
msiexec.exe /i C:\Users\vagrant\PackageManagement.msi /quiet
Set-PSRepository -Name "PSGallery" -InstallationPolicy "Trusted"
Install-Module -Name VMware.PowerCLI
```

### Linux
```
# Install PWSH
curl https://packages.microsoft.com/config/rhel/7/prod.repo | sudo tee /etc/yum.repos.d/microsoft.repo
sudo yum install -y powershell

pwsh # Enter Shell
Set-PSRepository -Name "PSGallery" -InstallationPolicy "Trusted"
Install-Module VMware.PowerCLI -Scope CurrentUser
```
