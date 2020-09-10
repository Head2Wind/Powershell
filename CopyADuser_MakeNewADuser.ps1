#Created by Ken Nelson
#version 1.0
####################
#do work begin
#
#get information
$source = Read-Host ‘What account should be copied? (username)’
$fn = Read-Host ‘New User First Name?’
$mn = Read-Host ‘New User Middle Name?’
$ln = Read-Host ‘New User Last Name?’
$pw = Read-Host ‘New User Password?’
$un = Read-Host ‘New User Username?’
$pc = (Get-ADUser $source).parentcontainer

#create account
Write-Host -foregroundcolor blue “Creating account….”
Get-ADUser $source |ForEach-Object { New-ADUser -ParentContainer “$pc” -Name “$ln, $dr$fn” -SamAccountName “$un” -userprincipalname “$un@UPN” -DisplayName “$ln, $dr$fn” -FirstName “$fn” -Initials “$mn” -LastName “$ln” -UserPassword “$pw” -office $_.office -phonenumber $_.phonenumber -Description $_.Description -Company $_.Company -LogonScript $_.LogonScript -Title $_.Title -Department $_.Department -Manager $_.Manager -Notes $_.Notes -import} |Out-Null
Write-Host -foregroundcolor blue “Account created.”

#copy user groups
Write-Host -foregroundcolor blue “Copying Member Of….”
(Get-ADUser $source).MemberOf | Add-ADGroupMember -Member “$un” |Out-Null
Write-Host -foregroundcolor blue “Groups copied.”

Remove-Variable [a..z]* -Scope Global
Remove-Variable [1..9]* -Scope Global
Write-Host -foregroundcolor green “Finished.”