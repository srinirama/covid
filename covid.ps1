param ($pincode, $date, $HospitalName)

if (!$pincode -and !$date  ) { Write-Host "Usage : powershell .\covid.ps1 -pincode 600100 -date 14-05-2021 " 
break;
 }

$response = Invoke-WebRequest -Uri "https://cdn-api.co-vin.in/api/v2/appointment/sessions/calendarByPin?pincode=$pincode&date=$date" -Method Get -UseBasicParsing -ErrorAction SilentlyContinue


if (!$response.content ) { Write-Host "No Slots available" 
break;
 }

$output = $response.content | ConvertFrom-Json

$session = $output | select -expand centers 
$session.sessions
$session | ForEach-Object {
$hospital = $_.name

$_.sessions.ForEach({ $result = $_ | Format-Table -Property @{L='Hospital';E={$hospital}},@{L='Age';E={$_.min_age_limit}},@{L='Vaccine';E={$_.vaccine}},@{L='Availability';E={$_.available_capacity}},@{L='Date';E={$_.date}}|  Out-String  

$wshell = New-Object -ComObject Wscript.Shell 
$Output = $wshell.Popup($result)

}) 
}

