# Enterprise IT Security Operations Toolkit
# Microsoft Intune Managed Device Compliance Report
# Author: Md Rahat Islam Anik

Write-Host "======================================="
Write-Host " ENTERPRISE SECURITY OPS | DEVICE COMPLIANCE REPORT "
Write-Host "======================================="

Connect-MgGraph -Scopes "DeviceManagementManagedDevices.Read.All"

$ReportPath = Join-Path $PSScriptRoot "../../phase-1-enterprise-operations-foundation/reports"
New-Item -ItemType Directory -Force -Path $ReportPath | Out-Null

$DateStamp = Get-Date -Format "yyyy-MM-dd_HH-mm"

Write-Host "`nCollecting device data..." -ForegroundColor Yellow

$Devices = Get-MgDeviceManagementManagedDevice -All

$Results = foreach ($Device in $Devices) {
    [PSCustomObject]@{
        DeviceName          = $Device.DeviceName
        OperatingSystem     = $Device.OperatingSystem
        OSVersion           = $Device.OsVersion
        ComplianceState     = $Device.ComplianceState
        ManagementAgent     = $Device.ManagementAgent
        Ownership           = $Device.ManagedDeviceOwnerType
        LastSyncDateTime     = $Device.LastSyncDateTime
        EntraDeviceId        = $Device.AzureAdDeviceId
    }
}

$CsvFile = "$ReportPath/Intune_Device_Compliance_Report_$DateStamp.csv"
$Results | Export-Csv -Path $CsvFile -NoTypeInformation

Write-Host "`nDEVICE COMPLIANCE REPORT COMPLETE" -ForegroundColor Green
Write-Host "Total Devices: $($Results.Count)" -ForegroundColor Cyan
Write-Host "Compliant Devices: $(($Results | Where-Object ComplianceState -eq 'compliant').Count)" -ForegroundColor Green
Write-Host "Non-Compliant Devices: $(($Results | Where-Object ComplianceState -eq 'noncompliant').Count)" -ForegroundColor Yellow
Write-Host "CSV Exported: $CsvFile" -ForegroundColor Green
