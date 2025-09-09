# M365 License Summary Export Script

A PowerShell script that exports Microsoft 365 license information to a text file on your desktop, showing both friendly names and technical SKU identifiers along with usage and ownership counts.

## What This Script Does

- **Connects** to your Microsoft 365 tenant via Microsoft Graph API
- **Retrieves** all subscribed license types (SKUs) and their usage statistics  
- **Translates** technical SKU names to user-friendly descriptions
- **Shows** both used and owned license counts for each type
- **Exports** everything to a timestamped text file on your desktop
- **Provides** summary totals at the bottom

## Prerequisites

### Permissions Required
- **Global Administrator** or **Directory Reader** role in Microsoft 365
- **Application.Read.All** and **Directory.Read.All** Microsoft Graph permissions

### System Requirements
- **Windows PowerShell 5.1** or **PowerShell 7+**
- **Internet connection** for Microsoft Graph API calls
- **Administrator privileges** to install PowerShell modules

## Installation & Setup

### 1. Download the Script
Save the PowerShell script as `Export-LicenseSummary.ps1` on your computer.

### 2. Prepare PowerShell Environment
1. **Right-click** on PowerShell and select **"Run as Administrator"**
2. **Set execution policy** (if needed):
   ```powershell
   Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
   ```

## How to Run

### Step-by-Step Instructions
1. **Open PowerShell as Administrator**
2. **Navigate** to where you saved the script:
   ```powershell
   cd C:\Path\To\Your\Script
   ```
3. **Execute the script**:
   ```powershell
   .\Export-LicenseSummary.ps1
   ```
4. **Sign in** when prompted with your Microsoft 365 admin credentials
5. **Wait** for the script to complete (usually 10-30 seconds)
6. **Check your desktop** for the output file

### First Run Notes
- The script will automatically install the Microsoft Graph PowerShell module if not present
- Installation may take a few minutes on first run
- You'll be prompted to sign in through your web browser

## Output Format

### File Location
The script creates a file on your desktop named:
```
M365_License_Summary_YYYY-MM-DD_HH-MM-SS.txt
```

### Sample Output
```
M365 License Summary with Ownership - Generated on 9/9/2025 2:15:32 PM
======================================================================

Visio Desktop App (VISIOCLIENT): 5 used / 10 owned
Project Premium (PROJECTPREMIUM): 5 used / 8 owned
Power BI Premium Per User (PBI_PREMIUM_PER_USER): 6 used / 15 owned
Power Automate Free (FLOW_FREE): 6 used / 999999 owned
Audio Conferencing (MCOMEETADV): 5 used / 10 owned
Microsoft 365 F1 Communications (M365_F1_COMM): 1 used / 5 owned
Dynamics 365 Sales Enterprise (DYN365_ENTERPRISE_SALES): 2 used / 3 owned

SUMMARY:
Total licenses owned: 999065
Total licenses used: 50
Total licenses available: 999015
```

## Understanding the Results

### License Format
Each license shows: `Friendly Name (SKU_CODE): X used / Y owned`

- **Friendly Name**: Plain English description of the license
- **SKU_CODE**: Microsoft's technical identifier  
- **X used**: Number of licenses currently assigned to users
- **Y owned**: Total number of licenses purchased/available

### Special Cases
- **Free licenses** may show very high "owned" numbers (like 999999)
- **Trial licenses** will have "Trial" in the friendly name
- **Partner/Sandbox** licenses are typically for development/testing

## Common License Types Explained

| Friendly Name | What It Includes |
|---------------|------------------|
| **Office 365 E3** | Word, Excel, PowerPoint, Outlook, Teams, SharePoint |
| **Microsoft 365 E5** | All E3 features + advanced security, analytics, voice |
| **Power BI Premium Per User** | Advanced Power BI analytics and sharing |
| **Project Premium** | Full Project Online with desktop app |
| **Visio Desktop App** | Visio diagramming software |
| **Teams Calling Plan** | Phone system capabilities for Teams |
| **Dynamics 365 Sales** | CRM sales management tools |

## Troubleshooting

### Common Issues

**"Execution Policy" Error**
```powershell
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
```

**"Module Not Found" Error**
- Run PowerShell as Administrator
- The script will auto-install required modules

**"Access Denied" or "Insufficient Privileges"**
- Verify you have Global Admin or Directory Reader permissions
- Try signing in with a different admin account

**"Connect-MgGraph" Fails**
- Check internet connection
- Verify your admin account isn't locked or has MFA issues
- Try clearing browser cache and cookies

**Missing License Names**
- Some licenses may show technical SKU names instead of friendly names
- This happens with newer or less common license types
- The script will still show accurate counts

### Getting Help

**Check Module Installation:**
```powershell
Get-Module -ListAvailable Microsoft.Graph*
```

**Verify Permissions:**
```powershell
Get-MgContext
```

**Manual Module Installation:**
```powershell
Install-Module Microsoft.Graph -Force -AllowClobber
```

## Customization

### Adding New License Mappings
If you encounter SKU codes without friendly names, you can add them to the `$skuMapping` hashtable in the script:

```powershell
"YOUR_SKU_CODE" = "Your Friendly Name Here"
```

### Changing Output Location
Modify this line to change where the file is saved:
```powershell
$desktopPath = [System.Environment]::GetFolderPath('Desktop')
```

### Filtering Results
To only show specific license types, add filtering logic after getting the licenses:
```powershell
$licenses = $licenses | Where-Object { $_.SkuPartNumber -like "*ENTERPRISE*" }
```

## Security Notes

- The script only **reads** license information - it cannot modify licenses
- Authentication uses Microsoft's secure OAuth2 flow
- No passwords or credentials are stored in the script
- The connection is automatically disconnected when complete

## Version History

- **v1.0**: Initial release with basic license export
- **v2.0**: Added friendly name mappings and ownership counts
- **v3.0**: Expanded SKU mappings based on common enterprise licenses

## Support

For script issues:
- Check the troubleshooting section above
- Verify prerequisites are met
- Ensure you have the required Microsoft 365 permissions

For Microsoft 365 licensing questions:
- Contact your Microsoft 365 administrator
- Visit the Microsoft 365 Admin Center
- Consult Microsoft's official documentation