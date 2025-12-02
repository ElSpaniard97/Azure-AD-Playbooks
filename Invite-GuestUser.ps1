param(
    [Parameter(Mandatory)]
    [string]$Email,

    [string]$RedirectUrl = "https://portal.office.com"
)

. "$PSScriptRoot/Graph-Common.ps1"
Ensure-GraphConnection

try {
    Import-Module Microsoft.Graph.Identity.SignIns -ErrorAction Stop

    $body = @{
        invitedUserEmailAddress = $Email
        inviteRedirectUrl       = $RedirectUrl
        sendInvitationMessage   = $true
    }

    $invite = New-MgInvitation -BodyParameter $body -ErrorAction Stop

    Write-Host "Invitation sent to: $($invite.InvitedUserEmailAddress)" -ForegroundColor Green
    Write-Host "Invite status: $($invite.Status)" -ForegroundColor Gray

} catch {
    Write-Error "Error sending guest invitation: $($_.Exception.Message)"
    exit 1
}
