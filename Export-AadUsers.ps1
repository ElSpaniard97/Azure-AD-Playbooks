param(
    [string]$OutputPath = "$PSScriptRoot/AzureAD-Users.csv"
)

. "$PSScriptRoot/Graph-Common.ps1"
Ensure-GraphConnection

try {
    $users = Get-MgUser -All -Property "id,displayName,mail,userPrincipalName,accountEnabled" -ErrorAction Stop
} catch {
    Write-Error "Error retrieving users: $($_.Exception.Message)"
    exit 1
}

if (-not $users) {
    Write-Warning "No users returned."
    exit 0
}

try {
    $users |
        Select-Object DisplayName, UserPrincipalName, Mail, AccountEnabled, Id |
        Export-Csv -Path $OutputPath -NoTypeInformation

    Write-Host "Exported $(($users | Measure-Object).Count) users to $OutputPath" -ForegroundColor Green
} catch {
    Write-Error "Error exporting CSV: $($_.Exception.Message)"
    exit 1
}
