#!/usr/bin/env node

/**
 * Antigravity Kit (JZ Edition) - Node.js Installer
 * 
 * Provides "npx ag-jz-rm init" functionality.
 * Compatible with Windows, macOS, and Linux.
 */

const fs = require('fs');
const path = require('path');
const https = require('https');
const { execSync } = require('child_process');
const os = require('os');

// Configuration
const REPO_ZIP_URL = "https://github.com/Academico-JZ/antigravity-jz-rm/archive/refs/heads/main.zip";
const KIT_DIR_NAME = ".gemini/antigravity/kit";
const TEMP_DIR_NAME = ".gemini/antigravity/temp_npm_install";

// Colors for console
const colors = {
    reset: "\x1b[0m",
    cyan: "\x1b[36m",
    green: "\x1b[32m",
    yellow: "\x1b[33m",
    red: "\x1b[31m",
    gray: "\x1b[90m"
};

function log(msg, color = colors.reset) {
    console.log(`${color}${msg}${colors.reset}`);
}

function getHomeDir() {
    return os.homedir();
}

function downloadFile(url, dest) {
    return new Promise((resolve, reject) => {
        const file = fs.createWriteStream(dest);
        let downloadedBytes = 0;
        let lastDataTime = Date.now();
        const INACTIVITY_TIMEOUT = 20000; // 20s de inatividade causa timeout

        const request = https.get(url, (response) => {
            // Handle redirects
            if (response.statusCode >= 300 && response.statusCode < 400 && response.headers.location) {
                log(`[>] Redirecting to download server...`, colors.gray);
                file.close();
                fs.unlink(dest, () => { });
                downloadFile(response.headers.location, dest).then(resolve).catch(reject);
                return;
            }

            if (response.statusCode !== 200) {
                reject(new Error(`Server returned ${response.statusCode}`));
                return;
            }

            const totalSize = parseInt(response.headers['content-length'], 10);

            let startTime = Date.now();
            response.on('data', (chunk) => {
                downloadedBytes += chunk.length;
                lastDataTime = Date.now();
                const elapsedSeconds = (Date.now() - startTime) / 1000;
                const speed = (downloadedBytes / 1024 / (elapsedSeconds || 1)).toFixed(1);

                if (totalSize) {
                    const percent = ((downloadedBytes / totalSize) * 100).toFixed(0);
                    process.stdout.write(`\r[>] Progress: ${percent}% (${(downloadedBytes / 1024).toFixed(0)} KB) @ ${speed} KB/s    `);
                } else {
                    process.stdout.write(`\r[>] Progress: ${(downloadedBytes / 1024).toFixed(0)} KB @ ${speed} KB/s    `);
                }
            });

            response.pipe(file);

            file.on('finish', () => {
                process.stdout.write('\n');
                file.close();
                clearInterval(inactivityCheck);
                resolve();
            });
        }).on('error', (err) => {
            process.stdout.write('\n');
            fs.unlink(dest, () => { });
            clearInterval(inactivityCheck);
            reject(err);
        });

        // Socket Inactivity Monitor
        const inactivityCheck = setInterval(() => {
            if (Date.now() - lastDataTime > INACTIVITY_TIMEOUT) {
                clearInterval(inactivityCheck);
                request.destroy();
                reject(new Error(`Download stalled (no data for ${INACTIVITY_TIMEOUT / 1000}s). Check your internet.`));
            }
        }, 2000);
    });
}

