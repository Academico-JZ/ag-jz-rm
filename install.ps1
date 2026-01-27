# Antigravity JZ Edition - Instalador Global (Streamlined)
# Este script automatiza o download e configuração do Kit Global na pasta do usuário

$InstallDir = Join-Path $env:USERPROFILE ".gemini\antigravity"
$KitDir = Join-Path $InstallDir "kit"
$ZipFile = Join-Path $InstallDir "kit.zip"
$TempExt = Join-Path $InstallDir "temp_ext"

Write-Host ""
Write-Host "🌌 Antigravity Kit (JZ e RM Edition) - Instalador Global" -ForegroundColor Cyan
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
} catch {
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

Write-Host ""
Write-Host "✅ Instalação Global Concluída com Sucesso!" -ForegroundColor Green
Write-Host "📍 Local: $KitDir" -ForegroundColor Gray
Write-Host ""
Write-Host "🚀 Próximos Passos:" -ForegroundColor Cyan
Write-Host "1. Vá até a pasta de qualquer projeto no VS Code / Claude Code."
Write-Host "2. Rode o comando de linkagem:"
Write-Host "   powershell -ExecutionPolicy Bypass -File `"$KitDir\scripts\setup_workspace.ps1`"" -ForegroundColor Yellow
Write-Host "3. Peça para a IA ler o arquivo .agent/GEMINI.md"
Write-Host ""
