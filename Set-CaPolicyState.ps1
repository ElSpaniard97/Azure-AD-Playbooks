param(
    [Parameter(Mandatory)]
    [string]$DisplayName,

    [Parameter(Mandatory)]
    [ValidateSet("enabled","reportOnly","disabled")]
    [string]$State
)

. "$PSScriptRoot/Graph-Common.ps1"
Ensure-GraphConnection

try {
    Import-Module Microsoft.Graph.Identity.SignIns -ErrorAction Stop

    $policy = Get-MgIdentityConditionalAccessPolicy -Filter "displayName eq '$DisplayName'" -ErrorAction Stop

    if (-not $policy) {
        Write-Error "Conditional Access policy not found: $DisplayName"
        exit 1
    }

    Update-MgIdentityConditionalAccessPolicy `
        -ConditionalAccessPolicyId $policy.Id `
        -State $State `
        -ErrorAction Stop

    Write-Host "Updated policy '$DisplayName' to state: $State" -ForegroundColor Green

} catch {
    Write-Error "Error updating Conditional Access policy: $($_.Exception.Message)"
    exit 1
}
