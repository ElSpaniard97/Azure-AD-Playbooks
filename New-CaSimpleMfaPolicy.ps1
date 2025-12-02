param(
    [Parameter(Mandatory)]
    [string]$DisplayName
)

. "$PSScriptRoot/Graph-Common.ps1"
Ensure-GraphConnection

try {
    Import-Module Microsoft.Graph.Identity.SignIns -ErrorAction Stop

    $body = @{
        displayName = $DisplayName
        state       = "reportOnly"   # safer default; you can later enable it
        conditions  = @{
            users = @{
                includeUsers = @("All")
                excludeUsers = @()    # you should exclude break-glass accounts manually later
            }
            applications = @{
                includeApplications = @("All")
                excludeApplications = @()
            }
            clientAppTypes = @("all")
        }
        grantControls = @{
            operator        = "AND"
            builtInControls = @("mfa")
        }
    }

    $policy = New-MgIdentityConditionalAccessPolicy -BodyParameter $body -ErrorAction Stop

    Write-Host "Created Conditional Access policy:" -ForegroundColor Green
    $policy | Select-Object Id, DisplayName, State

} catch {
    Write-Error "Error creating Conditional Access policy: $($_.Exception.Message)"
    exit 1
}
