<#
.SYNOPSIS
  Common helper for Microsoft Graph scripts (works on Windows & Linux).

.DESCRIPTION
  - Checks that Microsoft.Graph module is installed
  - Imports the module
  - Ensures you are connected with the required scopes
#>

param(
    [string[]]$Scopes = @(
        "User.ReadWrite.All",
        "Group.ReadWrite.All",
        "Directory.ReadWrite.All",
        "RoleManagement.ReadWrite.Directory",
        "AuditLog.Read.All"
    )
)

# Ensure Microsoft.Graph module is present
if (-not (Get-Module -ListAvailable -Name Microsoft.Graph)) {
    Write-Error "Microsoft.Graph module not found. Install it with: Install-Module Microsoft.Graph"
    exit 1
}

Import-Module Microsoft.Graph -ErrorAction Stop

function Ensure-GraphConnection {
    try {
        $ctx = Get-MgContext -ErrorAction SilentlyContinue
    } catch {
        $ctx = $null
    }

    if (-not $ctx -or -not $ctx.Account) {
        Write-Host "Connecting to Microsoft Graph..." -ForegroundColor Cyan
        try {
            Connect-MgGraph -Scopes $Scopes -ErrorAction Stop
            Write-Host "Connected as $((Get-MgContext).Account)" -ForegroundColor Green
        } catch {
            Write-Error "Failed to connect to Microsoft Graph: $($_.Exception.Message)"
            exit 1
        }
    }
}
