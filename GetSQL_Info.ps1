cls
# Test to see if the SQLPS module is loaded, and if not, load it
if (-not(Get-Module -name 'SQLPS')) {
  if (Get-Module -ListAvailable | Where-Object {$_.Name -eq 'SQLPS' }) {
      Push-Location # The SQLPS module load changes location to the Provider, so save the current location
Import-Module -Name 'SQLPS' -DisableNameChecking
Pop-Location # Now go back to the original location
    }
  }
  $server = 'server.name.here'
  $svr = new-object ('Microsoft.SqlServer.Management.Smo.Server') $server
$svr | Get-Member
$svr | select Name, Edition, BuildNumber, Product, ProductLevel, Version, Processors, PhysicalMemory, DefaultFile, DefaultLog, MasterDBPath, MasterDBLogPath, BackupDirectory, ServiceAccount, RootDirectory | Out-File C:\Scripts\SQL_inventory\$server-Info.txt -width 120
$svr.Databases | select name | Format-Table | Out-File C:\Scripts\SQL_inventory\$server-DBs.txt -width 120