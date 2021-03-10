$wc = New-Object System.Net.WebClient

$nl = [Environment]::NewLine
$log = ""

$log += "Downloading Python" + $nl

#download python (to use Bonsai CLI)
$wc.DownloadFile("https://www.python.org/ftp/python/3.7.9/python-3.7.9-amd64.exe","python-3.7.9-amd64.exe")

$log += "Installing Python" + $nl

#install Python
cmd /c .\python-3.7.9-amd64.exe /quiet InstallAllUsers=1 PrependPath=1 Include_test=0


$log += "Creating directories" + $nl

#create the startup folders (used by the bat script)
mkdir c:\startup
mkdir c:\anylogic-examples


$log += "Updating path" + $nl


# update environment path
$env:path += "; C:\Program Files\Python37; C:\Program Files\Python37\Scripts"


$log += "Path is now " + $env:path + $nl

$log += "Downloading git" + $nl

#download git
$wc.DownloadFile("https://github.com/git-for-windows/git/releases/download/v2.28.0.windows.1/Git-2.28.0-64-bit.exe","Git-2.28.0-64-bit.exe")


$log += "Installing git" + $nl

#install git
cmd /c .\Git-2.28.0-64-bit.exe /SP- /VERYSILENT /NORESTART

$log += "Downloading Azure CLI" + $nl

#download Azure CLI
$wc.DownloadFile("https://aka.ms/installazurecliwindows","AzureCliInstaller.msi")

$log += "Installing Azure CLI" + $nl

#install Azure CLI
.\AzureCliInstaller.msi /quiet

#download Edge Chromium
$wc.DownloadFile("https://diagsebvvxruezlc2c.blob.core.windows.net/exes/MicrosoftEdgeEnterpriseX64.msi","c:\startup\MicrosoftEdgeEnterpriseX64.msi")

$log += "Installing Docker" + $nl

#download Docker Desktop
$wc.DownloadFile("https://desktop.docker.com/win/stable/Docker%20Desktop%20Installer.exe","c:\startup\dockerinstaller.exe")

#install Docker
#.\dockerinstaller.exe install --quiet

#add the BonsaiUser to the docker-users group
# net localgroup docker-users "BonsaiUser" /ADD

#$env:path += ";C:\Program Files\Docker\Docker\resources\"

#download VS Code
$log += "Installing VS Code" + $nl

$wc.DownloadFile("https://go.microsoft.com/fwlink/?Linkid=852157","VsCodeSetup.exe")

.\VsCodeSetup.exe /VERYSILENT /NORESTART /MERGETASKS=!runcode

$log += "Setting environment variables" + $nl

#set the workspace environment variables
$bonsai_subscription = $args[0]
$bonsai_rg = $args[1]
$bonsai_workspace = $args[2]
$bonsai_container_registry = $args[3]
$bonsai_tenant = $args[4]

setx /m BONSAI_SUBSCRIPTION $bonsai_subscription
setx /m BONSAI_RG $bonsai_rg
setx /m BONSAI_WORKSPACE $bonsai_workspace
setx /m BONSAI_ACR $bonsai_container_registry
setx /m BONSAI_TENANT $bonsai_tenant

$log += "Downloading AnyLogic" + $nl

#download AnyLogic
$wc.DownloadFile("https://diagsebvvxruezlc2c.blob.core.windows.net/exes/anylogic-ple-8.7.0.x86_64.exe","anylogic-ple-8.7.0.x86_64.exe")

$log += "Installing AnyLogic" + $nl

#install AnyLogic silently
cmd /c .\anylogic-ple-8.7.0.x86_64.exe /S

#$log += "Downloading firewall rules" + $nl

#download the firewall rules
$wc.DownloadFile("https://github.com/microsoft/bonsai-solution-accelerators/blob/main/logistics_supply_chain/factory_logistics/advfirewallpolicy.wfw?raw=true","C:\StartUp\advfirewallpolicy.wfw")

$log += "Downloading AnyLogic environment configuration" + $nl

#download AnyLogic info
$wc.DownloadFile("https://diagsebvvxruezlc2c.blob.core.windows.net/exes/ple8.7.zip","C:\startup\ple8.7.zip")

$log += "Downloading AnyLogic environment configuration" + $nl

$branch = "mw"

#download the startup script to C:\ProgramData\Microsoft\Windows\Start Menu\Programs\StartUp
$wc.DownloadFile("https://raw.githubusercontent.com/microsoft/bonsai-solution-accelerators/$branch/logistics_supply_chain/factory_logistics/startup.bat","C:\ProgramData\Microsoft\Windows\Start Menu\Programs\StartUp\startup.bat")
$wc.DownloadFile("https://raw.githubusercontent.com/microsoft/bonsai-solution-accelerators/$branch/shared/logger.ps1","C:\StartUp\logger.ps1")
$wc.DownloadFile("https://raw.githubusercontent.com/microsoft/bonsai-solution-accelerators/$branch/shared/createBrain.ps1","C:\StartUp\createBrain.ps1")
$wc.DownloadFile("https://raw.githubusercontent.com/microsoft/bonsai-solution-accelerators/$branch/shared/createSimPackage.ps1","C:\StartUp\createSimPackage.ps1")
$wc.DownloadFile("https://raw.githubusercontent.com/microsoft/bonsai-solution-accelerators/$branch/shared/Microsoft.ApplicationInsights.dll","C:\StartUp\Microsoft.ApplicationInsights.dll")


$log += "Downloading startup" + $nl

Write-Host $log