
##################

# Tests the download of files and executes the startup_test because that has dependencies on the files downloaded here

##################

$wc = New-Object System.Net.WebClient
$d = @{}  #New-Object System.Collections.Generic.Dictionary[string,string] "system.collections.generic.dictionary[string,string]"
[System.Reflection.Assembly]::LoadWithPartialName("System.Diagnostics")
$sw = new-object System.Diagnostics.Stopwatch
$swTotal = new-object System.Diagnostics.Stopwatch

$ErrorActionPreference = 'Continue'

$swTotal.Start()

$downloads_folder = "C:\startup"


if(Test-Path -Path $downloads_folder) {

}
else
{
    mkdir $downloads_folder
}


$start = Get-Date
$start_time = $start.DateTime
$python_file = $downloads_folder + "\python-3.7.9-amd64.exe"
$python_file_exists = $false
$git_file = $downloads_folder + "\Git-2.28.0-64-bit.exe"
$git_file_exists = $false
$cli_file = $downloads_folder + "\AzureCliInstaller.msi"
$cli_file_exists = $false
$docker_file = $downloads_folder + "\dockerinstaller.exe"
$docker_file_exists = $false
$vscode_file = $downloads_folder + "\VsCodeSetup.exe"
$vscode_file_exists = $false
$anylogic_file = $downloads_folder + "\anylogic-professional-8.6.0.x86_64.exe"
$anylogic_file_exists = $false
$firewall_file = $downloads_folder + "\advfirewallpolicy.wfw"
$firewall_file_exists = $false
$anylogicinfo_file = $downloads_folder + "\anylogic6.zip"
$anylogicinfo_file_exists = $false
$startup_file = $downloads_folder + "\startup.bat"
$startup_file_exists = $false

$d["start_run_time"] = $start_time

$d["python_file"] = $python_file
$d["python_file_exists"] = $python_file_exists
$d["python_file_download_time"] = 0

$d["git_file"] = $git_file 
$d["git_file_exists"] = $git_file_exists
$d["git_file_download_time"] = 0

$d["cli_file"] = $cli_file
$d["cli_file_exists"] = $cli_file_exists
$d["cli_file_download_time"] = 0

$d["docker_file"] = $docker_file
$d["docker_file_exists"] = $docker_file_exists
$d["docker_file_download_time"] = 0

$d["vscode_file"] = $vscode_file
$d["vscode_file_exists"] = $vscode_file_exists
$d["vscode_file_download_time"] = 0

$d["anylogic_file"] = $anylogic_file
$d["anylogic_file_exists"] = $anylogic_file_exists
$d["anylogic_file_download_time"] = 0

$d["firewall_file"] = $firewall_file
$d["firewall_file_exists"] = $firewall_file_exists 
$d["firewall_file_download_time"] = 0

$d["anylogicinfo_file"] = $anylogicinfo_file
$d["anylogicinfo_file_exists"] = $anylogicinfo_file_exists
$d["anylogicinfo_file_download_time"] = 0

$d["startup_file"] = $startup_file
$d["startup_file_exists"] = $startup_file_exists
$d["startup_file_download_time"] = 0

$d["end_run_time"] = ""
$d["exceptions"] = "none"

