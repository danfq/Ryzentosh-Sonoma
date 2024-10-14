# DanFQ 2024
#!/bin/bash

# Navigate to Discord Directory
cd /Applications/Discord.app/Contents/MacOS

# Create MKL-Safe Launch Script
echo "MKL_DEBUG_CPU_TYPE=5 ./Discord" > discord_
echo "[+] Created MKL-Safe Launch Script.\n"

# Make Launch Script Executable
chmod +x discord_
echo "[*] Made Launch Script Executable.\n"

# Set New Launch Script
/usr/libexec/PlistBuddy -c "Set :CFBundleExecutable discord_" /Applications/Discord.app/Contents/Info.plist
echo "[+] Set New Launch Script.\n"

# Close Discord
pkill -f Discord
echo "[*] Closing Discord.\n"

# Re-open Discord
echo "[+] Opening Discord...\n"
sleep 4
open /Applications/Discord.app

# Notify User
echo "\n[+] Discord Ryzentosh Fix Applied!"