
#create a Bonsai brain using the CLI (with retries) then
#update the brain with the inkling

$attempt = 0
$max_attempts = 5
$brainCreated = 0

$brainName = $args[0]
$inkFile = $args[1]

while($attempt -lt $max_attempts)
{
    $attempt += 1

    $currentBrains = bonsai brain list

    if($currentBrains.Count -gt 0)
    {
        
        foreach($brain in $currentBrains)
        {
            if($brain -eq $brainName)
            {
                $brainCreated = 1
                Write-Host "$brainName created successfully"
                break
            }
        }

        if($brainCreated -eq 1)
        {
            $attempt = $max_attempts+1
            break
        }
    }

    Write-Host "Creating brain $brainName"

    $result = bonsai brain create -n $brainName

    if ($result -contains "Error")
    {
        if($result -contains "already exists")
        {
            break
        }


    }
        
    Start-Sleep -Seconds 1
}

if($brainCreated -eq 1)
{
    bonsai brain version update-inkling --name $brainName  --version 1 --file="$inkFile" 
}