try
{

    #download python (to use Bonsai CLI)
    $sw.Start()
    Write-Host "Downloading Python"
    $wc.DownloadFile("https://www.python.org/ftp/python/3.7.9/python-3.7.9-amd64.exe",$python_file)
    $sw.Stop()

    $python_file_exists = Test-Path $python_file
    $d["python_file_exists"] = $python_file_exists
    $d["python_file_download_time"] = $sw.Elapsed.TotalMinutes

    #download git
    $sw.Restart()
    Write-Host "Downloading Git"
    $wc.DownloadFile("https://github.com/git-for-windows/git/releases/download/v2.28.0.windows.1/Git-2.28.0-64-bit.exe",$git_file)
    $sw.Stop()

    $git_file_exists = Test-Path $git_file
    $d["git_file_exists"] = $git_file_exists 
    $d["git_file_download_time"] = $sw.Elapsed.TotalMinutes

    #download Azure CLI
    $sw.Restart()
    Write-Host "Downloading Azure CLI"
    $wc.DownloadFile("https://aka.ms/installazurecliwindows",$cli_file)
    $sw.Stop()

    $cli_file_exists = Test-Path $cli_file
    $d["cli_file_exists"] = $cli_file_exists 
    $d["cli_file_download_time"] = $sw.Elapsed.TotalMinutes
    
    #download Docker Desktop
    $sw.Restart()
    Write-Host "Downloading Docker"
    $wc.DownloadFile("https://desktop.docker.com/win/stable/Docker%20Desktop%20Installer.exe",$docker_file)
    $sw.Stop()

    $docker_file_exists = Test-Path $docker_file
    $d["docker_file_exists"] = $docker_file_exists 
    $d["docker_file_download_time"] = $sw.Elapsed.TotalMinutes
        
    # download VS Code
    $sw.Restart()
    Write-Host "Downloading VS Code"
    $wc.DownloadFile("https://go.microsoft.com/fwlink/?Linkid=852157",$vscode_file)
    $sw.Stop()

    $vscode_file_exists = Test-Path $vscode_file
    $d["vscode_file_exists"] = $vscode_file_exists 
    $d["vscode_file_download_time"] = $sw.Elapsed.TotalMinutes

    #download AnyLogic
    $sw.Restart()
    Write-Host "Downloading AnyLogic"
    $wc.DownloadFile("https://diagsebvvxruezlc2c.blob.core.windows.net/exes/anylogic-professional-8.6.0.x86_64.exe",$anylogic_file)
    $sw.Stop()

    $anylogic_file_exists = Test-Path $anylogic_file
    $d["anylogic_file_exists"] = $anylogic_file_exists 
    $d["anylogic_file_download_time"] = $sw.Elapsed.TotalMinutes

    #download the firewall rules
    $sw.Restart()
    Write-Host "Downloading firewall rules"
    $wc.DownloadFile("https://raw.githubusercontent.com/davidhcoe/b_sas/master/advfirewallpolicy.wfw",$firewall_file)
    $sw.Stop()

    $firewall_file_exists = Test-Path $firewall_file
    $d["firewall_file_exists"] = $firewall_file_exists 
    $d["firewall_file_download_time"] = $sw.Elapsed.TotalMinutes
    
    #download AnyLogic info
    $sw.Restart()
    Write-Host "Downloading AnyLogic info"
    $wc.DownloadFile("https://diagsebvvxruezlc2c.blob.core.windows.net/exes/anylogic6.zip",$anylogicinfo_file)
    $sw.Stop()

    $anylogicinfo_file_exists = Test-Path $anylogicinfo_file
    $d["anylogicinfo_file_exists"] = $anylogicinfo_file_exists 
    $d["anylogicinfo_file_download_time"] = $sw.Elapsed.TotalMinutes

    #download the startup script to C:\ProgramData\Microsoft\Windows\Start Menu\Programs\StartUp
    $sw.Restart()
    Write-Host "Downloading startup.bat"
    $wc.DownloadFile("https://raw.githubusercontent.com/davidhcoe/b_sas/master/startup.bat",$startup_file)
    $sw.Stop()

    $startup_file_exists = Test-Path $startup_file
    $d["startup_file_exists"] = $startup_file_exists 
    $d["startup_file_download_time"] = $sw.Elapsed.TotalMinutes

    Write-Host "Done downloading"


    Write-Host "Running StartupTest"

    Start-Process -FilePath "powershell.exe" -ArgumentList "-ExecutionPolicy", "Unrestricted","-File","c:\dev\b_sas\tests\startup_test.ps1" -Wait

    Write-Host "Starting cleanup"

    #Remove-Item $downloads_folder -Force -Recurse

    Write-Host "Cleaning up complete"

}
catch {
    $d["exceptions"] = $_.Exception.Message
}

$end_runtime = Get-Date

$d["end_runtime"] = $end_runtime.DateTime

$swTotal.Stop()

$d["total_runtime"] = $swTotal.Elapsed.TotalMinutes

$post = ConvertTo-Json $d

Write-Host "Uploading"

$guid = New-Guid
$guid = $guid.Guid
$post | Out-File -FilePath "C:\testresults\sa03\vm_extension\$guid.json" -Encoding ascii

Write-Host "Done"