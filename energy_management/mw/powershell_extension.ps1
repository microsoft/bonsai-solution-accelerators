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
mkdir c:\mathworks-examples


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
$wc.DownloadFile("https://diagsebvvxruezlc2c.blob.core.windows.net/exes/MicrosoftEdgeEnterpriseX64.msi","MicrosoftEdgeEnterpriseX64.msi")

#install Edge Chromium
#.\MicrosoftEdgeEnterpriseX64.msi /quiet /norestart

$log += "Installing Docker" + $nl

#download Docker Desktop
$wc.DownloadFile("https://desktop.docker.com/win/stable/Docker%20Desktop%20Installer.exe","dockerinstaller.exe")

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

setx /m BONSAI_SUBSCRIPTION $bonsai_subscription
setx /m BONSAI_RG $bonsai_rg
setx /m BONSAI_WORKSPACE $bonsai_workspace
setx /m BONSAI_ACR $bonsai_container_registry

#download the startup script to C:\ProgramData\Microsoft\Windows\Start Menu\Programs\StartUp
$wc.DownloadFile("https://raw.githubusercontent.com/microsoft/bonsai-solution-accelerators/mw/energy_management/mw/startup.bat","C:\ProgramData\Microsoft\Windows\Start Menu\Programs\StartUp\startup.bat")

$log += "Downloading startup" + $nl

Write-Host $log