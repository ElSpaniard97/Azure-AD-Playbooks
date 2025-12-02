param(
    [string]$OutputPath = "$PSScriptRoot/SignInLogs-Last24Hours.csv"
)

. "$PSScriptRoot/Graph-Common.ps1"
Ensure-GraphConnection

try {
    Import-Module Microsoft.Graph.Reports -ErrorAction Stop

    $from   = (Get-Date).AddDays(-1).ToUniversalTime().ToString("o")
    $filter = "createdDateTime ge $from"

    $logs = Get-MgAuditLogSignIn -Filter $filter -All -ErrorAction Stop

    if (-not $logs) {
        Write-Host "No sign-in logs in the last 24 hours." -ForegroundColor Yellow
        exit 0
    }

    $logs |
        Select-Object UserDisplayName, UserPrincipalName, AppDisplayName,
                      IPAddress, CreatedDateTime, Status |
        Export-Csv -Path $OutputPath -NoTypeInformation

    Write-Host "Exported $($( $logs | Measure-Object ).Count) sign-ins to $OutputPath" -ForegroundColor Green

} catch {
    Write-Error "Error exporting sign-in logs: $($_.Exception.Message)"
    exit 1
}
