<#
.SYNOPSIS
    Instalador Automático PRV8 H4X - DMA Security
.DESCRIPTION
    Baixa e instala TODOS os componentes necessários para o loader PRV8 H4X.
    Execute como ADMINISTRADOR.
.NOTES
    Author     : DEV @_esieme
    Copyright  : © 2024 PRIV8 H4X - Segurança Blindada DMA. Todos os direitos reservados.
    Version    : 2.0
    Repo       : https://github.com/esieme/meu-loader-dependencias
#>

# ========== CONFIGURAÇÕES GLOBAIS ==========
$BaseURL      = "https://github.com/esieme/meu-loader-dependencias/releases/download/v1.0.0"
$PastaTemp    = "$env:TEMP\PRV8_H4X_Drivers"
$Credito      = "@_esieme"
$Copyright    = "© 2024 PRIV8 H4X - Segurança Blindada DMA. Todos os direitos reservados."
$Titulo       = "PRV8 H4X | INSTALADOR DE DRIVERS"

# ========== LISTA DE ARQUIVOS (TODOS DA RELEASE) ==========
$Arquivos = @(
    # .NET Framework e Runtimes
    @{ Nome = "NDP481-x86-x64-AllOS-ENU.exe";               Desc = ".NET Framework 4.8.1";              Args = "/q /norestart"; Tipo = "exe" }
    @{ Nome = "dotnet-runtime-8.0.12-win-x64.exe";          Desc = ".NET Runtime 8.0.12";               Args = "/quiet /norestart"; Tipo = "exe" }
    @{ Nome = "aspnetcore-runtime-8.0.12-win-x64.exe";      Desc = "ASP.NET Core Runtime 8.0.12";       Args = "/quiet /norestart"; Tipo = "exe" }
    @{ Nome = "windowsdesktop-runtime-7.0.20-win-x64.exe";  Desc = ".NET Desktop Runtime 7.0.20";       Args = "/quiet /norestart"; Tipo = "exe" }
    
    # Visual C++ Redistributáveis (versões antigas)
    @{ Nome = "vcredist2005_x64.exe";                       Desc = "Visual C++ 2005 x64";               Args = "/q"; Tipo = "exe" }
    @{ Nome = "vcredist2005_x86.exe";                       Desc = "Visual C++ 2005 x86";               Args = "/q"; Tipo = "exe" }
    @{ Nome = "vcredist2008_x64.exe";                       Desc = "Visual C++ 2008 x64";               Args = "/q"; Tipo = "exe" }
    @{ Nome = "vcredist2008_x86.exe";                       Desc = "Visual C++ 2008 x86";               Args = "/q"; Tipo = "exe" }
    @{ Nome = "vcredist2010_x64.exe";                       Desc = "Visual C++ 2010 x64";               Args = "/q"; Tipo = "exe" }
    @{ Nome = "vcredist2010_x86.exe";                       Desc = "Visual C++ 2010 x86";               Args = "/q"; Tipo = "exe" }
    @{ Nome = "vcredist2012_x64.exe";                       Desc = "Visual C++ 2012 x64";               Args = "/quiet /norestart"; Tipo = "exe" }
    @{ Nome = "vcredist2012_x86.exe";                       Desc = "Visual C++ 2012 x86";               Args = "/quiet /norestart"; Tipo = "exe" }
    @{ Nome = "vcredist2013_x64.exe";                       Desc = "Visual C++ 2013 x64";               Args = "/quiet /norestart"; Tipo = "exe" }
    @{ Nome = "vcredist2013_x86.exe";                       Desc = "Visual C++ 2013 x86";               Args = "/quiet /norestart"; Tipo = "exe" }
    @{ Nome = "vcredist2015_x64.exe";                       Desc = "Visual C++ 2015 x64";               Args = "/quiet /norestart"; Tipo = "exe" }
    @{ Nome = "vcredist2015_x86.exe";                       Desc = "Visual C++ 2015 x86";               Args = "/quiet /norestart"; Tipo = "exe" }
    @{ Nome = "vcredist2015_2017_2019_2022_x64.exe";        Desc = "VC++ 2015-2022 x64 (all-in-one)";    Args = "/quiet /norestart"; Tipo = "exe" }
    @{ Nome = "vcredist2015_2017_2019_2022_x86.exe";        Desc = "VC++ 2015-2022 x86 (all-in-one)";    Args = "/quiet /norestart"; Tipo = "exe" }
    @{ Nome = "VC_redist.x64.exe";                          Desc = "Visual C++ 2022 x64";               Args = "/quiet /norestart"; Tipo = "exe" }
    @{ Nome = "VC_redist.x86.exe";                          Desc = "Visual C++ 2022 x86";               Args = "/quiet /norestart"; Tipo = "exe" }
    
    # DirectX (arquivos auxiliares e instalador)
    @{ Nome = "dsetup.dll";                                 Desc = "DirectX - dsetup.dll";              Args = $null; Tipo = "aux" }
    @{ Nome = "dsetup32.dll";                               Desc = "DirectX - dsetup32.dll";            Args = $null; Tipo = "aux" }
    @{ Nome = "dxupdate.cif";                               Desc = "DirectX - dxupdate.cif";            Args = $null; Tipo = "aux" }
    @{ Nome = "dxupdate.dll";                               Desc = "DirectX - dxupdate.dll";            Args = $null; Tipo = "aux" }
    @{ Nome = "dxupdate.inf";                               Desc = "DirectX - dxupdate.inf";            Args = $null; Tipo = "aux" }
    @{ Nome = "dxwsetup.cif";                               Desc = "DirectX - dxwsetup.cif";            Args = $null; Tipo = "aux" }
    @{ Nome = "dxwsetup.inf";                               Desc = "DirectX - dxwsetup.inf";            Args = $null; Tipo = "aux" }
    @{ Nome = "dxwsetup.exe";                               Desc = "DirectX Web Installer";             Args = "/silent"; Tipo = "exe" }
)

