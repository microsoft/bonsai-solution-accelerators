$eventText = $args[0]

$AppInsightsDll = Convert-Path .\Microsoft.ApplicationInsights.dll
Add-Type -Path $AppInsightsDll

$client=New-Object Microsoft.ApplicationInsights.TelemetryClient 
$client.InstrumentationKey = "e14dbaef-8ab4-4e56-9e34-bdcf548b14a3"

$enabled = 1

if($enabled -eq 1)
{
    $client.TrackEvent($eventText)
    $client.Flush()
}