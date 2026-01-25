#!/usr/bin/env node
const child = spawn('pwsh', ['-ExecutionPolicy', 'Bypass', '-File', psFile, ...args], {
    stdio: 'inherit' // Pipe I/O directly to parent process
});

child.on('error', (err) => {
    console.error('Failed to start subprocess:', err);
    console.log('Trying with "powershell" instead of "pwsh"...');
    // Fallback to older powershell if pwsh missing
    const childFallback = spawn('powershell', ['-ExecutionPolicy', 'Bypass', '-File', psFile, ...args], {
        stdio: 'inherit'
    });
    childFallback.on('exit', (code) => process.exit(code));
});

child.on('exit', (code) => {
    process.exit(code);
});
