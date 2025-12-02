param(
    [Parameter(Mandatory)]
    [string]$UserPrincipalName,

    [Parameter(Mandatory)]
    [string]$GroupDisplayName
)

. "$PSScriptRoot/Graph-Common.ps1"
Ensure-GraphConnection

try {
    $user = Get-MgUser -UserId $UserPrincipalName -ErrorAction Stop
} catch {
    Write-Error "User not found: $UserPrincipalName"
    exit 1
}

try {
    $group = Get-MgGroup -Filter "displayName eq '$GroupDisplayName'" -ErrorAction Stop
    if (-not $group) {
        Write-Error "Group not found: $GroupDisplayName"
        exit 1
    }
} catch {
    Write-Error "Error locating group: $($_.Exception.Message)"
    exit 1
}

try {
    New-MgGroupMemberByRef -GroupId $group.Id `
        -OdataId "https://graph.microsoft.com/v1.0/directoryObjects/$($user.Id)" `
        -ErrorAction Stop

    Write-Host "Added $($user.UserPrincipalName) to group '$($group.DisplayName)'" -ForegroundColor Green
} catch {
    if ($_.Exception.Message -like "*One or more added object references already exist*") {
        Write-Warning "User is already a member of this group."
    } else {
        Write-Error "Error adding user to group: $($_.Exception.Message)"
        exit 1
    }
}
