<#
.SYNOPSIS
    Instalador automático de runtimes para PRV8 - H4X
.DESCRIPTION
    Baixa e instala todos os componentes a partir do GitHub Releases.
    Execute como ADMINISTRADOR.
.NOTES
    Author: DEV @_esieme
    Repo: https://github.com/esieme/meu-loader-dependencias
#>

# ========== CONFIGURAÇÕES ==========
$BaseURL = "https://github.com/esieme/meu-loader-dependencias/releases/download/v1.0.0"
$PastaTemp = "$env:TEMP\PRV8_Drivers"
$Credito = "@_esieme"

# ========== LISTA DE ARQUIVOS (conforme Release v1.0.0) ==========
$Arquivos = @(
    @{ Nome = "NDP481-x86-x64-AllOS-ENU.exe";               Desc = ".NET Framework 4.8.1";              Args = "/q /norestart" }
    @{ Nome = "dotnet-runtime-8.0.12-win-x64.exe";          Desc = ".NET Runtime 8.0.12";               Args = "/quiet /norestart" }
    @{ Nome = "aspnetcore-runtime-8.0.12-win-x64.exe";      Desc = "ASP.NET Core Runtime 8.0.12";       Args = "/quiet /norestart" }
    @{ Nome = "windowsdesktop-runtime-7.0.20-win-x64.exe";  Desc = ".NET Desktop Runtime 7.0.20";       Args = "/quiet /norestart" }
    @{ Nome = "vcredist2005_x64.exe";                       Desc = "Visual C++ 2005 x64";               Args = "/q" }
    @{ Nome = "vcredist2005_x86.exe";                       Desc = "Visual C++ 2005 x86";               Args = "/q" }
    @{ Nome = "vcredist2008_x64.exe";                       Desc = "Visual C++ 2008 x64";               Args = "/q" }
    @{ Nome = "vcredist2008_x86.exe";                       Desc = "Visual C++ 2008 x86";               Args = "/q" }
    @{ Nome = "vcredist2010_x64.exe";                       Desc = "Visual C++ 2010 x64";               Args = "/q" }
    @{ Nome = "vcredist2010_x86.exe";                       Desc = "Visual C++ 2010 x86";               Args = "/q" }
    @{ Nome = "vcredist2012_x64.exe";                       Desc = "Visual C++ 2012 x64";               Args = "/quiet /norestart" }
    @{ Nome = "vcredist2012_x86.exe";                       Desc = "Visual C++ 2012 x86";               Args = "/quiet /norestart" }
    @{ Nome = "vcredist2013_x64.exe";                       Desc = "Visual C++ 2013 x64";               Args = "/quiet /norestart" }
    @{ Nome = "vcredist2013_x86.exe";                       Desc = "Visual C++ 2013 x86";               Args = "/quiet /norestart" }
    @{ Nome = "vcredist2015_x64.exe";                       Desc = "Visual C++ 2015 x64";               Args = "/quiet /norestart" }
    @{ Nome = "vcredist2015_x86.exe";                       Desc = "Visual C++ 2015 x86";               Args = "/quiet /norestart" }
    @{ Nome = "VC_redist.x64.exe";                          Desc = "Visual C++ 2022 x64";               Args = "/quiet /norestart" }
    @{ Nome = "VC_redist.x86.exe";                          Desc = "Visual C++ 2022 x86";               Args = "/quiet /norestart" }
    @{ Nome = "dxwsetup.exe";                               Desc = "DirectX Runtime";                   Args = "/silent" }
)

# ========== FUNÇÃO DE INTERFACE ==========
function Show-Banner {
    Clear-Host
    Write-Host "╔════════════════════════════════════════════════════════════════╗" -ForegroundColor Cyan
    Write-Host "║                    DRIVERS PRV8 - H4X                           ║" -ForegroundColor Magenta
    Write-Host "║         Instalação Automática de Dependências                  ║" -ForegroundColor Cyan
    Write-Host "╠════════════════════════════════════════════════════════════════╣" -ForegroundColor Cyan
    Write-Host "║  Bem-vindo! Este instalador baixará e instalará TODOS os       ║" -ForegroundColor White
    Write-Host "║  componentes necessários para o funcionamento do seu loader.   ║" -ForegroundColor White
    Write-Host "║                                                                 ║" -ForegroundColor White
    Write-Host "║  >> Processo 100% automático                                   ║" -ForegroundColor Yellow
    Write-Host "║  >> Execute como Administrador                                 ║" -ForegroundColor Yellow
    Write-Host "║  >> Pode demorar alguns minutos dependendo da internet         ║" -ForegroundColor Yellow
    Write-Host "╠════════════════════════════════════════════════════════════════╣" -ForegroundColor Cyan
    Write-Host "║                    DEV @$Credito                               ║" -ForegroundColor Green
    Write-Host "╚════════════════════════════════════════════════════════════════╝" -ForegroundColor Cyan
    Write-Host ""
}

