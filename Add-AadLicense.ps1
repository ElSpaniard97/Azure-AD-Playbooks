param(
    [Parameter(Mandatory)]
    [string]$UserPrincipalName,

    [Parameter(Mandatory)]
    [string]$SkuPartNumber  # e.g. ENTERPRISEPACK, BUSINESS_PREMIUM
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
    $sku = Get-MgSubscribedSku | Where-Object { $_.SkuPartNumber -eq $SkuPartNumber }
    if (-not $sku) {
        Write-Error "License SKU not found for SkuPartNumber: $SkuPartNumber"
        exit 1
    }
} catch {
    Write-Error "Error retrieving subscribed SKUs: $($_.Exception.Message)"
    exit 1
}

$addLicenses = @(
    @{
        SkuId         = $sku.SkuId
        DisabledPlans = @()  # Add plan GUIDs here to disable specific services if needed
    }
)

try {
    Set-MgUserLicense -UserId $user.Id `
        -AddLicenses $addLicenses `
        -RemoveLicenses @() `
        -ErrorAction Stop

    Write-Host "Assigned SKU $SkuPartNumber to $($user.UserPrincipalName)" -ForegroundColor Green
} catch {
    Write-Error "Error assigning license: $($_.Exception.Message)"
    exit 1
}
