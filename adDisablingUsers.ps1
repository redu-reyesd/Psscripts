# Import AD Module
Import-Module ActiveDirectory
# Import the data from CSV file and assign it to variable
$user_accounts = Import-Csv -Path "C:\Users\lmontealegre\Downloads\HL Roster for IT.csv"
#Check if user exists within AD
foreach($user in $user_accounts){​​​​​
if ($user -ne ""){​​​​​
    
    $userccount  =  Get-ADUser -Filter "EmployeeID -eq  '$($user.employeeid.tostring())'"  -Properties * | Select-Object SamAccountName
    #gets String value SamAccountName
    $userccount = $userccount.SamAccountName.tostring()
    
    
    #Disable AdUser account
    Get-ADUser   $userccount |Disable-ADAccount

    #gets aduser identeity
    $user_location = get-aduser  $userccount | Select-Object distinguishedname -ExpandProperty distinguishedname -First 1
    move-adobject -identity "$user_location" "OU=Disabled Users,DC=Contoso,DC=com"
    
    #Set description to users
    Set-ADUser  $userccount -Description "Disabled per ticket #286337"
    
    #Remove all memberships
    Get-ADUser  $userccount -Properties MemberOf | Select -Expand MemberOf | ​​​​​%{Remove-ADGroupMember -Confirm:$false -verbose $_ -member "$userccount"}​​​​
    
    #Check user for report 
    $report += Get-ADUser  $userccount -Properties * | Select-Object office, manager, department, title
    $report += 'User ' +  $userccount + 'Deactivated on Centric US'
    $report += net user  $userccount /domain
    
}​​​​​else {​​​​​
    $not_found += 'User ' +$user+ 'not Found on Centric US'
}​​​​​$report += "`n"
}​​​​​
$report | export-csv -Path C:\temp\result.csv

