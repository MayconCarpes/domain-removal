
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
```

3. Salve como `limpar_perfis.ps1` dentro da pasta `C:\Scripts`.

---

### 2. Desativar Inicialização Rápida

1. Acesse o **Painel de Controle > Opções de Energia**.
2. Clique em **Escolher a função dos botões de energia**.
3. Clique em **Alterar configurações não disponíveis no momento**.
4. Desmarque a opção **Ligar inicialização rápida (recomendado)**.
5. Salve as alterações.

---

### 3. Criar a Tarefa Agendada

Abra o **Prompt de Comando como Administrador** e execute:

```cmd
SCHTASKS /Create /TN "LimpezaPerfis" /TR "powershell.exe -ExecutionPolicy Bypass -File C:\Scripts\limpar_perfis.ps1" /SC ONSTART /RU "SYSTEM" /F
```

> ⚠️ O comando deve ser executado em uma única linha.

---

### 4. Ajustar a Tarefa no Agendador

1. Digite `taskschd.msc` no **Executar (Win + R)** e pressione Enter.
2. Vá até **Biblioteca do Agendador de Tarefas**.
3. Clique com o botão direito em `LimpezaPerfis` > **Propriedades**.
4. Na aba **Geral**:
   - Marque **Executar com os privilégios mais altos**.
   - Configure para a versão correta do Windows.

---

### 5. Testar a Execução

1. Reinicie o computador.
2. Verifique o arquivo de log: `C:\Scripts\log_limpeza.txt`.

---

### 6. Proteger a Pasta do Script

1. Clique com o botão direito em `C:\Scripts` > **Propriedades**.
2. Aba **Segurança** > **Editar**.
3. Remova ou negue permissões para usuários comuns.
4. Mantenha acesso apenas para **Administradores** e **Sistema**.

---

## ▶️ Execução Manual (opcional)

```cmd
SCHTASKS /Run /TN "LimpezaPerfis"
```

---

## 🧠 Considerações Finais

Essa solução tem se mostrado eficaz em ambientes compartilhados, evitando o acúmulo desnecessário de dados e mantendo os computadores performáticos e organizados. Ideal para instituições de ensino, laboratórios, bibliotecas ou qualquer local onde o login de múltiplos usuários seja frequente.