# ========== FUNÇÃO: BANNER PRINCIPAL ==========
function Show-Banner {
    Clear-Host
    Write-Host "╔══════════════════════════════════════════════════════════════════════════════════════╗" -ForegroundColor Cyan
    Write-Host "║                                                                                      ║" -ForegroundColor Cyan
    Write-Host "║   ██████╗ ██████╗ ██╗   ██╗ █████╗     ██╗  ██╗ █████╗ ██╗  ██╗                     ║" -ForegroundColor Magenta
    Write-Host "║   ██╔══██╗██╔══██╗██║   ██║██╔══██╗    ╚██╗██╔╝██╔══██╗╚██╗██╔╝                     ║" -ForegroundColor Magenta
    Write-Host "║   ██████╔╝██████╔╝██║   ██║███████║     ╚███╔╝ ██║  ██║ ╚███╔╝                      ║" -ForegroundColor Magenta
    Write-Host "║   ██╔═══╝ ██╔══██╗╚██╗ ██╔╝██╔══██║     ██╔██╗ ██║  ██║ ██╔██╗                      ║" -ForegroundColor Magenta
    Write-Host "║   ██║     ██║  ██║ ╚████╔╝ ██║  ██║    ██╔╝ ██╗╚█████╔╝██╔╝ ██╗                     ║" -ForegroundColor Magenta
    Write-Host "║   ╚═╝     ╚═╝  ╚═╝  ╚═══╝  ╚═╝  ╚═╝    ╚═╝  ╚═╝ ╚════╝ ╚═╝  ╚═╝                     ║" -ForegroundColor Magenta
    Write-Host "║                                                                                      ║" -ForegroundColor Cyan
    Write-Host "║               SISTEMA DE INSTALAÇÃO AUTOMÁTICA - SEGURANÇA BLINDADA DMA              ║" -ForegroundColor Yellow
    Write-Host "╠══════════════════════════════════════════════════════════════════════════════════════╣" -ForegroundColor Cyan
    Write-Host "║                                                                                      ║" -ForegroundColor White
    Write-Host "║  » Bem-vindo ao instalador oficial do loader PRV8 H4X.                               ║" -ForegroundColor White
    Write-Host "║  » Este utilitário irá baixar e instalar TODAS as dependências necessárias.          ║" -ForegroundColor White
    Write-Host "║  » Processo completamente automático.                                                ║" -ForegroundColor White
    Write-Host "║  » Execute como ADMINISTRADOR para evitar erros.                                     ║" -ForegroundColor Yellow
    Write-Host "║                                                                                      ║" -ForegroundColor White
    Write-Host "╠══════════════════════════════════════════════════════════════════════════════════════╣" -ForegroundColor Cyan
    Write-Host "║  $Copyright" -ForegroundColor Green
    Write-Host "║  DEV $Credito                                                                        ║" -ForegroundColor Green
    Write-Host "╚══════════════════════════════════════════════════════════════════════════════════════╝" -ForegroundColor Cyan
    Write-Host ""
}

