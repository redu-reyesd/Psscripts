$user_accounts = Import-Csv -Path "C:\Users\lmontealegre\Downloads\HL Roster for IT.csv"

foreach($user in $user_accounts){

    $listofUsers  =  Get-ADUser -Filter "EmployeeID -eq  '$($user.employeeid.tostring())'"  -Properties * | Select-Object mail
    #gets String value SamAccountName
    $listofUsers += $userccount.SamAccountName.tostring()

}
$listofUsers | Export-Csv "c:\temp\listofUser.csv"



ForEach ($user in $listofUsers){
    
    $email = $user.mail
    $userUPN="$email"
    $licensePlanList = Get-AzureADSubscribedSku
    $userList = Get-AzureADUser -ObjectID $userUPN | Select -ExpandProperty AssignedLicenses | Select SkuID

    if($userList.Count -ne 0) {
        
        if($userList -is [array]) {
               
                for ($i=0; $i -lt $userList.Count; $i++) {
            
                        #creates an object type license to get user license and parse it to $licenses variable
                        $license = New-Object -TypeName Microsoft.Open.AzureAD.Model.AssignedLicense
                        #creates an object type license to store user's lincen to be remove
                        $licenses = New-Object -TypeName Microsoft.Open.AzureAD.Model.AssignedLicenses
                
                        $license.SkuId = $userList[$i].SkuId # itarate through each user license
                        $licenses.AddLicenses = $license  #gets every license user has
                
                        #Set-AzureADUserLicense -ObjectId $userUPN -AssignedLicenses $licenses
                        #$Licenses.AddLicenses = @()
                
                        #assing licenceses to remove to the variable Licenses.
                        $Licenses.RemoveLicenses = (Get-AzureADSubscribedSku | Where-Object -Property SkuID -Value $userList[$i].SkuId -EQ).SkuID
                        #license skuid id previously assing to the vararuable licenses gets remove from user account by using the set function
                        Set-AzureADUserLicense -ObjectId $userUPN -AssignedLicenses $licenses

                } #end For
        }#End If
        else {
                    #creates an object type license to get user license and parse it to $licenses variable
                    $license = New-Object -TypeName Microsoft.Open.AzureAD.Model.AssignedLicense
                    #creates an object type license to store user's lincen to be remove
                    $licenses = New-Object -TypeName Microsoft.Open.AzureAD.Model.AssignedLicenses


                    $license.SkuId = $userList.SkuId #grabs user lincense and 
                    $licenses.AddLicenses = $license
                    Set-AzureADUserLicense -ObjectId $userUPN -AssignedLicenses $licenses
                    $Licenses.AddLicenses = @()
                    $Licenses.RemoveLicenses = (Get-AzureADSubscribedSku | Where-Object -Property SkuID -Value $userList.SkuId -EQ).SkuID
                    Set-AzureADUserLicense -ObjectId $userUPN -AssignedLicenses $licenses
        } #End Else


    } #End  if($userList.Count -ne 0)
    
     
    
}  #End ForEach


### Script tomado de https://docs.microsoft.com/en-us/microsoft-365/enterprise/remove-licenses-from-user-accounts-with-microsoft-365-powershell?view=o365-worldwide#:~:text=Use%20the%20Azure%20Active%20Directory%20PowerShell%20for%20Graph%20module,-First%2C%20connect%20to&text=Next%2C%20get%20the%20sign%2Din,characters%2C%20and%20run%20these%20commands.
### Check site for more details, few lines has been added to meet current needs
