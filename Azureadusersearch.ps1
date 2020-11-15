
$temp1 = Get-Content "c:\temp\userlist.csv"
$userList = @()
$x=0

foreach($User in $temp1){
        $usertemp = Get-AzureADUser -SearchString $User
        if( $null -ne $usertemp){
            $userList += $usertemp.UserPrincipalName.tostring() #| Out-File -Append "c:\temp\userlis.csv"
            $x++ 
        }

}  ## this peace of code iterates through each value in the file
 