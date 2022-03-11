<#------------------------------------------------------
#LCS Export, Move, Vendor SFTP AUTOMATION
#Version 2
#Ken Nelson, ken.nelson@exptechnical.com
#2/18/2022
#REVmodDate: 3/10/2022
#------------------------------------------------------
#------------------------------------------------------
#Global Variables
#------------------------------------------------------
#>

#Critical information is contained in the 'VendorInfo.csv' file for each vendor, it resides in the 'Scripts' directory.
#--------------STATIC Environment Paths----------------------------------------------

$AutomationPath = "B:\Automation" #Root Directory automation package resides
$ScriptPath = "$AutomationPath\Scripts\PROD" #Directory script runs from
$VendorCredsPath = "$AutomationPath\Creds\$VendorName" #Directory credentials stored for each vendor, this is WIP (2/7/2022)
$SourceFolder = "E:\LCS\DATA" #Directory that the script will be searching and moving files from
$CoreFTP = "C:\Program Files\CoreFTP\coreftp.exe"
#$WINscpPath = "C:\Program Files (x86)\WinSCP" #Path for WINscp to function
#
#---------------------------Logging variables-----------------------------------------
$date=[datetime]::Today.ToString('MM-dd-yyyy')
$logfilepath="$AutomationPath\Logs\PROD\AutomationMover_$date.log"
#Import data
Import-Csv $ScriptPath\VendorInfo.csv | ForEach-Object {
#Data from CSV
	$VendorName = $_.VendorName
	$VendorFileName = $_.VendorFileName
    $VendorFileExt = $_.VendorFileExt
    $VendorDirRemoteInPath = $_.VendorDirRemoteInPath
    #Check vendor directories are present, intent is to read in the 'VendorInfo.csv' file and based upon the vendor name, check for existing directories, create if not present... Stick it here
    #Move files into ARCHIVE if older than 1 day for each vendor
    #Get-ChildItem -Path "$AutomationPath\Outbound\$VendorName" | where-object {$_.Name -like "$VendorFileName.$VendorFileExt" -AND $_.LastWriteTime -lt (get-date).AddDays(-1)} |  move-item -destination "$AutomationPath\Archive\$VendorName"
    Get-ChildItem -Path "$AutomationPath\Outbound\$VendorName" | where-object {$_.Name -like "$VendorFileName.$VendorFileExt"} |  move-item -destination "$AutomationPath\Archive\$VendorName" -Force
    Get-ChildItem -Path "$AutomationPath\Archive\$VendorName" | where-object {$_.Name -like "$VendorFileName.$VendorFileExt" -AND $_.LastWriteTime -lt (get-date).AddDays(-30)} |  Remove-Item
#::::::Go get the files from the Source and put them in Outbound for SFTP to pick up and PUT to vendor later::::::
    Get-ChildItem -Path $SourceFolder | Where-Object { $_.Name -like "$VendorFileName.$VendorFileExt" } | Move-Item -Destination $AutomationPath\Outbound\$VendorName | Out-File -FilePath $Logfilepath -Append -Encoding UTF8

#:::::::::: Start the SFTP file transfers for each vendor on the list
Start-Process -NoNewWindow -FilePath $CoreFTP -ArgumentList "-s", "-O", "-SSH","-site $VendorName","-u $AutomationPath\Outbound\$Vendorname\$VendorFileName","-p $VendorDirRemoteInPath","-log $AutomationPath\Logs\PROD\$VendorName+log.log"
}



