
[CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = 'Medium')]
param(
    [switch]$ForceStopProcesses,
    [switch]$IncludeCrashes,
    [switch]$IncludeLogs,
    [switch]$BackupBeforeDelete
)

function Stop-FiveM {
    if ($ForceStopProcesses) {
        Get-Process -Name "FiveM" -ErrorAction SilentlyContinue | ForEach-Object {
            if ($PSCmdlet.ShouldProcess($_.ProcessName, "Stop-Process -Force")) {
                Stop-Process -Id $_.Id -Force -ErrorAction SilentlyContinue
            }
        }
    }
}

function Get-Path($rel) {
    return Join-Path $env:LOCALAPPDATA $rel
}

$targets = @(
    "FiveM\FiveM.app\data\cache",
    "FiveM\FiveM.app\data\nui-storage",
    "FiveM\FiveM.app\data\server-cache",
    "FiveM\FiveM.app\data\server-cache-priv"
)

if ($IncludeCrashes) { $targets += "FiveM\FiveM.app\crashes" }
if ($IncludeLogs)    { $targets += "FiveM\FiveM.app\logs" }

$resolved = @()
foreach ($t in $targets) {
    $p = Get-Path $t
    if (Test-Path $p) { $resolved += $p }
}

Write-Host "MicDog: FiveM Cleaner (Safe)"
Write-Host "Fechando FiveM (opcional)..."

Stop-FiveM

if ($BackupBeforeDelete -and $resolved.Count -gt 0) {
    $stamp = Get-Date -Format "yyyyMMdd-HHmmss"
    $backupDir = Join-Path $PSScriptRoot "backups"
    if (-not (Test-Path $backupDir)) { New-Item -ItemType Directory -Path $backupDir | Out-Null }
    $zipPath = Join-Path $backupDir ("FiveM-Backup-" + $stamp + ".zip")
    Write-Host "Gerando backup em: $zipPath"
    Add-Type -AssemblyName System.IO.Compression.FileSystem
    if ($PSCmdlet.ShouldProcess(($resolved -join ', '), "Backup to $zipPath")) {
        if (Test-Path $zipPath) { Remove-Item $zipPath -Force }
        # Criar ZIP vazio e adicionar pastas
        [System.IO.Compression.ZipFile]::CreateFromDirectory((Split-Path $resolved[0] -Parent), $zipPath) | Out-Null
        # Acima cria muito; preferir zip incremental por pasta
        Remove-Item $zipPath -Force -ErrorAction SilentlyContinue
        $zip = $zipPath
        # criar zip e adicionar cada pasta
        [System.IO.Compression.ZipFile]::CreateFromDirectory($resolved[0], $zip)
        for ($i = 1; $i -lt $resolved.Count; $i++) {
            $tmp = Join-Path $backupDir ("tmp-" + $i + ".zip")
            [System.IO.Compression.ZipFile]::CreateFromDirectory($resolved[$i], $tmp)
            # mesclar: extrair tmp em pasta staging e recriar zip final seria custoso.
            # alternativa simples: criar múltiplos zips.
            # Para simplicidade, criamos vários zips:
            Rename-Item $tmp ($("FiveM-Backup-" + $stamp + "-part" + $i + ".zip"))
        }
        Write-Host "Backup concluído."
    }
}

foreach ($p in $resolved) {
    if ($PSCmdlet.ShouldProcess($p, "Remove-Item -Recurse -Force")) {
        try {
            Remove-Item -LiteralPath $p -Recurse -Force -ErrorAction Stop
            Write-Host "OK: $p"
        } catch {
            Write-Warning "Falha ao remover $p : $($_.Exception.Message)"
        }
    } else {
        Write-Host "Would remove: $p"
    }
}

Write-Host "Concluído."
