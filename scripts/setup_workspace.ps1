# setup_workspace.ps1
# Automates the linkage of a local workspace to the Global Antigravity Kit

# Resolve relative path from this script (Portable Mode)
$ScriptRoot = $PSScriptRoot

# Detection Logic: Where is this script?
if ($ScriptRoot -like "*\.agent\scripts") {
    # Local Mode: Running from within a project
    $GlobalKitPath = Resolve-Path (Join-Path $ScriptRoot "..\..")
}
else {
    # Global/Installer Mode: Running from kit/scripts
    $GlobalKitPath = Resolve-Path (Join-Path $ScriptRoot "..")
}

$LocalAgentPath = Join-Path (Get-Location) ".agent"

Write-Host "[AG-KIT] Initializing Workspace Link..." -ForegroundColor Cyan

# Verify Source Structure
$SourceAgentDir = if (Test-Path (Join-Path $GlobalKitPath ".agent")) { Join-Path $GlobalKitPath ".agent" } else { $GlobalKitPath }

if (-not (Test-Path $SourceAgentDir)) {
    Write-Error "Kit source structure not found. Please ensure the kit is correctly installed."
    exit 1
}

# 1. Create .agent directory
if (-not (Test-Path $LocalAgentPath)) {
    New-Item -ItemType Directory -Path $LocalAgentPath -Force | Out-Null
    Write-Host " [+] Created .agent directory" -ForegroundColor Green
}

# 2. Copy Architecture (Required for context)
$SourceArch = Join-Path $SourceAgentDir "ARCHITECTURE.md"
if (Test-Path $SourceArch) {
    Copy-Item $SourceArch -Destination "$LocalAgentPath\ARCHITECTURE.md" -Force
    Write-Host " [+] Linker: ARCHITECTURE.md" -ForegroundColor Gray
}
else {
    Write-Host " [!] ARCHITECTURE.md not found in kit, skipping..." -ForegroundColor Yellow
}

# 3. Copy Workflows (Required for VS Code Menu)
$SourceWorkflows = Join-Path $SourceAgentDir "workflows"
if (Test-Path $SourceWorkflows) {
    if (Test-Path "$LocalAgentPath\workflows") {
        Remove-Item "$LocalAgentPath\workflows" -Recurse -Force
    }
    Copy-Item $SourceWorkflows -Destination "$LocalAgentPath" -Recurse -Force
    Write-Host " [+] Linker: Workflows" -ForegroundColor Gray
}

# 4. Copy Agents
$SourceAgents = Join-Path $SourceAgentDir "agents"
if (Test-Path $SourceAgents) {
    if (Test-Path "$LocalAgentPath\agents") { Remove-Item "$LocalAgentPath\agents" -Recurse -Force }
    Copy-Item $SourceAgents -Destination "$LocalAgentPath" -Recurse -Force
    Write-Host " [+] Linker: Agents" -ForegroundColor Gray
}

# 5. Copy Skills
$SourceSkills = Join-Path $SourceAgentDir "skills"
if (Test-Path $SourceSkills) {
    if (Test-Path "$LocalAgentPath\skills") { Remove-Item "$LocalAgentPath\skills" -Recurse -Force }
    Copy-Item $SourceSkills -Destination "$LocalAgentPath" -Recurse -Force
    Write-Host " [+] Linker: Skills" -ForegroundColor Gray
}

# 6. Copy Scripts
$SourceScripts = Join-Path $SourceAgentDir "scripts"
if (Test-Path $SourceScripts) {
    if (Test-Path "$LocalAgentPath\scripts") { Remove-Item "$LocalAgentPath\scripts" -Recurse -Force }
    Copy-Item $SourceScripts -Destination "$LocalAgentPath" -Recurse -Force
    Write-Host " [+] Linker: Scripts" -ForegroundColor Gray
}

# 7. Copy Shared
$SourceShared = Join-Path $SourceAgentDir ".shared"
if (Test-Path $SourceShared) {
    if (Test-Path "$LocalAgentPath\.shared") { Remove-Item "$LocalAgentPath\.shared" -Recurse -Force }
    Copy-Item $SourceShared -Destination "$LocalAgentPath" -Recurse -Force
    Write-Host " [+] Linker: Shared Assets" -ForegroundColor Gray
}

# 8. Setup GEMINI.md (Rules)
$GlobalGemini = Join-Path $SourceAgentDir "rules\GEMINI.md"
$LocalRulesPath = Join-Path $LocalAgentPath "rules"
$LocalGemini = Join-Path $LocalRulesPath "GEMINI.md"

if (Test-Path $GlobalGemini) {
    # Ensure rules directory exists
    if (-not (Test-Path $LocalRulesPath)) {
        New-Item -ItemType Directory -Path $LocalRulesPath -Force | Out-Null
    }

    # Only copy if local doesn't exist to preserve user customization
    if (-not (Test-Path $LocalGemini)) {
        Copy-Item $GlobalGemini -Destination $LocalGemini
        Write-Host " [+] Linker: rules/GEMINI.md (Initialized)" -ForegroundColor Green
    }
    else {
        Write-Host " [=] Linker: rules/GEMINI.md (Preserved Custom)" -ForegroundColor DarkGray
    }
}

# 9. Create .pointer file (Optional, for explicit tracking)
"path=$GlobalKitPath" | Out-File "$LocalAgentPath\.pointer" -Encoding utf8

Write-Host "[AG-KIT] Workspace Linked Successfully!" -ForegroundColor Cyan
Write-Host "Antigravity Identity Active. Rules present in .agent/GEMINI.md." -ForegroundColor Cyan
