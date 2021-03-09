#create a Bonsai brain using the CLI (with retries) then
#update the brain with the inkling

$attempt = 0
$max_attempts = 5
$packageCreated = 0

$packageName = $args[0]
$packageFile = $args[1]
$packageImage = $args[2]

while($attempt -lt $max_attempts)
{
    $attempt += 1

    #$currentBrains = bonsai brain list
    $currentPackages = bonsai simulator package list

    if($currentPackages.Count -gt 0)
    {
        foreach($package in $currentPackages)
        {
            if($package -eq $packageName)
            {
                $packageCreated = 1
                Write-Host "$packageName created successfully. It may take up to 10 minutes to fully create the container image."
                break
            }
        }

        if($packageCreated -eq 1)
        {
            $attempt = $max_attempts+1
            break
        }
    }

    Write-Host "Creating simulator package $packageName"

    $result = bonsai simulator package modelfile create -n $packageName -f $packageFile --base-image $packageImage

    if ($result -contains "Error")
    {
        if($result -contains "already exists")
        {
            break
        }


    }
        
    Start-Sleep -Seconds 1
}