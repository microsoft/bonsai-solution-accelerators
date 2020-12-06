$d = @{}
$sw = new-object System.Diagnostics.Stopwatch
$swTotal = new-object System.Diagnostics.Stopwatch

$ErrorActionPreference = 'Continue'

$swTotal.Start()

$subs = @("8b6b235b-bf57-4cc3-b64f-07cf78f9eb78","f4a777ae-540c-4214-ac89-6806513322a7","96620149-9f19-4092-bd26-dce08f1c15e5")
$random = Get-Random -Maximum $subs.Count
$the_chosen_sub = $subs[$random]

$regions = @("eastus2","westus2","westeurope")
$random = Get-Random -Maximum $regions.Count
$the_chosen_region = $regions[$random]

$bonsai_regions = @("westus","westus2")
$random = Get-Random -Maximum $bonsai_regions.Count
$the_chosen_bonsai_region = $bonsai_regions[$random]

$date = Get-Date

$month = ""
$day = ""
$year = $date.Year
$hour = ""
$min = ""

if ($date.Month -lt 10) {
    $month = "0"+$date.Month
}
else {
    $month = $date.Month
}


if ($date.Day -lt 10) {
    $day = "0"+$date.Day
}
else {
    $day = $date.Day
}

if ($date.Hour -lt 10) {
    $hour = "0"+$date.Hour
}
else {
    $hour = $date.Hour
}

if ($date.Minute -lt 10) {
    $minute = "0"+$date.Minute
}
else {
    $minute = $date.Minute
}

$group_name = "sa-test-$year-$month-$day-at-$hour-$minute"
$template_uri = "https://raw.githubusercontent.com/davidhcoe/b_sas/master/CreateSolutionAccelerator.json"
$workspace_name = "satest$hour$minute"
$vm_name = "bonsaiLgVm"

$random = Get-Random -Maximum 100
$vm_password = "Azure@VM!$year@$random"

$d["exceptions"] = "none"

try {
    
    $start_date = Get-Date
    $d["started_at"] = $start_date.DateTime
    $d["subscription_id"] = $the_chosen_sub
    $d["resourcegroup_name"] = $group_name
    $d["resourcegroup_created"] = $false
    $d["sa_created"] = $false
    $d["the_chosen_region"] = $the_chosen_region
    $d["bonsa_workspace_name"] = $workspace_name
    $d["bonsa_workspace_location"] = $the_chosen_bonsai_region
    $d["templateuri_name"] = $template_uri
    $d["vmname_name"] = $vm_name

    Write-Host "Setting subscription"

    az account set --subscription $the_chosen_sub

    Write-Host "Deploying group $group_name in $the_chosen_region"
    
    az group create -g $group_name -l $the_chosen_region

    $d["resourcegroup_created"] = $true

    $swTotal.Start()

    az deployment group create -g $group_name --template-uri $template_uri -p bonsaiWorkspaceLocation=$the_chosen_bonsai_region bonsaiWorkspaceName=$workspace_name virtualMachineName=$vm_name virtualMachinePassword=$vm_password

    $d["sa_created"] = $true

    $swTotal.Stop()

    $total_time = $swTotal.Elapsed.TotalMinutes

    $d["sa_creation_time"] = $total_time

    Write-Host "Deployment finished in $total_time minutes"

    $json = az deployment group list -g $group_name -o json
    $jObj = $json | ConvertFrom-Json


    $errors = ""

    for($num=0;$num -lt $jObj.Count;$num++)
    {
        $state = $jObj[$num].properties.provisioningState
        $d[$jObj[$num].name] = $state

        if ($state -eq "Failed") {
           $fJson = az deployment operation group list -g $group_name --query [*].properties.statusMessage -n $jObj[$num].name
           $fjObj = $fJson | ConvertFrom-Json

           $errors += " " + $jObj[$num].name + " -- " + $fjObj.error.code + " -- " + $fjObj.error.message 

           $d["errors"] = $errors
        }
    }

    Write-Host "Deleting $group_name"


    az group delete -g $group_name -y

}
catch {
    $d["exceptions"] = $_.Exception.Message
}

$post = ConvertTo-Json $d

Write-Host "Uploading"

$post | Out-File -FilePath  "C:\testresults\sa03\deployment\$group_name.json" -Encoding ascii

Write-Host "Done"