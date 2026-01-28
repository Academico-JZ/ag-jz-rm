#!/usr/bin/env python3
"""
Modular Workspace Linker - Antigravity JZ-RM
===========================================
Automatically provisions the .agent directory in a new workspace
by linking to the global Antigravity Kit.

Usage:
    python workspace_linker.py [target_path]
"""

import os
import sys
import shutil
from pathlib import Path

def get_global_kit_path():
    # Priority 1: Environment Variable
    env_path = os.environ.get("ANTIGRAVITY_KIT_PATH")
    if env_path:
        return Path(env_path)
    
    # Priority 2: Standard Location
    home = Path.home()
    standard_path = home / ".gemini" / "antigravity" / "kit"
    if standard_path.exists():
        return standard_path
        
    return None

def link_workspace(target_root):
    global_path = get_global_kit_path()
    
    if not global_path:
        print("❌ Error: Global Antigravity Kit not found.")
        print("👉 Run 'ag-jz-rm init' to provision the global system.")
        return False

    agent_path = target_root / ".agent"
    if not agent_path.exists():
        agent_path.mkdir(parents=True, exist_ok=True)
        print(f" [✨] Created workspace controller: {agent_path}")

    # Folders to synchronize
    resources = ["agents", "skills", "workflows", "scripts", ".shared"]
    
    for res in resources:
        src = global_path / res
        dest = agent_path / res
        
        if src.exists():
            print(f" [>] Synchronizing {res}...")
            if dest.exists():
                if dest.is_dir():
                    shutil.rmtree(dest)
                else:
                    dest.unlink()
            
            # Using copytree for maximum compatibility, although symlinks would be smaller
            shutil.copytree(src, dest)

    # 4. Identity & Governance (GEMINI.md)
    # The source should be in the global scripts folder or rules folder
    src_gemini = global_path / "rules" / "GEMINI.md"
    dest_rules = agent_path / "rules"
    dest_gemini = dest_rules / "GEMINI.md"
    
    if src_gemini.exists():
        dest_rules.mkdir(exist_ok=True)
        shutil.copy2(src_gemini, dest_gemini)
        print(" [🔭] Identity Protocols: Active")

    # 5. Neural Map Optimization
    indexer = agent_path / "scripts" / "generate_index.py"
    if indexer.exists():
        import subprocess
        print(" [✨] Optimizing Neural Map...")
        subprocess.run([sys.executable, str(indexer)], capture_output=True)

    print(f"\n🌌  LINK SUCCESSFUL — {target_root.name} is now ONLINE")
    return True

if __name__ == "__main__":
    target = Path(".").resolve()
    if len(sys.argv) > 1:
        target = Path(sys.argv[1]).resolve()
        
    success = link_workspace(target)
    sys.exit(0 if success else 1)
