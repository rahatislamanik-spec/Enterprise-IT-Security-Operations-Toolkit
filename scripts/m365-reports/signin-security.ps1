# Enterprise IT Security Operations Toolkit
# Microsoft 365 Sign-In Security Report
# Author: Md Rahat Islam Anik

param (
    [ValidateRange(1, 30)]
    [int]$DaysBack = 7
)

Write-Host "=======================================" -ForegroundColor Cyan
Write-Host " ENTERPRISE SECURITY OPS | SIGN-IN SECURITY REPORT " -ForegroundColor Cyan
Write-Host "=======================================" -ForegroundColor Cyan

Connect-MgGraph -Scopes "AuditLog.Read.All","Directory.Read.All"

$ReportPath = Join-Path $PSScriptRoot "../../phase-1-enterprise-operations-foundation/reports"
New-Item -ItemType Directory -Force -Path $ReportPath | Out-Null

$DateStamp = Get-Date -Format "yyyy-MM-dd_HH-mm"

Write-Host "`nCollecting sign-in logs..." -ForegroundColor Yellow

$StartDate = (Get-Date).ToUniversalTime().AddDays(-$DaysBack).ToString("yyyy-MM-ddTHH:mm:ssZ")
$SignIns = Get-MgAuditLogSignIn -All -Filter "createdDateTime ge $StartDate"

$Results = foreach ($SignIn in $SignIns) {

    [PSCustomObject]@{
        User                = $SignIn.UserDisplayName
        UserPrincipalName   = $SignIn.UserPrincipalName
        App                 = $SignIn.AppDisplayName
        IPAddress           = $SignIn.IpAddress
        City                = $SignIn.Location.City
        Country             = $SignIn.Location.CountryOrRegion
        Status              = $SignIn.Status.ErrorCode
        ClientApp           = $SignIn.ClientAppUsed
        Browser             = $SignIn.DeviceDetail.Browser
        OperatingSystem     = $SignIn.DeviceDetail.OperatingSystem
        Timestamp           = $SignIn.CreatedDateTime
    }
}

$CsvFile = "$ReportPath/Signin_Security_Report_$DateStamp.csv"

$Results | Export-Csv -Path $CsvFile -NoTypeInformation

$FailedSignins = ($Results | Where-Object {$_.Status -ne 0}).Count
$SuccessfulSignins = ($Results | Where-Object {$_.Status -eq 0}).Count

Write-Host "`n=======================================" -ForegroundColor Green
Write-Host " SIGN-IN SECURITY REPORT COMPLETE " -ForegroundColor Green
Write-Host "=======================================" -ForegroundColor Green

Write-Host "Successful Sign-Ins: $SuccessfulSignins" -ForegroundColor Cyan
Write-Host "Failed Sign-Ins: $FailedSignins" -ForegroundColor Yellow
Write-Host "Review Window: Last $DaysBack day(s)" -ForegroundColor Cyan

Write-Host "`nCSV Exported: $CsvFile" -ForegroundColor Green