# ========== VERIFICA ADMIN ==========
if (-NOT ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Show-Banner
    Write-Host "❌ ERRO: Este script precisa ser executado como Administrador!" -ForegroundColor Red
    Write-Host "   Clique com botão direito no PowerShell e escolha 'Executar como administrador'." -ForegroundColor Yellow
    Read-Host "Pressione Enter para sair"
    exit 1
}

# ========== PERGUNTA INICIAL ==========
Show-Banner
Write-Host "👉 Deseja iniciar a instalação de todos os drivers/runtimes? (S/N)" -ForegroundColor White
$resposta = Read-Host
if ($resposta -notin 'S','s','Sim','sim','SIM') {
    Write-Host "Instalação cancelada." -ForegroundColor Red
    exit 0
}

# ========== PREPARA PASTA TEMPORÁRIA ==========
Write-Host "`n📁 Preparando ambiente..." -ForegroundColor Yellow
if (Test-Path $PastaTemp) { Remove-Item $PastaTemp -Recurse -Force }
New-Item -ItemType Directory -Path $PastaTemp -Force | Out-Null

# ========== LOOP DE DOWNLOAD E INSTALAÇÃO ==========
$total = $Arquivos.Count
$ok = 0
$falhas = 0

for ($i = 0; $i -lt $total; $i++) {
    $arq = $Arquivos[$i]
    $url = "$BaseURL/$($arq.Nome)"
    $destino = Join-Path $PastaTemp $arq.Nome
    $percentual = [math]::Round(($i / $total) * 100, 0)
    
    Write-Host "`n[$($i+1)/$total] - $($arq.Desc) ($percentual%)" -ForegroundColor Cyan
    
    # Download com barra de progresso
    try {
        Write-Host "  ⬇️  Baixando..." -NoNewline -ForegroundColor Yellow
        Invoke-WebRequest -Uri $url -OutFile $destino -UseBasicParsing
        Write-Host " OK" -ForegroundColor Green
        
        # Instalação
        Write-Host "  🔧 Instalando em modo silencioso..." -NoNewline -ForegroundColor Yellow
        $processo = Start-Process -FilePath $destino -ArgumentList $arq.Args -Wait -PassThru -NoNewWindow
        if ($processo.ExitCode -eq 0 -or $processo.ExitCode -eq 3010) {
            Write-Host " INSTALADO" -ForegroundColor Green
            $ok++
        } else {
            Write-Host " CÓDIGO $($processo.ExitCode) (talvez já instalado)" -ForegroundColor Gray
            $ok++ # consideramos como ok para não assustar
        }
    }
    catch {
        Write-Host "`n  ❌ Falha: $_" -ForegroundColor Red
        $falhas++
    }
}

# ========== FINALIZAÇÃO ==========
Write-Host "`n╔════════════════════════════════════════════════════════════════╗" -ForegroundColor Green
Write-Host "║                     INSTALAÇÃO CONCLUÍDA!                        ║" -ForegroundColor Green
Write-Host "╠════════════════════════════════════════════════════════════════╣" -ForegroundColor Green
Write-Host "║  ✅ Componentes instalados com sucesso: $ok de $total                 ║" -ForegroundColor White
if ($falhas -gt 0) {
    Write-Host "║  ⚠️  Falhas: $falhas (verifique manualmente se necessário)           ║" -ForegroundColor Yellow
}
Write-Host "║                                                                 ║" -ForegroundColor White
Write-Host "║  🔁 Reinicie o computador para que tudo funcione corretamente.  ║" -ForegroundColor Yellow
Write-Host "║                                                                 ║" -ForegroundColor White
Write-Host "║  DEV @$Credito - Obrigado por usar PRV8 - H4X!                    ║" -ForegroundColor Cyan
Write-Host "╚════════════════════════════════════════════════════════════════╝" -ForegroundColor Green

# Limpeza opcional (comentar se quiser manter arquivos na temp)
Remove-Item $PastaTemp -Recurse -Force -ErrorAction SilentlyContinue

Read-Host "`nPressione Enter para sair"