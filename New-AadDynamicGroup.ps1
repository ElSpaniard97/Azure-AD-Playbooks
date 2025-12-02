param(
    [Parameter(Mandatory)]
    [string]$DisplayName,

    [Parameter(Mandatory)]
    [string]$MembershipRule,   # e.g. (user.department -eq "IT") -and (user.jobTitle -contains "Engineer")

    [string]$Description = ""
)

. "$PSScriptRoot/Graph-Common.ps1"
Ensure-GraphConnection

try {
    Import-Module Microsoft.Graph.Groups -ErrorAction Stop

    $mailNickname = $DisplayName.ToLower().Replace(" ","-")

    $group = New-MgGroup -DisplayName $DisplayName `
        -Description $Description `
        -MailEnabled:$false `
        -MailNickname $mailNickname `
        -SecurityEnabled:$true `
        -GroupTypes @("DynamicMembership") `
        -MembershipRule $MembershipRule `
        -MembershipRuleProcessingState "On" `
        -ErrorAction Stop

    Write-Host "Dynamic group created:" -ForegroundColor Green
    $group | Select-Object Id, DisplayName, MembershipRule, MembershipRuleProcessingState

} catch {
    Write-Error "Error creating dynamic group: $($_.Exception.Message)"
    exit 1
}
