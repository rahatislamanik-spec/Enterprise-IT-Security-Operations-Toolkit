# Enterprise IT Security Operations Toolkit
# MFA Coverage Report
# Author: Md Rahat Islam Anik

Write-Host "=======================================" -ForegroundColor Cyan
Write-Host " ENTERPRISE SECURITY OPS | MFA COVERAGE REPORT " -ForegroundColor Cyan
Write-Host "=======================================" -ForegroundColor Cyan

Connect-MgGraph -Scopes "User.Read.All","UserAuthenticationMethod.Read.All"

$ReportPath = Join-Path $PSScriptRoot "../../phase-1-enterprise-operations-foundation/reports"
New-Item -ItemType Directory -Force -Path $ReportPath | Out-Null

$DateStamp = Get-Date -Format "yyyy-MM-dd_HH-mm"

Write-Host "`nCollecting MFA data..." -ForegroundColor Yellow

$Users = Get-MgUser -All

$Results = foreach ($User in $Users) {

    $Methods = Get-MgUserAuthenticationMethod -UserId $User.Id
    $MethodTypes = $Methods | ForEach-Object { $_.'@odata.type' -replace '#microsoft.graph.','' }
    $RegisteredMfaTypes = $MethodTypes | Where-Object {
        $_ -in @(
            "microsoftAuthenticatorAuthenticationMethod",
            "phoneAuthenticationMethod",
            "fido2AuthenticationMethod",
            "windowsHelloForBusinessAuthenticationMethod",
            "softwareOathAuthenticationMethod"
        )
    }
    $MFAEnabled = if ($RegisteredMfaTypes.Count -gt 0) { "Registered" } else { "Not Registered" }

    [PSCustomObject]@{
        DisplayName       = $User.DisplayName
        UserPrincipalName = $User.UserPrincipalName
        MFARegistrationStatus = $MFAEnabled
        RegisteredMethods     = ($RegisteredMfaTypes -join "; ")
    }
}

$CsvFile = "$ReportPath/MFA_Coverage_Report_$DateStamp.csv"

$Results | Export-Csv -Path $CsvFile -NoTypeInformation

$EnabledCount = ($Results | Where-Object {$_.MFARegistrationStatus -eq "Registered"}).Count
$DisabledCount = ($Results | Where-Object {$_.MFARegistrationStatus -eq "Not Registered"}).Count

Write-Host "`n=======================================" -ForegroundColor Green
Write-Host " MFA REPORT COMPLETE " -ForegroundColor Green
Write-Host "=======================================" -ForegroundColor Green

Write-Host "Users with an MFA-capable method registered: $EnabledCount" -ForegroundColor Cyan
Write-Host "Users without an MFA-capable method registered: $DisabledCount" -ForegroundColor Yellow

Write-Host "`nCSV Exported: $CsvFile" -ForegroundColor Green
