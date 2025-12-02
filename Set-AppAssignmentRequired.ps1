param(
    [Parameter(Mandatory)]
    [string]$AppDisplayName   # e.g. "Salesforce"
)

. "$PSScriptRoot/Graph-Common.ps1"
Ensure-GraphConnection

try {
    Import-Module Microsoft.Graph.Applications -ErrorAction Stop

    $sp = Get-MgServicePrincipal -Filter "displayName eq '$AppDisplayName'" -ErrorAction Stop

    if (-not $sp) {
        Write-Error "Service principal not found: $AppDisplayName"
        exit 1
    }

    Update-MgServicePrincipal -ServicePrincipalId $sp.Id `
        -AppRoleAssignmentRequired:$true `
        -ErrorAction Stop

    Write-Host "App '$AppDisplayName' now requires user assignment." -ForegroundColor Green

} catch {
    Write-Error "Error updating service principal: $($_.Exception.Message)"
    exit 1
}
