param(
    [Parameter(Mandatory)]
    [string]$UserPrincipalName,

    [Parameter(Mandatory)]
    [string]$DisplayName,

    [Parameter(Mandatory)]
    [string]$Password,

    [string]$MailNickname
)

. "$PSScriptRoot/Graph-Common.ps1"
Ensure-GraphConnection

if (-not $MailNickname -or [string]::IsNullOrWhiteSpace($MailNickname)) {
    $MailNickname = ($UserPrincipalName.Split("@")[0])
}

try {
    $user = New-MgUser -AccountEnabled $true `
        -DisplayName $DisplayName `
        -MailNickname $MailNickname `
        -UserPrincipalName $UserPrincipalName `
        -PasswordProfile @{
            ForceChangePasswordNextSignIn = $true
            Password = $Password
        } -ErrorAction Stop

    Write-Host "User created successfully:" -ForegroundColor Green
    $user | Select-Object Id, DisplayName, UserPrincipalName
} catch {
    Write-Error "Error creating user: $($_.Exception.Message)"
    exit 1
}
