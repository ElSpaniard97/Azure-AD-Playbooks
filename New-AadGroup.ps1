param(
    [Parameter(Mandatory)]
    [string]$DisplayName,

    [string]$Description = "",
    [string]$MailNickname
)

. "$PSScriptRoot/Graph-Common.ps1"
Ensure-GraphConnection

if (-not $MailNickname -or [string]::IsNullOrWhiteSpace($MailNickname)) {
    $MailNickname = $DisplayName.ToLower().Replace(" ","-")
}

try {
    $group = New-MgGroup -DisplayName $DisplayName `
        -Description $Description `
        -MailEnabled:$false `
        -MailNickname $MailNickname `
        -SecurityEnabled:$true `
        -ErrorAction Stop

    Write-Host "Group created successfully:" -ForegroundColor Green
    $group | Select-Object Id, DisplayName, Description
} catch {
    Write-Error "Error creating group: $($_.Exception.Message)"
    exit 1
}
