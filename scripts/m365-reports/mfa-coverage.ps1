# RahatOS Progress Center
# MFA Coverage Report
# Author: Md Rahat Islam Anik

Write-Host "=======================================" -ForegroundColor Cyan
Write-Host " RAHATOS | MFA COVERAGE REPORT " -ForegroundColor Cyan
Write-Host "=======================================" -ForegroundColor Cyan

Connect-MgGraph -Scopes "Policy.Read.All","User.Read.All","Directory.Read.All"

$ReportPath = "$HOME/Documents/RahatOS-Progress-Center/reports/m365"
New-Item -ItemType Directory -Force -Path $ReportPath | Out-Null

$DateStamp = Get-Date -Format "yyyy-MM-dd_HH-mm"

Write-Host "`nCollecting MFA data..." -ForegroundColor Yellow

$Users = Get-MgUser -All

$Results = foreach ($User in $Users) {

    $Methods = Get-MgUserAuthenticationMethod -UserId $User.Id

    $MFAEnabled = if ($Methods.Count -gt 1) { "Enabled" } else { "Disabled" }

    [PSCustomObject]@{
        DisplayName       = $User.DisplayName
        UserPrincipalName = $User.UserPrincipalName
        MFAStatus         = $MFAEnabled
    }
}

$CsvFile = "$ReportPath/MFA_Coverage_Report_$DateStamp.csv"

$Results | Export-Csv -Path $CsvFile -NoTypeInformation

$EnabledCount = ($Results | Where-Object {$_.MFAStatus -eq "Enabled"}).Count
$DisabledCount = ($Results | Where-Object {$_.MFAStatus -eq "Disabled"}).Count

Write-Host "`n=======================================" -ForegroundColor Green
Write-Host " MFA REPORT COMPLETE " -ForegroundColor Green
Write-Host "=======================================" -ForegroundColor Green

Write-Host "MFA Enabled Users: $EnabledCount" -ForegroundColor Cyan
Write-Host "MFA Disabled Users: $DisabledCount" -ForegroundColor Yellow

Write-Host "`nCSV Exported: $CsvFile" -ForegroundColor Green