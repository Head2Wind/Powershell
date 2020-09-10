IMPORT-MODULE ActiveDirectory -ErrorAction SilentlyContinue

#Create an array to hold the User information
$Users = @()

ForEach ($name in (import-csv -path "C:\scripts\exportusersin.csv") )
{   $Filter = "givenName -like ""*$($name.FirstName)*"" -and sn -like ""$($name.lastname)"""

    #Get User information
    $Users += Get-AdUser -Filter $filter -Properties * | Select-Object GivenName,Surname,DisplayName,UserPrincipalName
}

$Users | Select GivenName,Surname,DisplayName,UserPrincipalName | Export-Csv c:\scripts\myUsers.csv -NoTypeInformation

$user = Get-AdUser -Filter $filter -Properties DisplayName -server $server1 -credential $myCredential | Select-Object GivenName,Surname,DisplayName,UserPrincipalName | Export-CSV c:\scripts\exportusersout.csv -NoTypeInformation