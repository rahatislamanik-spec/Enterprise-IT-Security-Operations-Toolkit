# RahatOS Progress Center
# Microsoft 365 Admin Role Audit Report
# Author: Md Rahat Islam Anik

Write-Host "=======================================" -ForegroundColor Cyan
Write-Host " RAHATOS | ADMIN ROLE AUDIT REPORT " -ForegroundColor Cyan
Write-Host "=======================================" -ForegroundColor Cyan

Connect-MgGraph -Scopes "RoleManagement.Read.Directory","Directory.Read.All","User.Read.All"

$ReportPath = "$HOME/Documents/RahatOS-Progress-Center/reports/m365"
New-Item -ItemType Directory -Force -Path $ReportPath | Out-Null

$DateStamp = Get-Date -Format "yyyy-MM-dd_HH-mm"

Write-Host "`nCollecting admin role assignments..." -ForegroundColor Yellow

$Roles = Get-MgDirectoryRole

$Results = foreach ($Role in $Roles) {
    $Members = Get-MgDirectoryRoleMember -DirectoryRoleId $Role.Id

    foreach ($Member in $Members) {
        $User = Get-MgUser -UserId $Member.Id -ErrorAction SilentlyContinue

        [PSCustomObject]@{
            RoleName          = $Role.DisplayName
            DisplayName       = $User.DisplayName
            UserPrincipalName = $User.UserPrincipalName
            UserId            = $Member.Id
        }
    }
}

$CsvFile = "$ReportPath/Admin_Role_Audit_Report_$DateStamp.csv"

$Results | Export-Csv -Path $CsvFile -NoTypeInformation

Write-Host "`n=======================================" -ForegroundColor Green
Write-Host " ADMIN ROLE AUDIT COMPLETE " -ForegroundColor Green
Write-Host "=======================================" -ForegroundColor Green

Write-Host "Total Role Assignments: $($Results.Count)" -ForegroundColor Cyan
Write-Host "CSV Exported: $CsvFile" -ForegroundColor Green