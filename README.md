# 🧹 Automação para Limpeza de Perfis de Usuários do Domínio

## 📌 Descrição

Esta solução foi desenvolvida para resolver um problema recorrente em computadores públicos da instituição, onde o acesso de inúmeros usuários do domínio fazia com que o acúmulo de perfis gerasse lentidão, falhas de login e ocupação excessiva de espaço em disco. 

Mesmo com softwares de congelamento instalados, os perfis permaneciam no sistema, causando instabilidade. Para contornar esse cenário, foi criado um **script em PowerShell** que remove automaticamente os perfis de usuários do domínio toda vez que o computador é iniciado.

O script mantém apenas os perfis padrões do Windows: `Administrador`, `Default`, `Public`, entre outros fixos.

---

## ⚙️ Funcionalidades

- 🔄 Remoção automática de perfis de usuários do domínio ao ligar ou reiniciar o computador.
- ✅ Preservação de perfis essenciais do sistema.
- 🛡️ Restrição de acesso à pasta do script para evitar alterações indevidas.
- 🗒️ Geração de log com os perfis removidos ou erros ocorridos.
- 🚫 Compatível com computadores com Inicialização Rápida desativada.

---

## 📝 Requisitos

- Windows 10 ou superior.
- Permissões de administrador.
- Acesso ao Agendador de Tarefas.
- Inicialização Rápida desativada.

---

## 🛠️ Passo a Passo da Configuração

### 1. Criar o Script

1. Crie a pasta `C:\Scripts`.
2. Abra o **Bloco de Notas** e cole o seguinte script:

```powershell
$logPath = "C:\Scripts\log_limpeza.txt"
$usuarios = Get-CimInstance -ClassName Win32_UserProfile | Where-Object {
    $_.LocalPath -like "C:\Users\*" -and
    $_.LocalPath -notmatch "Administrador|Default|Public|admin" -and
    $_.Special -eq $false
}

foreach ($usuario in $usuarios) {
    try {
        Remove-CimInstance -InputObject $usuario
        Add-Content $logPath "[$(Get-Date)] Removido: $($usuario.LocalPath)"
    } catch {
        Add-Content $logPath "[$(Get-Date)] ERRO ao remover: $($usuario.LocalPath)"
    }
}
