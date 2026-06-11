# Enterprise IT Security Operations Toolkit
# Phase 1 — Enterprise Operations Foundation
# Script: Security Group Membership Drift Check
# Author: Md Rahat Islam Anik
# Description: Audits security group membership health across the tenant —
#   identifies empty groups, groups with disabled member accounts, and
#   nested group structures. Exports a governance report for access review
#   and IAM hygiene workflows.

Write-Host "=================================================" -ForegroundColor Cyan
Write-Host " ENTERPRISE SECURITY OPS | GROUP DRIFT CHECK    " -ForegroundColor Cyan
Write-Host "=================================================" -ForegroundColor Cyan

Connect-MgGraph -Scopes "Group.Read.All","User.Read.All","Directory.Read.All"

$ReportPath = Join-Path $PSScriptRoot "../../phase-1-enterprise-operations-foundation/reports"
New-Item -ItemType Directory -Force -Path $ReportPath | Out-Null
$DateStamp = Get-Date -Format "yyyy-MM-dd_HH-mm"

Write-Host "`nCollecting security groups..." -ForegroundColor Yellow

$Groups = Get-MgGroup -All -Property DisplayName,Id,GroupTypes,SecurityEnabled,MailEnabled,Description,CreatedDateTime |
          Where-Object { $_.SecurityEnabled -eq $true }

Write-Host "Auditing membership for $($Groups.Count) security groups..." -ForegroundColor Yellow

$GroupResults   = [System.Collections.Generic.List[object]]::new()
$MemberResults  = [System.Collections.Generic.List[object]]::new()

foreach ($Group in $Groups) {
    $Members      = Get-MgGroupMember -GroupId $Group.Id -All
    $UserMembers  = $Members | Where-Object { $_.'@odata.type' -eq '#microsoft.graph.user' }
    $NestedGroups = $Members | Where-Object { $_.'@odata.type' -eq '#microsoft.graph.group' }

    $DisabledMembers = 0
    foreach ($Member in $UserMembers) {
        try {
            $User = Get-MgUser -UserId $Member.Id -Property AccountEnabled -ErrorAction Stop
            if (-not $User.AccountEnabled) { $DisabledMembers++ }

            $MemberResults.Add([PSCustomObject]@{
                GroupName         = $Group.DisplayName
                MemberDisplayName = $Member.AdditionalProperties["displayName"]
                MemberUPN         = $Member.AdditionalProperties["userPrincipalName"]
                MemberType        = "User"
                AccountEnabled    = $User.AccountEnabled
            })
        } catch { continue }
    }

    $DriftFlag = if ($Members.Count -eq 0) {
        "REVIEW — Empty Security Group"
    } elseif ($DisabledMembers -gt 0) {
        "REVIEW — Group Contains $DisabledMembers Disabled Member(s)"
    } elseif ($NestedGroups.Count -gt 0) {
        "INFO — Contains $($NestedGroups.Count) Nested Group(s)"
    } else {
        "OK"
    }

    $GroupResults.Add([PSCustomObject]@{
        GroupName      = $Group.DisplayName
        GroupId        = $Group.Id
        IsDynamic      = ($Group.GroupTypes -contains "DynamicMembership")
        TotalMembers   = $Members.Count
        UserMembers    = $UserMembers.Count
        NestedGroups   = $NestedGroups.Count
        DisabledMembers = $DisabledMembers
        CreatedDateTime = $Group.CreatedDateTime
        DriftFlag      = $DriftFlag
    })
}

$GroupCsv  = "$ReportPath/Security_Group_Drift_Summary_$DateStamp.csv"
$MemberCsv = "$ReportPath/Security_Group_Members_Detail_$DateStamp.csv"
$GroupResults  | Export-Csv -Path $GroupCsv  -NoTypeInformation
$MemberResults | Export-Csv -Path $MemberCsv -NoTypeInformation

$EmptyGroups    = ($GroupResults | Where-Object { $_.TotalMembers -eq 0 }).Count
$GroupsWithIssues = ($GroupResults | Where-Object { $_.DriftFlag -ne "OK" }).Count

Write-Host "`n=================================================" -ForegroundColor Green
Write-Host " SECURITY GROUP DRIFT CHECK COMPLETE            " -ForegroundColor Green
Write-Host "=================================================" -ForegroundColor Green
Write-Host "Total Security Groups  : $($GroupResults.Count)"  -ForegroundColor Cyan
Write-Host "Groups With Issues     : $GroupsWithIssues"       -ForegroundColor Yellow
Write-Host "Empty Groups           : $EmptyGroups"            -ForegroundColor Red
Write-Host "Total Members Logged   : $($MemberResults.Count)" -ForegroundColor Cyan
Write-Host "`nGroup Summary CSV : $GroupCsv"                  -ForegroundColor Green
Write-Host "Member Detail CSV : $MemberCsv"                   -ForegroundColor Green
