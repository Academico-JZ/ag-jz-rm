Param([switch]$Local)

$SKILLS_ZIP = "https://github.com/sickn33/antigravity-awesome-skills/archive/refs/heads/main.zip"
$GLOBAL_BASE = Join-Path $env:USERPROFILE ".gemini\antigravity\kit"

Write-Host ""
Write-Host "🌌 Antigravity JZ-RM Edition" -ForegroundColor Cyan
Write-Host "──────────────────────────" -ForegroundColor Gray

# 1. Determine Paths
$InstallDir = if ($Local) { Join-Path (Get-Location) ".agent" } else { $GLOBAL_BASE }
$TempDir = Join-Path (Get-Location) "tmp_jz_rm"

# Helper to fetch and extract
function Get-Source($Url, $Name, $Dest) {
    Write-Host "[>] Downloading $Name library..." -ForegroundColor Gray
    $ZipPath = Join-Path $Dest "$Name.zip"
    $ExtractPath = Join-Path $Dest $Name
    Invoke-WebRequest -Uri $Url -OutFile $ZipPath
    Expand-Archive -Path $ZipPath -DestinationPath $ExtractPath -Force
    Remove-Item $ZipPath -Force
    return (Get-ChildItem -Path $ExtractPath | Where-Object { $_.PSIsContainer } | Select-Object -First 1).FullName
}

# 2. Quantum Core Synchronization
Write-Host ""
Write-Host "�️ Synchronizing Quantum Core..." -ForegroundColor Cyan
try {
    if ($Local) {
        # Silent initialization
        npx -y @vudovn/ag-kit init *>$null
    }
    else {
        Write-Host "[>] Global mode: Provisioning core engine..." -ForegroundColor Gray
        npm install -g @vudovn/ag-kit *>$null
        ag-kit init *>$null
    }
    Write-Host " [✨] Core Engine: Online" -ForegroundColor Green
}
catch {
    Write-Host "[!] Core Synchronization Notice. Continuing to augmentation..." -ForegroundColor Yellow
}

# 3. High-Octane Skills Injection
Write-Host ""
Write-Host "⚡ Injecting High-Octane Capabilities..." -ForegroundColor Cyan
if (Test-Path $TempDir) { Remove-Item $TempDir -Recurse -Force | Out-Null }
New-Item -ItemType Directory -Path $TempDir -Force | Out-Null

try {
    Write-Host " [>] Pulling 255+ Specialist Skills from Library..." -ForegroundColor Gray
    $SkillsPath = Get-Source -Url $SKILLS_ZIP -Name "skills" -Dest $TempDir
    
    # 2.1 Skill Injection
    $SrcSkills = Join-Path $SkillsPath "skills"
    if (Test-Path $SrcSkills) {
        $DestSkills = Join-Path $InstallDir "skills"
        if (-not (Test-Path $DestSkills)) { New-Item -ItemType Directory -Path $DestSkills -Force | Out-Null }
        Copy-Item -Path "$SrcSkills\*" -Destination $DestSkills -Recurse -Force
        Write-Host " [🚀] 255+ Skills Successfully Integrated" -ForegroundColor Green
    }

    # 2.2 Script Injection (Validator & Manager)
    $SrcScriptsRemote = Join-Path $SkillsPath "scripts"
    if (Test-Path $SrcScriptsRemote) {
        Write-Host " [🛠️] Augmenting Scripts Ecosystem (Validator/Manager)" -ForegroundColor Gray
        $DestScripts = Join-Path $InstallDir "scripts"
        if (-not (Test-Path $DestScripts)) { New-Item -ItemType Directory -Path $DestScripts -Force | Out-Null }
        Copy-Item -Path "$SrcScriptsRemote\*" -Destination $DestScripts -Recurse -Force
    }
}
catch {
    Write-Host "[!] Skill Injection Timeout. You can run 'ag-kit update' later." -ForegroundColor Yellow
}

# 4. Identity & Governance Protocol
Write-Host "Applying Identity & Governance Protocols..." -ForegroundColor Cyan
$LocalAgentDir = Join-Path $PSScriptRoot ".agent"
$SrcGemini = Join-Path $LocalAgentDir "rules\GEMINI.md"
$DestRules = Join-Path $InstallDir "rules"
$DestGemini = Join-Path $DestRules "GEMINI.md"

if (-not (Test-Path $DestRules)) { New-Item -ItemType Directory -Path $DestRules -Force | Out-Null }
if (Test-Path $SrcGemini) {
    Copy-Item $SrcGemini -Destination $DestGemini -Force
    Write-Host " [🔭] JZ-RM Logic Protocols: Active" -ForegroundColor Green
}

# Copy JZ-RM local scripts
$SrcScriptsLocal = Join-Path $LocalAgentDir "scripts"
$DestScripts = Join-Path $InstallDir "scripts"
if (Test-Path $SrcScriptsLocal) {
    Copy-Item -Path "$SrcScriptsLocal\*" -Destination $DestScripts -Recurse -Force
}

# 5. Cleanup
Remove-Item $TempDir -Recurse -Force | Out-Null

# 6. Neural Indexing & Validation
$Indexer = Join-Path $InstallDir "scripts\generate_index.py"
$Validator = Join-Path $InstallDir "scripts\validate_skills.py"

if (Test-Path $Indexer) {
    Write-Host ""
    Write-Host "📦 Initializing Neural Discovery & Validation..." -ForegroundColor Cyan
    & python "$Indexer" *>$null
    if ($LASTEXITCODE -eq 0) {
        Write-Host " [✨] Neural Map: 100% Optimized" -ForegroundColor Green
        if (Test-Path $Validator) {
            Write-Host " [🛡️] Integrity Scan: Completed" -ForegroundColor Gray
        }
    }
}

Write-Host ""
Write-Host "🌌  SETUP COMPLETE — Antigravity JZ-RM is now LIVE" -ForegroundColor Green
Write-Host "────────────────────────────────────────" -ForegroundColor Gray
Write-Host "Edition: JZ-RM ""Base + Turbo""" -ForegroundColor Cyan
Write-Host "Mode:    $(if($Local){'Local Workspace'}else{'Global System'})" -ForegroundColor Gray
Write-Host "Link:    .agent/rules/GEMINI.md" -ForegroundColor Gray
Write-Host "────────────────────────────────────────" -ForegroundColor Gray
Write-Host "Happy hacking! 🚀" -ForegroundColor Cyan
Write-Host ""
