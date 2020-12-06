$d = @{}
$sw = new-object System.Diagnostics.Stopwatch
$swTotal = new-object System.Diagnostics.Stopwatch

$ErrorActionPreference = 'Continue'

$swTotal.Start()

$package_name = "ABCA"
$brain_name = "AnyLogic-ABCA"

$d["exceptions"] = "none"

try {
    #This is just an assurance
    Remove-Item $env:USERPROFILE\.AnyLogicProfessional -Force -Recurse 
    Remove-Item "C:\anylogic-examples\bonsai-anylogic" -Force -Recurse 

    $start_date = Get-Date
    $d["started_at"] = $start_date.DateTime
    $d["github_clone"] = $false
    $d["cli_installed"] = $false
    $d["subscription_id"] = $env:BONSAI_SUBSCRIPTION
    $d["workspace_id"] = $env:BONSAI_WORKSPACE
    $d["brain_created"] = $false
    $d["acr_created"] = $false
    $d["package_created"] = $false
    $d["anylogic_configured"] = $false

    $d["startup_succeeded"] = $false

    
    $swTotal.Start()

    Write-Host "Running startup.bat"

    $startup_batch = Start-Process -FilePath "cmd.exe" -ArgumentList "/c c:\startup\startup.bat test" -Wait
    
    
    $swTotal.Stop()

    $total_time = $swTotal.Elapsed.TotalMinutes

    $end_date = Get-Date
    $d["ended_at"] = $end_date.DateTime

    $d["startup_time"] = $total_time

    Write-Host "Startup finished in $total_time minutes"

    #github
    $d["github_clone"] = Test-Path -Path "C:\anylogic-examples\bonsai-anylogic"
    
    #cli
    $cli = pip show bonsai-cli
    $cliObj = $cli | ConvertFrom-String

    $installed = $false
    $version = ""

    if($cliObj[0].P2 -eq "bonsai-cli")
    {
        $installed = $true

        $version = $cliObj[1].P2
    }

    $d["cli_installed"] = $installed
    $d["cli_version"] = $version
    

    #brain
    $brain = bonsai brain show -n $brain_name 
    $brain_created = $false
    $brainObj = $brain | ConvertFrom-String

    if($brainObj[0].P2 -eq $brain_name) {
        $brain_created = $true
    }

    $d["brain_created"] = $brain_created

    #ACR
    $acr = az  acr repository list -n $env:BONSAI_ACR
   
    $acr_created = $false
    
    if($acr[1].Trim() -contains '"anylogic-abca"')
    {
        $acr_created = $true
    }

    $d["acr_created"] = $acr_created


    #package
    $package = bonsai simulator package show -n $package_name

    $pObj = $package | ConvertFrom-String
    $package_created = $false
    
    if($pObj[0].P2 -eq $package_name)
    {
        $package_created = $true
    }

    $d["package_created"] = $package_created


    $d["anylogic_configured"] = Test-Path -Path $env:USERPROFILE\.AnyLogicProfessional\anylogic6.license
    
    
    #if(get-process | ?{$_.path -eq "C:\Program Files\AnyLogic 8.6 Professional\AnyLogic.exe" }){
    #    $d["anylogic_running"] = $true
    #}

    
    Write-Host "Deleting brain AnyLogic-ABCA "
    bonsai brain delete -n $brain_name -y

    Write-Host "Deleting package ABCA"
    bonsai simulator package remove -n $package_name -y

    #Write-Host "Uninstalling Bonsai CLI"
    #pip uninstall bonsai-cli -y


    Write-Host "deleting ACR repository"
    az acr repository delete --name $env:BONSAI_ACR --image anylogic-abca:v1 -y

    Write-Host "removing VS code extension"
    cmd /c code --uninstall-extension ms-inkling.ms-inkling


    Write-Host "deleting files"

    Remove-Item $env:USERPROFILE\.AnyLogicProfessional -Force -Recurse 

    Remove-Item "C:\anylogic-examples\bonsai-anylogic" -Force -Recurse 
    
    net localgroup docker-users "BonsaiUser" /DELETE

    Write-Host "killing processes"
    taskkill /F /IM AnyLogic.exe /T
    
    taskkill /F /IM MSEdge.exe
    
    $d["startup_succeeded"] = $true

}
catch {
    $d["exceptions"] = $_.Exception.Message
}

$post = ConvertTo-Json $d

Write-Host "Uploading"

$guid = New-Guid

$guid = $guid.Guid

Write-Host $post

$post | Out-File -FilePath "C:\testresults\sa03\startup\$guid.json" -Encoding ascii

Write-Host "Done"