# ========== FUNÇÃO: VERIFICAR ADMIN ==========
function Test-Admin {
    $currentUser = [Security.Principal.WindowsPrincipal]::new([Security.Principal.WindowsIdentity]::GetCurrent())
    return $currentUser.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
}

# ========== FUNÇÃO: ANIMAÇÃO DE LOADING ==========
function Show-Loading {
    $spinner = @('⠋', '⠙', '⠹', '⠸', '⠼', '⠴', '⠦', '⠧', '⠇', '⠏')
    $i = 0
    while ($true) {
        Write-Host "`r  $($spinner[$i]) $($args[0])" -NoNewline -ForegroundColor Cyan
        $i = ($i + 1) % $spinner.Count
        Start-Sleep -Milliseconds 100
        if ($script:stopSpinner) { break }
    }
    Write-Host "`r  ✔ $($args[0])" -ForegroundColor Green
}

# ========== FUNÇÃO: BAIXAR ARQUIVO COM PROGRESSO ==========
function Download-File {
    param($url, $destino, $descricao)
    try {
        $webClient = New-Object System.Net.WebClient
        $event = Register-ObjectEvent -InputObject $webClient -EventName DownloadProgressChanged -Action {
            $percent = $EventArgs.ProgressPercentage
            Write-Host "`r  ⬇️  Baixando $descricao ... $percent%" -NoNewline -ForegroundColor Yellow
        }
        $webClient.DownloadFile($url, $destino)
        Unregister-Event -SourceIdentifier $event.Name -Force
        Write-Host "`r  ✔ $descricao baixado com sucesso.     " -ForegroundColor Green
        return $true
    } catch {
        Write-Host "`r  ❌ Falha ao baixar $descricao : $_" -ForegroundColor Red
        return $false
    }
}

# ========== INÍCIO DO SCRIPT ==========
Show-Banner

# Verificar Administrador
if (-not (Test-Admin)) {
    Write-Host "╔══════════════════════════════════════════════════════════════════════════════════════╗" -ForegroundColor Red
    Write-Host "║  ❌ ERRO CRÍTICO: Este script precisa ser executado como Administrador!              ║" -ForegroundColor Red
    Write-Host "║  🔄 Clique com botão direito no PowerShell e escolha 'Executar como administrador'.   ║" -ForegroundColor Yellow
    Write-Host "╚══════════════════════════════════════════════════════════════════════════════════════╝" -ForegroundColor Red
    Read-Host "`nPressione Enter para sair"
    exit 1
}

# Confirmar início
Write-Host "`n⚠️  ATENÇÃO: O sistema baixará e instalará vários componentes." -ForegroundColor Yellow
Write-Host "   O processo pode levar até 15 minutos dependendo da sua internet.`n" -ForegroundColor Yellow
$confirm = Read-Host "👉 Deseja continuar? (S/N)"
if ($confirm -notin @('S','s','Sim','sim','SIM')) {
    Write-Host "`nInstalação cancelada pelo usuário." -ForegroundColor Red
    exit 0
}

# Preparar pasta temporária
Write-Host "`n📁 Preparando ambiente de instalação..." -ForegroundColor Cyan
if (Test-Path $PastaTemp) { Remove-Item $PastaTemp -Recurse -Force }
New-Item -ItemType Directory -Path $PastaTemp -Force | Out-Null

# ========== FASE 1: DOWNLOAD DE TODOS OS ARQUIVOS ==========
Write-Host "`n══════════════════════════════════════════════════════════════════════════════════════" -ForegroundColor Cyan
Write-Host "  📦 FASE 1: BAIXANDO COMPONENTES ($($Arquivos.Count) arquivos)" -ForegroundColor White
Write-Host "══════════════════════════════════════════════════════════════════════════════════════`n" -ForegroundColor Cyan

$sucessosDownload = 0
foreach ($arq in $Arquivos) {
    $url = "$BaseURL/$($arq.Nome)"
    $destino = Join-Path $PastaTemp $arq.Nome
    if (Download-File -url $url -destino $destino -descricao $arq.Desc) {
        $sucessosDownload++
    } else {
        Write-Host "  ⚠️  Continuando mesmo com falha em $($arq.Desc)" -ForegroundColor Yellow
    }
}

Write-Host "`n📊 Download concluído: $sucessosDownload de $($Arquivos.Count) arquivos." -ForegroundColor Cyan

# ========== FASE 2: INSTALAÇÃO DOS COMPONENTES ==========
Write-Host "`n══════════════════════════════════════════════════════════════════════════════════════" -ForegroundColor Cyan
Write-Host "  🔧 FASE 2: INSTALANDO COMPONENTES" -ForegroundColor White
Write-Host "══════════════════════════════════════════════════════════════════════════════════════`n" -ForegroundColor Cyan

