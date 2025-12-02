Azure AD / Entra ID – Individual Script Reference

This folder contains modular PowerShell scripts for managing Azure AD / Microsoft Entra ID using the Microsoft Graph PowerShell SDK.

All scripts are:

Cross-platform (Windows + Linux + macOS)

Designed to be run individually

Using a shared helper: Graph-Common.ps1

You can use them as building blocks for your own automations or integrate into pipelines.

1. Common Setup
1.1 Prerequisites

PowerShell 7 (pwsh) recommended

Windows: Install from GitHub (PowerShell releases)

Ubuntu:

sudo apt update
sudo apt install -y powershell


Microsoft Graph PowerShell module

In PowerShell (pwsh):

Install-Module Microsoft.Graph -Scope AllUsers
# or, if no admin rights:
Install-Module Microsoft.Graph -Scope CurrentUser

1.2 Graph-Common Helper

All scripts rely on:

Graph-Common.ps1 – Handles:

Importing Microsoft.Graph

Connecting to Microsoft Graph with required scopes

Make sure Graph-Common.ps1 lives in the same folder as the other scripts.

Each script uses:

. "$PSScriptRoot/Graph-Common.ps1"
Ensure-GraphConnection


You don’t need to call Connect-MgGraph manually — it’s handled for you.

1.3 How to Run a Script

Windows:

cd path\to\scripts
pwsh .\ScriptName.ps1 -Param1 value -Param2 value


Linux (Ubuntu):

cd /path/to/scripts
pwsh ./ScriptName.ps1 -Param1 value -Param2 value


(You don’t need chmod +x unless you want to run them as executables.)

2. Basic Scripts
2.1 New-AadUser.ps1

Description:
Creates a new Azure AD user with a temporary password and forces password change at next sign-in.

Key parameters:

-UserPrincipalName (e.g. jdoe@tenant.onmicrosoft.com)

-DisplayName (e.g. John Doe)

-Password (temporary password)

-MailNickname (optional; defaults to prefix of UPN)

Examples:

Windows:

pwsh .\New-AadUser.ps1 `
  -UserPrincipalName "jdoe@contoso.onmicrosoft.com" `
  -DisplayName "John Doe" `
  -Password "TempP@ssw0rd!"


Linux:

pwsh ./New-AadUser.ps1 \
  -UserPrincipalName "jdoe@contoso.onmicrosoft.com" \
  -DisplayName "John Doe" \
  -Password "TempP@ssw0rd!"

2.2 Reset-AadUserPassword.ps1

Description:
Resets a user’s password and forces password change on next sign-in.

Parameters:

-UserPrincipalName

-NewPassword

Example:

pwsh ./Reset-AadUserPassword.ps1 `
  -UserPrincipalName "jdoe@contoso.onmicrosoft.com" `
  -NewPassword "NewTempP@ssw0rd!"

2.3 Set-AadUserAccountStatus.ps1

Description:
Enables or disables a user account.

Parameters:

-UserPrincipalName

-Action – Enable or Disable

Examples:

pwsh ./Set-AadUserAccountStatus.ps1 -UserPrincipalName "jdoe@contoso.onmicrosoft.com" -Action Disable
pwsh ./Set-AadUserAccountStatus.ps1 -UserPrincipalName "jdoe@contoso.onmicrosoft.com" -Action Enable

2.4 New-AadGroup.ps1

Description:
Creates a security group (non-mail-enabled).

Parameters:

-DisplayName

-Description (optional)

-MailNickname (optional; auto-generated if omitted)

Example:

pwsh ./New-AadGroup.ps1 `
  -DisplayName "IT Support" `
  -Description "IT Support Staff"

2.5 Add-AadUserToGroup.ps1

Description:
Adds a user to a security group by user UPN and group display name.

Parameters:

-UserPrincipalName

-GroupDisplayName

Example:

pwsh ./Add-AadUserToGroup.ps1 `
  -UserPrincipalName "jdoe@contoso.onmicrosoft.com" `
  -GroupDisplayName "IT Support"

2.6 Add-AadLicense.ps1

Description:
Assigns a license (SKU) to a user.

Parameters:

-UserPrincipalName

-SkuPartNumber (e.g. ENTERPRISEPACK, BUSINESS_PREMIUM)

You can list your SKUs with:

Get-MgSubscribedSku | Select-Object SkuId, SkuPartNumber


Example:

pwsh ./Add-AadLicense.ps1 `
  -UserPrincipalName "jdoe@contoso.onmicrosoft.com" `
  -SkuPartNumber "ENTERPRISEPACK"

2.7 Export-AadUsers.ps1

Description:
Exports all Azure AD users to a CSV file.

Parameter:

-OutputPath (optional; defaults to ./AzureAD-Users.csv)

Examples:

pwsh ./Export-AadUsers.ps1
pwsh ./Export-AadUsers.ps1 -OutputPath "C:\Reports\AzureAD-Users.csv"
# Linux
pwsh ./Export-AadUsers.ps1 -OutputPath "/home/you/reports/AzureAD-Users.csv"

3. Advanced Scripts
3.1 Get-CaPolicies.ps1

Description:
Lists Conditional Access policies with ID, name, and state.

Example:

pwsh ./Get-CaPolicies.ps1

3.2 New-CaSimpleMfaPolicy.ps1

Description:
Creates a simple Conditional Access policy that requires MFA for all users and apps, in ReportOnly mode.

Parameter:

-DisplayName – name of the policy

Example:

pwsh ./New-CaSimpleMfaPolicy.ps1 -DisplayName "Require MFA for All Users (ReportOnly)"

3.3 Set-CaPolicyState.ps1

Description:
Changes the state of a Conditional Access policy.

Parameters:

-DisplayName – exact policy name

-State – enabled, reportOnly, or disabled

Example:

pwsh ./Set-CaPolicyState.ps1 `
  -DisplayName "Require MFA for All Users (ReportOnly)" `
  -State enabled

3.4 Get-RiskyUsers.ps1

Description:
Lists Identity Protection risky users (UPN, risk level, risk state).

Example:

pwsh ./Get-RiskyUsers.ps1

3.5 Dismiss-RiskyUser.ps1

Description:
Sets a user’s risk state to dismissed after investigation.

Parameter:

-UserPrincipalName

Example:

pwsh ./Dismiss-RiskyUser.ps1 -UserPrincipalName "user@contoso.com"

3.6 New-AadDynamicGroup.ps1

Description:
Creates a dynamic security group with a custom membership rule.

Parameters:

-DisplayName

-MembershipRule (Graph membership rule expression)

-Description (optional)

Example:

pwsh ./New-AadDynamicGroup.ps1 `
  -DisplayName "IT Engineers" `
  -MembershipRule '(user.department -eq "IT") -and (user.jobTitle -contains "Engineer")' `
  -Description "Dynamic group for IT engineers"

