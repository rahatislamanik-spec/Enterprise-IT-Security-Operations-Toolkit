Write-Host "======================================="
Write-Host " RAHATOS | CONDITIONAL ACCESS AUDIT "
Write-Host "======================================="

Connect-MgGraph -Scopes "Policy.Read.All","Directory.Read.All"

$ReportPath = "$HOME/Documents/RahatOS-Progress-Center/reports/m365"
New-Item -ItemType Directory -Force -Path $ReportPath | Out-Null

$DateStamp = Get-Date -Format "yyyy-MM-dd_HH-mm"

Write-Host "`nCollecting Conditional Access policies..." -ForegroundColor Yellow

$Policies = Get-MgIdentityConditionalAccessPolicy

$Results = foreach ($Policy in $Policies) {

    [PSCustomObject]@{
        PolicyName = $Policy.DisplayName
        State = $Policy.State
        CreatedDate = $Policy.CreatedDateTime
        ModifiedDate = $Policy.ModifiedDateTime
    }
}

$CsvFile = "$ReportPath/Conditional_Access_Audit_$DateStamp.csv"

$Results | Export-Csv -Path $CsvFile -NoTypeInformation

Write-Host "`n=======================================" -ForegroundColor Green
Write-Host " CONDITIONAL ACCESS AUDIT COMPLETE " -ForegroundColor Green
Write-Host "=======================================" -ForegroundColor Green

Write-Host "Policies Found: $($Results.Count)" -ForegroundColor Cyan
Write-Host "`nCSV Exported: $CsvFile" -ForegroundColor Green