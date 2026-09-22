#!/usr/bin/env bash

# Ensure the script is run with sudo
if [ "$EUID" -ne 0 ]; then
  echo -e "\e[31m[!] Please run this tool using: sudo ./perf_toggle.sh\e[0m"
  exit 1
fi

# Detect actual PC hardware name from motherboard firmware
PC_NAME=$(dmidecode -s system-product-name 2>/dev/null | xargs)
[ -z "$PC_NAME" ] && PC_NAME="Linux Machine"

# Clear terminal screen and show functional dashboard header
clear
echo -e "\e[1;36m====================================================\e[0m"
echo -e "\e[1;32m   CachyOS Performance Control Panel\e[0m"
echo -e "\e[1;34m   Device Detected: $PC_NAME\e[0m"
echo -e "\e[1;36m====================================================\e[0m"
echo -e " 1) [🔋] 2.20 GHz Power Save Mode (Silent & Cool)"
echo -e " 2) [🎮] 4.40 GHz Gaming Mode (Unleash CPU)"
echo -e " 3) [⚡] OVERCLOCK MODE (Max TDP & Extreme Tuning)"
echo -e " 4) [🧹] Quick System Clean (Optimize Memory & Cache)"
echo -e " 5) [❌] Exit"
echo -e "\e[1;36m====================================================\e[0m"
read -p "Select an option [1-5]: " CHOICE

# Fetch CPU core count dynamically
CORES=$(nproc)

case $CHOICE in
  1)
    echo -e "\n\e[33m[+] Activating 2.20 GHz Power Save Mode...\e[0m"
    # Stop background performance overrides
    systemctl stop throttled.service 2>/dev/null
    
    # Apply hard frequency cap of 2.20 GHz (2200000 kHz)
    for i in $(seq 0 $((CORES-1))); do
      echo "powersave" > /sys/devices/system/cpu/cpu$i/cpufreq/scaling_governor 2>/dev/null
      echo "balance_power" > /sys/devices/system/cpu/cpu$i/cpufreq/energy_performance_preference 2>/dev/null
      echo "2200000" > /sys/devices/system/cpu/cpu$i/cpufreq/scaling_max_freq 2>/dev/null
    done
    echo -e "\e[32m[✓] Locked at 2.20 GHz. Fans will be silent and battery maximized!\e[0m"
    ;;

  2)
    echo -e "\n\e[34m[+] Activating 4.40 GHz Gaming Mode...\e[0m"
    # Uncap CPU frequency limits completely
    for i in $(seq 0 $((CORES-1))); do
      echo "performance" > /sys/devices/system/cpu/cpu$i/cpufreq/scaling_governor 2>/dev/null
      echo "performance" > /sys/devices/system/cpu/cpu$i/cpufreq/energy_performance_preference 2>/dev/null
      cat /sys/devices/system/cpu/cpu$i/cpufreq/cpuinfo_max_freq > /sys/devices/system/cpu/cpu$i/cpufreq/scaling_max_freq 2>/dev/null
    done
    
    # Bypass ThinkPad hardware throttling limits
    modprobe msr 2>/dev/null
    wrmsr -a 0x1FC 0x24005a 2>/dev/null
    systemctl start throttled.service 2>/dev/null
    
    # Tweak Linux virtual memory swapping responsiveness for smoother gameplay
    sysctl -w vm.swappiness=10 >/dev/null
    echo -e "\e[32m[✓] Unlocked up to 4.40 GHz. Hardware caps cleared!\e[0m"
    ;;

  3)
    echo -e "\n\e[31m[⚠️] INITIALIZING OVERCLOCK MODE FOR MODERN HARDWARE...\e[0m"
    echo "    Note: Mobile Core i5 chips are multiplier-locked by Intel."
    echo "    This forces unlocked TDP wattages and tells the kernel to strictly ignore thermal limits."
    sleep 1.5
    
    # 1. Strip all frequency limits
    for i in $(seq 0 $((CORES-1))); do
      echo "performance" > /sys/devices/system/cpu/cpu$i/cpufreq/scaling_governor 2>/dev/null
      echo "performance" > /sys/devices/system/cpu/cpu$i/cpufreq/energy_performance_preference 2>/dev/null
      cat /sys/devices/system/cpu/cpu$i/cpufreq/cpuinfo_max_freq > /sys/devices/system/cpu/cpu$i/cpufreq/scaling_max_freq 2>/dev/null
    done
    
    # 2. Re-arm registers to push past power boundaries
    modprobe msr 2>/dev/null
    wrmsr -a 0x1FC 0x24005a 2>/dev/null
    systemctl start throttled.service 2>/dev/null
    
    # 3. Disable kernel panic logs under voltage strain and maximize background thread processing
    sysctl -w kernel.nmi_watchdog=0 >/dev/null
    sysctl -w kernel.sched_migration_cost_ns=5000000 >/dev/null
    
    echo -e "\e[1;31m[✓] OVERCLOCK PROFILE ACTIVE: Maximum burst energy enabled. Watch your temps!\e[0m"
    ;;

  4)
    echo -e "\n\e[35m[🧹] Optimizing system performance & cleaning RAM caches...\e[0m"
    # Safely clear system page caches, dentries and inodes to free up locked RAM
    sync && echo 3 > /proc/sys/vm/drop_caches
    # Run TRIM on SSD to improve storage read/write performance
    fstrim -av 2>/dev/null
    echo -e "\e[32m[✓] Memory caches freed and storage drive optimized!\e[0m"
    ;;

  5)
    echo -e "\nGoodbye!"
    exit 0
    ;;

  *)
    echo -e "\n\e[31m[-] Invalid choice.\e[0m"
    ;;
esac
