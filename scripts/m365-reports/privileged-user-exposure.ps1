# RahatOS Progress Center
# Privileged User Exposure Audit
# Tier 3 Security Operations Report

Write-Host "==========================================="
Write-Host " RAHATOS | PRIVILEGED USER EXPOSURE AUDIT "
Write-Host "==========================================="

Connect-MgGraph -Scopes "RoleManagement.Read.Directory","Directory.Read.All","User.Read.All"

$ReportPath = "$HOME/Documents/RahatOS-Progress-Center/reports/m365"
New-Item -ItemType Directory -Force -Path $ReportPath | Out-Null

$DateStamp = Get-Date -Format "yyyy-MM-dd_HH-mm"

Write-Host "`nCollecting privileged role assignments..." -ForegroundColor Yellow

$Roles = Get-MgDirectoryRole
$Results = @()

foreach ($Role in $Roles) {

    $Members = Get-MgDirectoryRoleMember -DirectoryRoleId $Role.Id

    foreach ($Member in $Members) {

        try {
            $User = Get-MgUser -UserId $Member.Id -Property DisplayName,UserPrincipalName,AccountEnabled,Department,JobTitle

            $RiskLevel = switch ($Role.DisplayName) {
                "Global Administrator" { "CRITICAL" }
                "Privileged Role Administrator" { "CRITICAL" }
                "Security Administrator" { "HIGH" }
                "Exchange Administrator" { "HIGH" }
                "SharePoint Administrator" { "MEDIUM" }
                default { "STANDARD" }
            }

            $Results += [PSCustomObject]@{
                RoleName          = $Role.DisplayName
                DisplayName       = $User.DisplayName
                UserPrincipalName = $User.UserPrincipalName
                Department        = $User.Department
                JobTitle          = $User.JobTitle
                AccountEnabled    = $User.AccountEnabled
                RiskLevel         = $RiskLevel
            }
        }
        catch {
            continue
        }
    }
}

$CsvFile = "$ReportPath/Privileged_User_Exposure_Audit_$DateStamp.csv"

$Results | Export-Csv -Path $CsvFile -NoTypeInformation

$CriticalAdmins = ($Results | Where-Object {$_.RiskLevel -eq "CRITICAL"}).Count
$HighRiskAdmins = ($Results | Where-Object {$_.RiskLevel -eq "HIGH"}).Count

Write-Host "`n===========================================" -ForegroundColor Green
Write-Host " PRIVILEGED USER EXPOSURE AUDIT COMPLETE " -ForegroundColor Green
Write-Host "===========================================" -ForegroundColor Green

Write-Host "Total Privileged Assignments: $($Results.Count)" -ForegroundColor Cyan
Write-Host "Critical Privileged Accounts: $CriticalAdmins" -ForegroundColor Red
Write-Host "High Risk Administrative Roles: $HighRiskAdmins" -ForegroundColor Yellow

Write-Host "`nCSV Exported: $CsvFile" -ForegroundColor Green