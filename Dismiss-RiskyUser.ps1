param(
    [Parameter(Mandatory)]
    [string]$UserPrincipalName
)

. "$PSScriptRoot/Graph-Common.ps1"
Ensure-GraphConnection

try {
    Import-Module Microsoft.Graph.Identity.SignIns -ErrorAction Stop

    $riskyUser = Get-MgRiskyUser -Filter "userPrincipalName eq '$UserPrincipalName'" -ErrorAction Stop

    if (-not $riskyUser) {
        Write-Error "Risky user not found by UPN: $UserPrincipalName"
        exit 1
    }

    Update-MgRiskyUser -RiskyUserId $riskyUser.Id -RiskState "dismissed" -ErrorAction Stop

    Write-Host "Dismissed risk for $UserPrincipalName" -ForegroundColor Green

} catch {
    Write-Error "Error dismissing risk: $($_.Exception.Message)"
    exit 1
}
