# Configura a janela
$host.ui.RawUI.WindowTitle = "Ferramenta de reset de senhas do SET" 
$host.ui.RawUI.ForegroundColor = "White"

$width = 60
$sizeWindow = new-object System.Management.Automation.Host.Size $width,30
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

# Variaveis globais
$adminUser = "usuarioAdmin"
$adminPass = ConvertTo-SecureString "SenhaAdmin" -AsPlainText -Force
$adminCred = New-Object System.Management.Automation.PSCredential -ArgumentList ($adminUser, $adminPass)
$separator = "= = = = = = = = = = = = = = = = = = = = = = = = = = = = = ="

# Função de alteração de senha
function changePassword {
$username = read-host "Nome de usuario"
$pass = ConvertTo-SecureString "Set*$(Get-Date -format 'yyyy')" -AsPlainText -Force
try {
Get-ADUser $username -Properties * | Format-Table -Property DisplayName, LockedOut, PasswordExpired  -AutoSize
}
catch {
 Write-Host $separator -ForegroundColor White
 Write-Host "Não foi possivel encontrar o usuario informado" -ForegroundColor Red
 Write-Host $separator -ForegroundColor White
 menu
}
$confirmaReset = Read-Host "Confirma o reset para usuario acima? [S/N]"
if ( $confirmaReset -match "[sS]" ) { 
 Set-ADAccountPassword $username -NewPassword $pass -PassThru -Credential $adminCred -Server SYSMAP.com.br
 Write-Host $separator -ForegroundColor White
 Write-Host "Reset de senha para" $username "feito. | Senha:" "Set*$(Get-Date -format 'yyyy')" -ForegroundColor Green
 Write-Host $separator -ForegroundColor White
 menu
 }
else {
menu
}
}

# Função de desbloqueio de usuário
function unlockAccount {
$username = read-host "Nome de usuario"
try {
Get-ADUser $username -Properties * | Format-Table -Property DisplayName, LockedOut, PasswordExpired  -AutoSize
}
catch {
 Write-Host $separator -ForegroundColor White
 Write-Host "Não foi possivel encontrar o usuario informado" -ForegroundColor Red
 Write-Host $separator -ForegroundColor White
 menu
}
$confirmaDesbloqueio = Read-Host "Confirma o desbloqueio do usuario acima? [S/N]"
if ( $confirmaDesbloqueio -match "[sS]" ) {
Enable-ADAccount $username -Server SYSMAP.com.br -Credential $adminCred
Write-Host $separator -ForegroundColor White
Write-Host "Conta de usuario" $username "desbloqueada" -ForegroundColor Green
Write-Host $separator -ForegroundColor White
menu
}
else {
menu
}
}

# Menu de opções
function menu {
$stepChoice = read-host "
1. Reset de Senha
2. Desbloqueio de usuario
0. Sair

Digite uma opção"
switch($stepChoice)
{
    1{changePassword}
    2{unlockAccount}
    0{exit}

}
}
menu
