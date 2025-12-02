param(
    [Parameter(Mandatory)]
    [string]$UserPrincipalName,

    [Parameter(Mandatory)]
    [string]$NewPassword
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
    Update-MgUser -UserId $user.Id -PasswordProfile @{
        ForceChangePasswordNextSignIn = $true
        Password = $NewPassword
    } -ErrorAction Stop

    Write-Host "Password reset successfully for $($user.UserPrincipalName)" -ForegroundColor Green
} catch {
    Write-Error "Error resetting password: $($_.Exception.Message)"
    exit 1
}
