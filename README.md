# thinkpad-performance-governor-for-arch-cachyos-
An interactive performance toggle for Intel CPUs on CachyOS &amp; Arch Linux. Safely bypasses ThinkPad hardware throttling (BD_PROCHOT), resolves 2.0 GHz bottlenecks, and easily switches between a silent 2.20 GHz battery-saving mode and an unleashed 4.40 GHz gaming profile.
# ThinkPad Performance Governor for CachyOS

An automation utility tool designed to resolve the hard 2.0 GHz ceiling lock on Intel Core mobile processors running Linux.

# ThinkPad Performance Governor for Arch & CachyOS

An interactive command-line control panel dashboard designed to override aggressive ThinkPad hardware firmware limits (`BD_PROCHOT`) and unlock performance scaling.

## ✨ Features
* 🔍 **Motherboard Integration:** Reads your exact machine type (`dmidecode`).
* 🔋 **Power Save Mode:** Locks all threads at a clean 2.20 GHz cap to enforce dead-silent laptop fans.
* 🎮 **Gaming Profile:** Unlocks native 4.40 GHz limits, modifies virtual software memory swappiness, and overrides motherboard limits.
* 🛡️ **Live Thermal Guard:** Actively tracks processor thermal sensors and auto-throttles the system down if it breaches 85°C.
* 🔔 **Desktop Notifications:** Reports real-time structural profile switches seamlessly over your visual workspace layout via `notify-send`.

## 🚀 Quick Setup

```bash
git clone https://github.com/TypeZ0-creator/thinkpad-performance-governor-for-arch-cachyos-.git
cd thinkpad-performance-governor-for-arch-cachyos-
chmod +x perf_toggle.sh
sudo ./perf_toggle.sh
```
copy this to see it worked
watch -n 0.5 "grep \"^[c]pu MHz\" /proc/cpuinfo"


