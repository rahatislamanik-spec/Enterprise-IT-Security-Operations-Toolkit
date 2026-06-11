# Enterprise IT Security Operations Toolkit
# Phase 1 — Enterprise Operations Foundation
# Script: MFA Enforcement Compliance Check
# Author: Md Rahat Islam Anik
# Description: Audits MFA registration status across all users using the
#   Microsoft Graph authentication methods API. Categorizes users by MFA
#   method (Authenticator app, phone, FIDO2, etc.), flags non-compliant
#   accounts, and exports a compliance report.

Write-Host "=================================================" -ForegroundColor Cyan
Write-Host " ENTERPRISE SECURITY OPS | MFA COMPLIANCE CHECK " -ForegroundColor Cyan
Write-Host "=================================================" -ForegroundColor Cyan

Connect-MgGraph -Scopes "Policy.Read.All","User.Read.All","UserAuthenticationMethod.Read.All","Directory.Read.All"

$ReportPath = Join-Path $PSScriptRoot "../../phase-1-enterprise-operations-foundation/reports"
New-Item -ItemType Directory -Force -Path $ReportPath | Out-Null
$DateStamp = Get-Date -Format "yyyy-MM-dd_HH-mm"

Write-Host "`nCollecting users..." -ForegroundColor Yellow
$Users = Get-MgUser -All -Property DisplayName,UserPrincipalName,AccountEnabled,UserType,Department,JobTitle |
         Where-Object { $_.UserType -eq "Member" -and $_.AccountEnabled -eq $true }

Write-Host "Checking MFA methods for $($Users.Count) member accounts..." -ForegroundColor Yellow

$Results = foreach ($User in $Users) {
    $Methods = Get-MgUserAuthenticationMethod -UserId $User.Id
    $MethodTypes = $Methods | ForEach-Object { $_.'@odata.type' -replace '#microsoft.graph.','' }

    $MfaMethodTypes  = $MethodTypes | Where-Object {
        $_ -in @(
            "microsoftAuthenticatorAuthenticationMethod",
            "phoneAuthenticationMethod",
            "fido2AuthenticationMethod",
            "windowsHelloForBusinessAuthenticationMethod",
            "softwareOathAuthenticationMethod"
        )
    }
    $HasMFA          = ($MfaMethodTypes.Count -gt 0)
    $HasAuthApp      = $MethodTypes -contains "microsoftAuthenticatorAuthenticationMethod"
    $HasPhone        = $MethodTypes -contains "phoneAuthenticationMethod"
    $HasFido2        = $MethodTypes -contains "fido2AuthenticationMethod"
    $HasWindowsHello = $MethodTypes -contains "windowsHelloForBusinessAuthenticationMethod"
    $HasPasswordless = $HasFido2 -or $HasWindowsHello
    $MethodCount     = $MfaMethodTypes.Count

    $ComplianceStatus = if (-not $HasMFA) { "NON-COMPLIANT — No MFA Registered" } else { "COMPLIANT" }

    [PSCustomObject]@{
        DisplayName       = $User.DisplayName
        UserPrincipalName = $User.UserPrincipalName
        Department        = $User.Department
        JobTitle          = $User.JobTitle
        MFARegistered     = $HasMFA
        MFAMethodCount    = $MethodCount
        AuthenticatorApp  = $HasAuthApp
        PhoneMFA          = $HasPhone
        FIDO2Key          = $HasFido2
        WindowsHello      = $HasWindowsHello
        PasswordlessReady = $HasPasswordless
        ComplianceStatus  = $ComplianceStatus
    }
}

$CsvFile = "$ReportPath/MFA_Enforcement_Check_$DateStamp.csv"
$Results | Export-Csv -Path $CsvFile -NoTypeInformation

$Compliant    = ($Results | Where-Object { $_.MFARegistered }).Count
$NonCompliant = ($Results | Where-Object { -not $_.MFARegistered }).Count
$Passwordless = ($Results | Where-Object { $_.PasswordlessReady }).Count
$CompliancePct = if ($Results.Count -gt 0) { [math]::Round(($Compliant / $Results.Count) * 100, 1) } else { 0 }

Write-Host "`n=================================================" -ForegroundColor Green
Write-Host " MFA COMPLIANCE CHECK COMPLETE                  " -ForegroundColor Green
Write-Host "=================================================" -ForegroundColor Green
Write-Host "Total Members Checked  : $($Results.Count)"  -ForegroundColor Cyan
Write-Host "MFA Compliant          : $Compliant ($CompliancePct%)" -ForegroundColor Green
Write-Host "Non-Compliant (No MFA) : $NonCompliant"       -ForegroundColor Red
Write-Host "Passwordless-Ready     : $Passwordless"        -ForegroundColor Cyan
Write-Host "`nCSV Exported: $CsvFile"                     -ForegroundColor Green
