param
(   
    [Parameter(Mandatory=$true,position=0)]
    [String]$GroupName
)

import-module activedirectory

# optional, add a wild card..
# $groups = $groups + "*"

$Groups = Get-ADGroup -filter {Name -like $GroupName} | Select-Object Name

ForEach ($Group in $Groups)
   {write-host " "
    write-host "$($group.name)"
    write-host "----------------------------"

    Get-ADGroupMember -identity $($group.name) -recursive | Select-Object samaccountname

 }
write-host "Export Complete"