import-module ActiveDirectory 
cls
#Set the domain to search at the Server parameter. Run powershell as a user with privilieges in that domain to pass different credentials to the command. 
#Searchbase is the OU you want to search. By default the command will also search all subOU's. To change this behaviour, change the searchscope parameter. Possible values: Base, onelevel, subtree 
#Ignore the filter and properties parameters 

$Credential1 = Get-Credential
$Server1 = 'dc.domain.lan'
$SearchBase1 = 'OU=users,OU=YourOU3,DC=YourOU2,DC=YourOU1,DC=YourOUroot'
$DateTime = get-date  | select datetime

get-aduser -server $Server1 -SearchBase $SearchBase1 -Credential $Credential1 -Filter * -Properties samaccountname,GivenName,Surname,UserPrincipalName,Name,LastlogonTimeStamp | select-object samaccountname,GivenName,Surname,UserPrincipalName,Name,@{Name="LastLogon"; Expression={[DateTime]::FromFileTime($_.lastLogonTimestamp).ToString('yyyy-MM-dd_hh:mm:ss')}}  | export-csv "E:\scripts\CORP_DomainTools\BellinghamCorpUsers_$DateTime.csv" -NoTypeInformation