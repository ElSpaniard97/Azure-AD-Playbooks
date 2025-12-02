param(
    [Parameter(Mandatory)]
    [string]$UserPrincipalName,

    [Parameter(Mandatory)]
    [string]$AppDisplayName,

    [Parameter(Mandatory)]
    [string]$AppRoleValue   # e.g. "User", depends on the app's roles
)

. "$PSScriptRoot/Graph-Common.ps1"
Ensure-GraphConnection

try {
    Import-Module Microsoft.Graph.Applications -ErrorAction Stop

    $user = Get-MgUser -UserId $UserPrincipalName -ErrorAction Stop

    $sp = Get-MgServicePrincipal -Filter "displayName eq '$AppDisplayName'" -ErrorAction Stop
    if (-not $sp) {
        Write-Error "Service principal not found: $AppDisplayName"
        exit 1
    }

    $role = $sp.AppRoles | Where-Object { $_.Value -eq $AppRoleValue -and $_.IsEnabled }
    if (-not $role) {
        Write-Error "App role with value '$AppRoleValue' not found or not enabled on '$AppDisplayName'."
        exit 1
    }

    New-MgServicePrincipalAppRoleAssignedTo -ServicePrincipalId $sp.Id -BodyParameter @{
        principalId = $user.Id
        resourceId  = $sp.Id
        appRoleId   = $role.Id
    } -ErrorAction Stop

    Write-Host "Assigned '$AppRoleValue' role on '$AppDisplayName' to $UserPrincipalName" -ForegroundColor Green

} catch {
    if ($_.Exception.Message -like "*Principal already has an app role assignment*") {
        Write-Warning "User already has that role on this app."
    } else {
        Write-Error "Error assigning user to enterprise app: $($_.Exception.Message)"
        exit 1
    }
}
