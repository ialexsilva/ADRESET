# Configura a janela
$host.ui.RawUI.WindowTitle = "Ferramenta de reset de senhas do SET" 
$host.ui.RawUI.ForegroundColor = "White"

$width = 62
$sizeWindow = new-object System.Management.Automation.Host.Size $width,16
$sizeBuffer = new-object System.Management.Automation.Host.Size $width,9999
if ($Host.UI.RawUI.WindowSize.width -gt $width) {
$Host.UI.RawUI.WindowSize = $sizeWindow
$Host.UI.RawUI.BufferSize = $sizeBuffer
}
else {
$Host.UI.RawUI.BufferSize = $sizeBuffer
$Host.UI.RawUI.WindowSize = $sizeWindow
}

if (-not (Get-Module ActiveDirectory)){     
 Import-Module ActiveDirectory -ErrorAction Stop
} 
# Função de alteração de senha
function changePassword {
$username = read-host "Nome de usuario"
# Get-ADUser $username -Properties * | Format-Table -Property DisplayName, LockedOut, PasswordExpired  -AutoSize
$pass = ConvertTo-SecureString "Set*$(Get-Date -format 'yyyy')" -AsPlainText -Force
$adminCred = Get-Credential -Message  "Você precisar inserir as credenciais para desbloqueio da função de reset de senha."
Set-ADAccountPassword $username -NewPassword $pass -PassThru -Credential $adminCred -Server SYSMAP.com.br
Write-Host "Reset de senha para " $username " feito. | Senha:" $pass -ForegroundColor Green
menu
}
# Função de desbloqueio de usuário
function unlockAccount {
$username = read-host "Nome de usuario"
$adminCred = Get-Credential -Message  "Você precisar inserir as credenciais para desbloqueio da função de reset de senha."
Enable-ADAccount $username -Server SYSMAP.com.br -Credential $adminCred
Write-Host "Conta de usuario " $username "desbloqueada" -ForegroundColor Green
menu
}
# Menu de opções
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
