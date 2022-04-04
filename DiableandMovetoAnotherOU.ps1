foreach($user in Get-Content c:\list.csv) {
	
	Get-ADUser $user  | Disable-ADAccount
	$pathuser = Get-ADUser $user -Properties * | Select-Object DistinguishedName
	Move-ADObject $pathuser.DistinguishedName  "OU=Disabled Accounts,DC=dcunited,DC=com"
}