if (-not (Get-Module ActiveDirectory)){    
 Import-Module ActiveDirectory -ErrorAction Stop

}

function changePassword {
$username = read-host 'Nome de usuario:'
$pass = ConvertTo-SecureString 'Sysmap*2021' -AsPlainText -Force
$adminCred = Get-Credential -Message  'Você precisar inserir as credenciais para desbloqueio da função de reset de senha.'
Set-ADAccountPassword $username -NewPassword $pass -PassThru -Credential $adminCred -Server SYSMAP.com.br
menu
}
#
function unlockAccount {
$username = read-host 'Nome de usuario:'
$adminCred = Get-Credential -Message  'Você precisar inserir as credenciais para desbloqueio da função de reset de senha.'
Enable-ADAccount $username -Server SYSMAP.com.br -Credential $adminCred
menu
}
#
function menu {
$stepChoice = read-host "
1. Reset de Senha
2. Desbloqueio de usuario
0. Sair
"
switch($stepChoice)
{
    1{changePassword}
    2{unclockAccount}
    0{exit}

}
}
menu