$executaveis = $Arquivos | Where-Object { $_.Tipo -eq "exe" -and $_.Nome -ne "dxwsetup.exe" }
$totalExe = $executaveis.Count
$instalados = 0
$falhas = 0

$i = 0
foreach ($exe in $executaveis) {
    $i++
    $caminho = Join-Path $PastaTemp $exe.Nome
    Write-Host "  [$i/$totalExe] $($exe.Desc)" -ForegroundColor Yellow
    if (Test-Path $caminho) {
        try {
            Write-Host "      ⚙️  Executando instalador com argumentos: $($exe.Args)" -ForegroundColor Gray
            $processo = Start-Process -FilePath $caminho -ArgumentList $exe.Args -Wait -PassThru -NoNewWindow
            if ($processo.ExitCode -eq 0 -or $processo.ExitCode -eq 3010) {
                Write-Host "      ✔ Instalação concluída (código $($processo.ExitCode))" -ForegroundColor Green
                $instalados++
            } else {
                Write-Host "      ⚠️  Instalador retornou código $($processo.ExitCode) (pode já estar instalado)" -ForegroundColor Gray
                $instalados++
            }
        } catch {
            Write-Host "      ❌ Erro durante a instalação: $_" -ForegroundColor Red
            $falhas++
        }
    } else {
        Write-Host "      ❌ Arquivo não encontrado em $caminho" -ForegroundColor Red
        $falhas++
    }
}

# Instalar DirectX
Write-Host "`n  🎮 [$(($totalExe+1))/$($totalExe+1)] DirectX Runtime" -ForegroundColor Yellow
$dxSetupPath = Join-Path $PastaTemp "dxwsetup.exe"
if (Test-Path $dxSetupPath) {
    try {
        Write-Host "      ⚙️  Executando dxwsetup.exe /silent" -ForegroundColor Gray
        $processo = Start-Process -FilePath $dxSetupPath -ArgumentList "/silent" -Wait -PassThru -NoNewWindow
        if ($processo.ExitCode -eq 0 -or $processo.ExitCode -eq 3010) {
            Write-Host "      ✔ DirectX instalado com sucesso" -ForegroundColor Green
            $instalados++
        } else {
            Write-Host "      ⚠️  DirectX código $($processo.ExitCode)" -ForegroundColor Gray
            $instalados++
        }
    } catch {
        Write-Host "      ❌ Falha na instalação do DirectX: $_" -ForegroundColor Red
        $falhas++
    }
} else {
    Write-Host "      ❌ dxwsetup.exe não encontrado" -ForegroundColor Red
    $falhas++
}

# ========== RESUMO FINAL ==========
Write-Host "`n╔══════════════════════════════════════════════════════════════════════════════════════╗" -ForegroundColor Green
Write-Host "║                             ✅ INSTALAÇÃO FINALIZADA                                   ║" -ForegroundColor Green
Write-Host "╠══════════════════════════════════════════════════════════════════════════════════════╣" -ForegroundColor Green
Write-Host "║                                                                                      ║" -ForegroundColor White
Write-Host "║  📦 Componentes baixados : $sucessosDownload de $($Arquivos.Count)                           ║" -ForegroundColor White
Write-Host "║  🔧 Componentes instalados: $instalados de $($totalExe+1) (incluindo DirectX)                ║" -ForegroundColor White
if ($falhas -gt 0) {
    Write-Host "║  ⚠️  Falhas detectadas    : $falhas (verifique manualmente se necessário)               ║" -ForegroundColor Yellow
} else {
    Write-Host "║  🎉 Nenhuma falha detectada! Tudo instalado com sucesso.                            ║" -ForegroundColor Green
}
Write-Host "║                                                                                      ║" -ForegroundColor White
Write-Host "║  🔁 Reinicie o computador para que todas as alterações tenham efeito.                 ║" -ForegroundColor Yellow
Write-Host "║                                                                                      ║" -ForegroundColor White
Write-Host "║  $Copyright" -ForegroundColor Green
Write-Host "║  DEV $Credito - Obrigado por utilizar o loader PRV8 H4X!                              ║" -ForegroundColor Green
Write-Host "╚══════════════════════════════════════════════════════════════════════════════════════╝" -ForegroundColor Green

# Limpeza (descomente se quiser remover arquivos temporários)
# Remove-Item $PastaTemp -Recurse -Force -ErrorAction SilentlyContinue

Read-Host "`nPressione Enter para sair"
