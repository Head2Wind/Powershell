# Gets time stamps for all computers in the domain that have NOT logged in after specified number of days stated in 'DaysInactive' variable 
# Mod by Ken 2013-12-9 
import-module activedirectory  
$domain = "enter.domain.name.root"  
$DaysInactive = 95  
$time = (Get-Date).Adddays(-($DaysInactive)) 
  
# Get all AD computers with lastLogonTimestamp less than our time 
Get-ADComputer -Filter {LastLogonTimeStamp -lt $time} -Properties LastLogonTimeStamp | 
  
# Output hostname and lastLogonTimestamp into CSV 
select-object Name,@{Name="Stamp"; Expression={[DateTime]::FromFileTime($_.lastLogonTimestamp)}} | export-csv -path c:\scripts\oldcomputers.csv -notypeinformation