async function main() {
    log("\n🌌 Antigravity Kit (JZ e RM Edition) - CLI Installer", colors.cyan);
    log("--------------------------------------------------", colors.gray);

    const homeDir = getHomeDir();
    const installDir = path.join(homeDir, KIT_DIR_NAME);
    const tempDir = path.join(homeDir, TEMP_DIR_NAME);
    const zipPath = path.join(tempDir, "kit.zip");

    try {
        // 1. Prepare Paths
        if (fs.existsSync(tempDir)) {
            fs.rmSync(tempDir, { recursive: true, force: true });
        }
        fs.mkdirSync(tempDir, { recursive: true });

        // 2. Download with Retry Logic
        log(`[>] Downloading kit from GitHub...`, colors.gray);

        let success = false;
        let attempts = 0;
        const maxAttempts = 3;

        while (attempts < maxAttempts && !success) {
            try {
                attempts++;
                if (attempts > 1) log(`[!] Retry attempt ${attempts}/${maxAttempts}...`, colors.yellow);
                await downloadFile(REPO_ZIP_URL, zipPath);
                success = true;
            } catch (e) {
                if (attempts === maxAttempts) throw e;
                log(`[!] Connection issue: ${e.message}. Retrying in 3s...`, colors.yellow);
                await new Promise(r => setTimeout(r, 3000));
            }
        }

        // 3. Extract
        log(`[>] Extracting...`, colors.gray);
        // Use tar for extraction (available on Win10+, Mac, Linux)
        try {
            execSync(`tar -xf "${zipPath}" -C "${tempDir}"`);
        } catch (e) {
            // Fallback for older Windows without tar?
            if (process.platform === 'win32') {
                execSync(`powershell -c "Expand-Archive -Path '${zipPath}' -DestinationPath '${tempDir}' -Force"`);
            } else {
                throw e;
            }
        }

        // 4. Move to Final Location
        if (fs.existsSync(installDir)) {
            log(`[!] Removing existing installation...`, colors.yellow);
            fs.rmSync(installDir, { recursive: true, force: true });
        }

        // Find extracted folder (GitHub names it repo-branch, e.g. antigravity-jz-rm-main)
        const extractedName = fs.readdirSync(tempDir).find(n => {
            const fullPath = path.join(tempDir, n);
            return fs.statSync(fullPath).isDirectory() && n !== "__MACOSX";
        });

        if (!extractedName) {
            throw new Error("Could not find extracted folder in temporary directory.");
        }

        const sourcePath = path.join(tempDir, extractedName);
        fs.mkdirSync(path.dirname(installDir), { recursive: true });
        fs.renameSync(sourcePath, installDir);

        // 5. Cleanup
        fs.rmSync(tempDir, { recursive: true, force: true });

        // 6. Auto-Hydration (Sync Kits)
        const syncScript = path.join(installDir, '.agent', 'scripts', 'sync_kits.py');
        if (fs.existsSync(syncScript)) {
            log(`\n🔄 Auto-Hydrating Skills (Vudovn + Awesome Skills)...`, colors.cyan);
            try {
                // Check if python is available
                execSync('python --version', { stdio: 'ignore' });
                execSync(`python "${syncScript}"`, { stdio: 'inherit' });
            } catch (e) {
                log(`[!] Python not found or sync failed. Please run manually: python "${syncScript}"`, colors.yellow);
            }
        }

        // 7. Success
        log(`\n✅ Installation & Hydration Complete!`, colors.green);
        log(`📍 Location: ${installDir}`, colors.gray);
        log(`\n🚀 Next Steps:`, colors.cyan);

        if (process.platform === 'win32') {
            log(`\n🔗 Linking workspace...`, colors.cyan);
            const setupScript = path.join(installDir, 'scripts', 'setup_workspace.ps1');
            try {
                // Execute setup_workspace.ps1 in the current directory (process.cwd())
                execSync(`powershell -ExecutionPolicy Bypass -File "${setupScript}"`, {
                    stdio: 'inherit',
                    cwd: process.cwd()
                });
                log(`\n✨ Workspace initialized successfully!`, colors.green);
            } catch (e) {
                log(`[!] Auto-link failed. Please run manually:`, colors.yellow);
                log(`powershell -ExecutionPolicy Bypass -File "${setupScript}"`, colors.reset);
            }
        } else {
            log(`Run the setup script in your project folder.`, colors.yellow);
        }

    } catch (err) {
        log(`\n❌ Error: ${err.message}`, colors.red);
        if (err.stderr) log(err.stderr.toString(), colors.red);
        process.exit(1);
    }
}

main();
