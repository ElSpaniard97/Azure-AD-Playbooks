. "$PSScriptRoot/Graph-Common.ps1"
Ensure-GraphConnection

try {
    Import-Module Microsoft.Graph.Identity.SignIns -ErrorAction Stop

    $riskyUsers = Get-MgRiskyUser -ErrorAction Stop

    if (-not $riskyUsers) {
        Write-Host "No risky users found." -ForegroundColor Yellow
        exit 0
    }

    $riskyUsers |
        Select-Object UserDisplayName, UserPrincipalName, RiskLevel, RiskState |
        Format-Table -AutoSize

} catch {
    Write-Error "Error retrieving risky users: $($_.Exception.Message)"
    exit 1
}
