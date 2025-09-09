# M365 License Summary Export Script
# 
# DESCRIPTION:
#   Exports M365 license types with friendly names, owned counts, and usage counts
#   Shows both technical SKU names and plain English descriptions
#
# PREREQUISITES:
#   - Run PowerShell as Administrator
#   - Global Admin or Directory Reader permissions in M365
#   - Internet connection
#
# HOW TO RUN:
#   1. Save this script as Export-LicenseSummary.ps1
#   2. Right-click PowerShell and "Run as Administrator" 
#   3. Execute: .\Export-LicenseSummary.ps1
#   4. Sign in when prompted
#
# OUTPUT EXAMPLE:
#   Office 365 E3 (ENTERPRISEPACK): 85 used / 100 owned
#   Microsoft 365 E5 (ENTERPRISEPREMIUM): 42 used / 50 owned

# Install Microsoft Graph module if not already installed
if (-not (Get-Module -ListAvailable -Name Microsoft.Graph)) {
    Install-Module Microsoft.Graph -Force -AllowClobber
}

# Import the module
Import-Module Microsoft.Graph.Identity.DirectoryManagement
Import-Module Microsoft.Graph.Authentication

# Connect to Microsoft Graph
Connect-MgGraph -Scopes "Directory.Read.All"

# SKU to Friendly Name mapping (including your specific SKUs)
$skuMapping = @{
    # Standard Office/M365 Licenses
    "ENTERPRISEPACK" = "Office 365 E3"
    "ENTERPRISEPREMIUM" = "Microsoft 365 E5"
    "ENTERPRISEPACKLRG" = "Office 365 E3"
    "ENTERPRISEWITHSCAL" = "Office 365 E4"
    "STANDARDPACK" = "Office 365 E1"
    "STANDARDWOFFPACK" = "Office 365 E2"
    "M365_BUSINESS_PREMIUM" = "Microsoft 365 Business Premium"
    "M365_BUSINESS_STANDARD" = "Microsoft 365 Business Standard"
    "M365_BUSINESS_BASIC" = "Microsoft 365 Business Basic"
    "M365_F1_COMM" = "Microsoft 365 F1 Communications"
    "SPB" = "SharePoint Online Plan 1"
    
    # Project Licenses
    "PROJECTPREMIUM" = "Project Premium"
    "PROJECTESSENTIALS" = "Project Online Essentials"
    "PROJECTCLIENT" = "Project Online Desktop Client"
    "PROJECTONLINE_PLAN_1" = "Project Online Plan 1"
    "PROJECTONLINE_PLAN_2" = "Project Online Plan 2"
    
    # Visio Licenses
    "VISIOCLIENT" = "Visio Desktop App"
    "VISIO_CLIENT_SUBSCRIPTION" = "Visio Online Plan 2"
    "VISIOONLINE_PLAN1" = "Visio Online Plan 1"
    
    # Power Platform
    "FLOW_FREE" = "Power Automate Free"
    "PBI_PREMIUM_PER_USER" = "Power BI Premium Per User"
    "POWER_BI_PRO" = "Power BI Pro"
    "POWER_BI_STANDARD" = "Power BI Standard"
    "Power_Pages_vTrial_for_Makers" = "Power Pages Trial for Makers"
    
    # Teams/Communications
    "PHONESYSTEM_VIRTUALUSER" = "Phone System Virtual User"
    "MCOMEETADV" = "Audio Conferencing"
    "MCOSTANDARD" = "Skype for Business Online Plan 2"
    "MCOIMP" = "Skype for Business Online Plan 1"
    "TEAMS1" = "Microsoft Teams"
    "Microsoft_Teams_Calling_Plan_pay_as_you_go_(country_zone_1)" = "Teams Calling Plan Pay-as-you-go"
    
    # Azure AD
    "AAD_BASIC" = "Azure Active Directory Basic"
    "AAD_PREMIUM" = "Azure Active Directory Premium P1"
    "AAD_PREMIUM_P2" = "Azure Active Directory Premium P2"
    
    # Dynamics 365
    "DYN365_BUSCENTRAL_PREMIUM" = "Dynamics 365 Business Central Premium"
    "DYN365_ENTERPRISE_SALES" = "Dynamics 365 Sales Enterprise"
    "Dynamics_365_Business_Central_Partner_Sandbox" = "Dynamics 365 Business Central Partner Sandbox"
    "Dynamics_365_Operations_Application_Partner_Sandbox" = "Dynamics 365 Operations Partner Sandbox"
    
    # Copilot/AI
    "CCIBOTS_PRIVPREV_VIRAL" = "Copilot Studio Trial"
    
    # Surface/Hardware
    "CPC_E_8C_32GB_512GB" = "Surface Pro (8GB/512GB Configuration)"
    
    # Exchange
    "EXCHANGESTANDARD" = "Exchange Online Plan 1"
    "EXCHANGEENTERPRISE" = "Exchange Online Plan 2"
    "EXCHANGEDESKLESS" = "Exchange Online Kiosk"
}

# Get desktop path
$desktopPath = [System.Environment]::GetFolderPath('Desktop')
$outputFile = Join-Path $desktopPath "M365_License_Summary_$(Get-Date -Format 'yyyy-MM-dd_HH-mm-ss').txt"

# Get license information
Write-Host "Retrieving license summary..." -ForegroundColor Green

$licenses = Get-MgSubscribedSku

# Create output content
$output = @()
$output += "M365 License Summary with Ownership - Generated on $(Get-Date)"
$output += "=" * 70
$output += ""

foreach ($license in $licenses) {
    $friendlyName = $skuMapping[$license.SkuPartNumber]
    if (-not $friendlyName) {
        $friendlyName = $license.SkuPartNumber  # Use SKU name if no mapping found
    }
    
    $owned = $license.PrepaidUnits.Enabled
    $used = $license.ConsumedUnits
    
    if ($owned -gt 0 -or $used -gt 0) {  # Show if there are any owned or used licenses
        $output += "$friendlyName ($($license.SkuPartNumber)): $used used / $owned owned"
    }
}

$output += ""
$totalOwned = ($licenses | ForEach-Object { $_.PrepaidUnits.Enabled } | Measure-Object -Sum).Sum
$totalUsed = ($licenses | Measure-Object -Property ConsumedUnits -Sum).Sum
$output += "SUMMARY:"
$output += "Total licenses owned: $totalOwned"
$output += "Total licenses used: $totalUsed"
$output += "Total licenses available: $($totalOwned - $totalUsed)"

# Export to text file
$output | Out-File -FilePath $outputFile -Encoding UTF8

Write-Host "License summary exported to: $outputFile" -ForegroundColor Green
Write-Host "Total owned: $totalOwned | Used: $totalUsed | Available: $($totalOwned - $totalUsed)" -ForegroundColor Yellow

# Disconnect
Disconnect-MgGraph