Param([switch]$Local)

# Antigravity JZ Edition - Instalador Modular
# Este script automatiza o download e configuração do Kit

if ($Local) {
    $InstallDir = Join-Path (Get-Location) ".agent"
    $KitDir = Join-Path $InstallDir "kit_source"
    Write-Host "[!] Instalação LOCAL detectada (Workspace-only)" -ForegroundColor Yellow
}
else {
    $InstallDir = Join-Path $env:USERPROFILE ".gemini\antigravity"
    $KitDir = Join-Path $InstallDir "kit"
}

$ZipFile = Join-Path $InstallDir "kit.zip"
$TempExt = Join-Path $InstallDir "temp_ext"

Write-Host ""
Write-Host "🌌 Antigravity Kit (JZ e RM Edition) - Instalador" -ForegroundColor Cyan
Write-Host "--------------------------------------------------" -ForegroundColor DarkCyan

# 1. Preparar pastas
if (-not (Test-Path $InstallDir)) {
    New-Item -ItemType Directory -Path $InstallDir -Force | Out-Null
    Write-Host "[+] Diretório de instalação criado: $InstallDir" -ForegroundColor Gray
}

# 2. Cleanup se já existir
if (Test-Path $KitDir) {
    Write-Host "[!] Instalação anterior detectada. Atualizando..." -ForegroundColor Yellow
    Remove-Item $KitDir -Recurse -Force
}

# 3. Download
Write-Host "[>] Baixando última versão do repositório Academico-JZ..." -ForegroundColor Gray
try {
    Invoke-WebRequest -Uri "https://github.com/Academico-JZ/antigravity-jz-rm/archive/refs/heads/main.zip" -OutFile $ZipFile -ErrorAction Stop
}
catch {
    Write-Error "Erro ao baixar o kit: $_"
    exit 1
}

# 4. Extração
Write-Host "[>] Extraindo arquivos..." -ForegroundColor Gray
if (Test-Path $TempExt) { Remove-Item $TempExt -Recurse -Force }
Expand-Archive -Path $ZipFile -DestinationPath $TempExt

# Localizar a pasta extraída (o GitHub coloca o branch no nome)
$ExtractedFolder = Get-ChildItem -Path $TempExt | Where-Object { $_.PSIsContainer } | Select-Object -First 1
Move-Item -Path $ExtractedFolder.FullName -Destination $KitDir

# 5. Cleanup Final
Remove-Item $ZipFile -Force
Remove-Item $TempExt -Recurse -Force

# 6. Auto-Hydration (Sync Skills)
Write-Host ""
Write-Host "🔄 Sincronizando Skills (Vudovn + Awesome Skills)..." -ForegroundColor Cyan
try {
    # Verifica se python está instalado
    & python --version | Out-Null
    if ($LASTEXITCODE -eq 0) {
        python "$KitDir\.agent\scripts\sync_kits.py"
    }
    else {
        Write-Host "[!] Python não encontrado. Skills extras não foram unificadas. Instale o Python." -ForegroundColor Yellow
    }
}
catch {
    Write-Host "[!] Falha no sincronismo automático." -ForegroundColor Yellow
}

# 7. Linking (Auto-Init)
if (Test-Path "$KitDir\scripts\setup_workspace.ps1") {
    Write-Host ""
    Write-Host "🔗 Inicializando workspace..." -ForegroundColor Cyan
    powershell -ExecutionPolicy Bypass -File "$KitDir\scripts\setup_workspace.ps1"
}

Write-Host ""
Write-Host "✅ Instalação Concluída!" -ForegroundColor Green
Write-Host "📍 Localização do Kit: $KitDir" -ForegroundColor Gray
Write-Host "🚀 Antigravity está online. Regras aplicadas via .agent/GEMINI.md" -ForegroundColor Cyan
Write-Host ""
