# RahatOS Progress Center
# Microsoft 365 Device Compliance Report
# Author: Md Rahat Islam Anik

Write-Host "======================================="
Write-Host " RAHATOS | DEVICE COMPLIANCE REPORT "
Write-Host "======================================="

Connect-MgGraph -Scopes "Device.Read.All","Directory.Read.All"

$ReportPath = "$HOME/Documents/RahatOS-Progress-Center/reports/m365"
New-Item -ItemType Directory -Force -Path $ReportPath | Out-Null

$DateStamp = Get-Date -Format "yyyy-MM-dd_HH-mm"

Write-Host "`nCollecting device data..." -ForegroundColor Yellow

$Devices = Get-MgDevice -All -Property DisplayName,OperatingSystem,TrustType,AccountEnabled,ApproximateLastSignInDateTime,DeviceId

$Results = foreach ($Device in $Devices) {
    [PSCustomObject]@{
        DeviceName       = $Device.DisplayName
        OperatingSystem  = $Device.OperatingSystem
        TrustType        = $Device.TrustType
        AccountEnabled   = $Device.AccountEnabled
        LastSignIn       = $Device.ApproximateLastSignInDateTime
        DeviceId         = $Device.DeviceId
    }
}

$CsvFile = "$ReportPath/Device_Compliance_Report_$DateStamp.csv"
$Results | Export-Csv -Path $CsvFile -NoTypeInformation

Write-Host "`nDEVICE COMPLIANCE REPORT COMPLETE" -ForegroundColor Green
Write-Host "Total Devices: $($Results.Count)" -ForegroundColor Cyan
Write-Host "CSV Exported: $CsvFile" -ForegroundColor Green