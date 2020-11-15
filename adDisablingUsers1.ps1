function MoveDisableAccounts($AccountoMove) {
        move-adobject -identity $AccountoMove "OU=Disabled Users,DC=Centric,DC=US"
      
     }
    $list = Import-CSV "C:\Users\c-rreyes\Desktop\Deact_test.csv"
     
     foreach($user in $list){
            
             $useraccount= Get-ADUser -Filter "employeeid -eq  '$($user.EmployeeID)'" -Properties * | Select-Object SamAccountName
             $useraccount= $useraccount.SamAccountName.ToString()
             
             if ($null -ne $useraccount){
             
                     Get-ADUser $useraccount | Disable-ADAccount
                     $account = get-aduser $useraccount | Select-Object distinguishedname 
                     MoveDisableAccounts( $account.distinguishedname.ToString() )
                     Get-ADUser $useraccount -Properties MemberOf | Select -Expand MemberOf | %{Remove-ADGroupMember -Confirm:$false  $_ -member "$useraccount"}
 
                     Get-ADUser $useraccount | Out-File -Append "C:\Users\c-rreyes\Desktop\temp.csv"  
                        
             }
             if ($null -eq $useraccount){ 
                 'User '+ $user.EmployeeID.ToString() + ' not found Centric US' | Out-File -Append "C:\Users\c-rreyes\Desktop\temp.csv"
             }
     }        