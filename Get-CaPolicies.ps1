. "$PSScriptRoot/Graph-Common.ps1"
Ensure-GraphConnection

try {
    Import-Module Microsoft.Graph.Identity.SignIns -ErrorAction Stop

    $policies = Get-MgIdentityConditionalAccessPolicy -ErrorAction Stop

    if (-not $policies) {
        Write-Host "No Conditional Access policies found." -ForegroundColor Yellow
        exit 0
    }

    $policies | Select-Object Id, DisplayName, State |
        Format-Table -AutoSize

} catch {
    Write-Error "Error retrieving Conditional Access policies: $($_.Exception.Message)"
    exit 1
}
