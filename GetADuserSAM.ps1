Foreach($Name in $Names) 
{ 
    $Name = $Name.Replace(" ","") -split "," 
    $FirstName = $Name[0].Trim() 
    $LastName = $Name[1].Trim() 
    $UserName = $FirstName + " " + $LastName 
    #Retrieve the ad users based on previous two variables. 
    $SamAccountName = Get-ADUser -Filter{ Surname -eq $LastName -and GivenName -eq $FirstName}|` 
    Select -ExpandProperty SamAccountName 
     
    If($SamAccountName -eq $null) 
    { 
        $SamAccountName = "NotFound" 
    } 
  
    #Output the result 
    New-Object -TypeName PSObject -Property @{DisplayName = $UserName 
                                              SamAccountName = $SamAccountName 
                                             } 
         
}