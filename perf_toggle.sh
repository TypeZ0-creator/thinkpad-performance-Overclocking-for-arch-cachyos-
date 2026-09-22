#!/usr/bin/env bash

# Ensure the script is run with sudo
if [ "$EUID" -ne 0 ]; then
  echo -e "\e[31m[!] Please run this tool using: sudo ./perf_toggle.sh\e[0m"
  exit 1
fi

# Detect actual PC hardware name
PC_NAME=$(dmidecode -s system-product-name 2>/dev/null | xargs)
[ -z "$PC_NAME" ] && PC_NAME="Linux Machine"

# Find local logged-in user to send desktop notifications correctly over X11/Wayland
REAL_USER=$(loginctl list-users | awk 'NR==2 {print $2}')
USER_ID=$(id -u "$REAL_USER")

send_notification() {
  local title="$1"
  local msg="$2"
  local icon="$3"
  if [ -n "$REAL_USER" ]; then
    sudo -u "$REAL_USER" DBUS_SESSION_BUS_ADDRESS="unix:path=/run/user/$USER_ID/bus" notify-send -i "$icon" "$title" "$msg" 2>/dev/null
  fi
}

# Fetch CPU core count dynamically
CORES=$(nproc)

set_power_save() {
  echo -e "\n\e[33m[+] Activating 2.20 GHz Power Save Mode...\e[0m"
  systemctl stop throttled.service 2>/dev/null
  for i in $(seq 0 $((CORES-1))); do
    echo "powersave" > /sys/devices/system/cpu/cpu$i/cpufreq/scaling_governor 2>/dev/null
    echo "balance_power" > /sys/devices/system/cpu/cpu$i/cpufreq/energy_performance_preference 2>/dev/null
    echo "2200000" > /sys/devices/system/cpu/cpu$i/cpufreq/scaling_max_freq 2>/dev/null
  done
  send_notification "Power Manager" "Locked at 2.20 GHz (Silent Profile)" "battery"
  echo -e "\e[32m[✓] Locked at 2.20 GHz. Fans will be silent and battery maximized!\e[0m"
}

set_gaming_mode() {
  echo -e "\n\e[34m[+] Activating 4.40 GHz Gaming Mode...\e[0m"
  for i in $(seq 0 $((CORES-1))); do
    echo "performance" > /sys/devices/system/cpu/cpu$i/cpufreq/scaling_governor 2>/dev/null
    echo "performance" > /sys/devices/system/cpu/cpu$i/cpufreq/energy_performance_preference 2>/dev/null
    cat /sys/devices/system/cpu/cpu$i/cpufreq/cpuinfo_max_freq > /sys/devices/system/cpu/cpu$i/cpufreq/scaling_max_freq 2>/dev/null
  done
  modprobe msr 2>/dev/null
  wrmsr -a 0x1FC 0x24005a 2>/dev/null
  systemctl start throttled.service 2>/dev/null
  sysctl -w vm.swappiness=10 >/dev/null
  send_notification "Performance Engine" "4.40 GHz Gaming Profile Unleashed" "applications-games"
  echo -e "\e[32m[✓] Unlocked up to 4.40 GHz. Hardware caps cleared!\e[0m"
}

set_overclock() {
  echo -e "\n\e[31m[⚠️] INITIALIZING OVERCLOCK MODE...\e[0m"
  for i in $(seq 0 $((CORES-1))); do
    echo "performance" > /sys/devices/system/cpu/cpu$i/cpufreq/scaling_governor 2>/dev/null
    echo "performance" > /sys/devices/system/cpu/cpu$i/cpufreq/energy_performance_preference 2>/dev/null
    cat /sys/devices/system/cpu/cpu$i/cpufreq/cpuinfo_max_freq > /sys/devices/system/cpu/cpu$i/cpufreq/scaling_max_freq 2>/dev/null
  done
  modprobe msr 2>/dev/null
  wrmsr -a 0x1FC 0x24005a 2>/dev/null
  systemctl start throttled.service 2>/dev/null
  sysctl -w kernel.nmi_watchdog=0 >/dev/null
  sysctl -w kernel.sched_migration_cost_ns=5000000 >/dev/null
  send_notification "Overclock Alert" "Max TDP and aggressive registers enabled!" "dialog-warning"
  echo -e "\e[1;31m[✓] OVERCLOCK PROFILE ACTIVE: Watch your temps!\e[0m"
}

# Automated CLI parsing flag option for systemd auto-boot
if [ "$1" == "--boot-gaming" ]; then
  set_gaming_mode
  exit 0
elif [ "$1" == "--boot-save" ]; then
  set_power_save
  exit 0
fi

# Standard Dashboard Interface
clear
echo -e "\e[1;36m====================================================\e[0m"
echo -e "\e[1;32m   CachyOS Performance Control Panel Pro\e[0m"
echo -e "\e[1;34m   Device Detected: $PC_NAME\e[0m"
echo -e "\e[1;36m====================================================\e[0m"
echo -e " 1) [🔋] 2.20 GHz Power Save Mode (Silent & Cool)"
echo -e " 2) [🎮] 4.40 GHz Gaming Mode (Unleash CPU)"
echo -e " 3) [⚡] OVERCLOCK MODE (Max TDP Profile)"
echo -e " 4) [🧹] Quick System Clean (Optimize Memory & Cache)"
echo -e " 5) [🛡️] Start Live Thermal Safety Watchdog Guard"
echo -e " 6) [❌] Exit"
echo -e "\e[1;36m====================================================\e[0m"
read -p "Select an option [1-6]: " CHOICE

case $CHOICE in
  1) set_power_save ;;
  2) set_gaming_mode ;;
  3) set_overclock ;;
  4)
    echo -e "\n\e[35m[🧹] Optimizing caches...\e[0m"
    sync && echo 3 > /proc/sys/vm/drop_caches
    fstrim -av 2>/dev/null
    send_notification "System Maintenance" "RAM caches flushed & SSD TRIM run successfully" "utilities-terminal"
    echo -e "\e[32m[✓] System cleanup successful!\e[0m"
    ;;
  5)
    echo -e "\n\e[31m[🛡️] Thermal Monitor Active... Press [Ctrl+C] to stop.\e[0m"
    send_notification "Safety System" "Live Core Thermal Monitor Engaged" "security-high"
    while true; do
      TEMP=$(cat /sys/class/thermal/thermal_zone0/temp 2>/dev/null)
      TEMP_C=$((TEMP / 1000))
      if [ "$TEMP_C" -gt 85 ]; then
        echo -e "\e[31m[⚠️] Alert: CPU hit ${TEMP_C}°C! Emergency safety step down to 2.20 GHz applied!\e[0m"
        send_notification "THERMAL CRITICAL" "CPU Hit ${TEMP_C}°C! Dropping to Power Save mode." "dialog-error"
        set_power_save
        sleep 30
      fi
      sleep 2
    done
    ;;
  6) exit 0 ;;
  *) echo -e "\n\e[31m[-] Invalid choice.\e[0m" ;;
esac
