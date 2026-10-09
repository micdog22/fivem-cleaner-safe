
# MicDog: FiveM Cleaner (Safe)

Ferramenta **segura** para **limpeza de cache do FiveM** e dados temporários específicos do jogo.  
Foco em **manutenção e solução de problemas** (travar em loading, textura corrompida, etc.).  
**Não** limpa identificadores do sistema, **não** mexe em registro sensível, **não** remove dados do Steam nem pastas do Windows fora do escopo do FiveM.

> Se você precisa abrir ticket com servidores ou com o suporte do FiveM, **mantenha os logs**. O script só apaga logs se você habilitar a opção `-IncludeLogs`.

## O que o script faz
- Fecha processos opcionais: `FiveM.exe` (e somente se você usar `-ForceStopProcesses`).
- Remove com segurança as pastas de cache do FiveM:
  - `%LocalAppData%\FiveM\FiveM.app\data\cache`
  - `%LocalAppData%\FiveM\FiveM.app\data\nui-storage`
  - `%LocalAppData%\FiveM\FiveM.app\data\server-cache`
  - `%LocalAppData%\FiveM\FiveM.app\data\server-cache-priv`
- Opcional: limpa `crashes` e `logs` **somente** se você passar `-IncludeCrashes` e/ou `-IncludeLogs`.
- Suporta **modo simulação** (`-WhatIf`) e confirmação (`-Confirm`).  
- Pode **zipar os logs/crashes** antes de apagar (`-BackupBeforeDelete`).

## O que NÃO faz
- Não toca em `%AppData%\CitizenFX\kvs` por padrão.
- Não apaga pastas do Steam/Epic.
- Não mexe em `C:\Windows\Temp`, `C:\Windows\Prefetch`.
- Não altera registro como `MachineGuid` (isso é sensível e não é necessário para manutenção).

## Uso rápido
```powershell
# 1) permitir execução só nesta sessão
Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass -Force

# 2) simular o que seria apagado
.\Clean-FiveM.ps1 -WhatIf

# 3) limpar caches (somente FiveM), fechando o FiveM se estiver aberto
.\Clean-FiveM.ps1 -ForceStopProcesses

# 4) opcional: incluir crashes e logs, fazendo backup zip antes
.\Clean-FiveM.ps1 -ForceStopProcesses -IncludeCrashes -IncludeLogs -BackupBeforeDelete
```

## Parâmetros
- `-ForceStopProcesses` fecha `FiveM.exe` antes da limpeza.
- `-IncludeCrashes` inclui `%LocalAppData%\FiveM\FiveM.app\crashes`.
- `-IncludeLogs` inclui `%LocalAppData%\FiveM\FiveM.app\logs`.
- `-BackupBeforeDelete` compacta as pastas selecionadas em `backups\FiveM-Backup-<data>.zip`.
- `-WhatIf` mostra sem executar.
- `-Confirm` pergunta antes de cada ação.

## Como rodar com duplo clique
Use o `run-cleaner.bat` (executa o PowerShell com política temporária apenas para o script).

## Avisos
- Feche o jogo antes de limpar. Usar `-ForceStopProcesses` ajuda.
- Logs podem ser úteis para suporte. Prefira fazer **backup** em vez de deletar.
- Este projeto é focado em **manutenção/estabilidade**, não em burlar sistemas de terceiros.

## Estrutura
```
micdog-fivem-cleaner-safe/
├─ Clean-FiveM.ps1
├─ run-cleaner.bat
├─ README.md
└─ LICENSE
```
