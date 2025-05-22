# Lista todos os perfis locais
$perfis = Get-CimInstance -Class Win32_UserProfile | Where-Object {
    ($_.LocalPath -like "C:\Users\*") -and
    ($_.LocalPath -notlike "*Administrator*") -and
    ($_.LocalPath -notlike "*Public*") -and
    ($_.LocalPath -notlike "*Default*") -and
    ($_.Special -eq $false)
}

# Remove perfis
foreach ($perfil in $perfis) {
    try {
        Write-Host "Removendo perfil: $($perfil.LocalPath)"
        Remove-CimInstance -InputObject $perfil -ErrorAction Stop
    } catch {
        Write-Warning "Erro ao remover $($perfil.LocalPath): $_"
    }
}
