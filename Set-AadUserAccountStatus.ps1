param(
    [Parameter(Mandatory)]
    [string]$UserPrincipalName,

    [Parameter(Mandatory)]
    [ValidateSet("Enable","Disable")]
    [string]$Action
)

. "$PSScriptRoot/Graph-Common.ps1"
Ensure-GraphConnection

try {
    $user = Get-MgUser -UserId $UserPrincipalName -ErrorAction Stop
} catch {
    Write-Error "User not found: $UserPrincipalName"
    exit 1
}

$enabled = $true
if ($Action -eq "Disable") {
    $enabled = $false
}

try {
    Update-MgUser -UserId $user.Id -AccountEnabled:$enabled -ErrorAction Stop
    Write-Host "User $($user.UserPrincipalName) is now AccountEnabled=$enabled" -ForegroundColor Green
} catch {
    Write-Error "Error updating user status: $($_.Exception.Message)"
    exit 1
}