3.7 Export-SignInLogs.ps1

Description:
Exports last 24 hours of sign-in logs to CSV.

Parameter:

-OutputPath (optional; defaults to ./SignInLogs-Last24Hours.csv)

Examples:

pwsh ./Export-SignInLogs.ps1
pwsh ./Export-SignInLogs.ps1 -OutputPath "C:\Reports\SignInLogs.csv"
pwsh ./Export-SignInLogs.ps1 -OutputPath "/home/you/azure/SignInLogs.csv"

3.8 Invite-GuestUser.ps1

Description:
Sends a B2B guest (external) invitation email.

Parameters:

-Email

-RedirectUrl (optional; default: https://portal.office.com)

Example:

pwsh ./Invite-GuestUser.ps1 -Email "external.user@example.com"
pwsh ./Invite-GuestUser.ps1 -Email "external.user@example.com" -RedirectUrl "https://myapps.microsoft.com"

3.9 Set-AppAssignmentRequired.ps1

Description:
Sets an Enterprise Application (Service Principal) to require user assignment.

Parameter:

-AppDisplayName – service principal display name (e.g. Salesforce)

Example:

pwsh ./Set-AppAssignmentRequired.ps1 -AppDisplayName "Salesforce"

3.10 Add-UserToEnterpriseApp.ps1

Description:
Assigns a user to an Enterprise App role (App Role Assignment).

Parameters:

-UserPrincipalName

-AppDisplayName – service principal name

-AppRoleValue – role value string (e.g. User)

You can inspect available roles with:

Get-MgServicePrincipal -Filter "displayName eq 'Salesforce'" | Select-Object -ExpandProperty AppRoles


Example:

pwsh ./Add-UserToEnterpriseApp.ps1 `
  -UserPrincipalName "jdoe@contoso.com" `
  -AppDisplayName "Salesforce" `
  -AppRoleValue "User"

4. Notes & Best Practices

Run scripts as an identity with appropriate Azure AD roles (Global Admin, Security Admin, CA Admin, etc.).

Test Conditional Access changes in ReportOnly mode before enabling.

Never hard-code real passwords in GitHub; use:

Read-Host -AsSecureString (and convert if needed)

Environment variables

Secret stores / key vaults

You can wrap these scripts into:

Your own toolkit (like AzureAd-Toolkit.ps1), or

CI/CD pipelines / automation jobs.
