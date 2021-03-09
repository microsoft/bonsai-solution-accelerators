$eventText = $args[0]

$AppInsightsDll = "C:\startup\Microsoft.ApplicationInsights.dll"
Add-Type -Path $AppInsightsDll

$client=New-Object Microsoft.ApplicationInsights.TelemetryClient 
$client.InstrumentationKey = "e14dbaef-8ab4-4e56-9e34-bdcf548b14a3"

#set enabled = 0 to disable logging
$enabled = 1

if($enabled -eq 1)
{
    $client.TrackEvent($eventText)
    $client.Flush()
}