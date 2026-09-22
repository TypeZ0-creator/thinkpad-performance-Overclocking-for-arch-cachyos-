# thinkpad-performance-governor-for-arch-cachyos-
An interactive performance toggle for Intel CPUs on CachyOS &amp; Arch Linux. Safely bypasses ThinkPad hardware throttling (BD_PROCHOT), resolves 2.0 GHz bottlenecks, and easily switches between a silent 2.20 GHz battery-saving mode and an unleashed 4.40 GHz gaming profile.
# ThinkPad Performance Governor for CachyOS

An automation utility tool designed to resolve the hard 2.0 GHz ceiling lock on Intel Core mobile processors running Linux.

## ✨ Features
* 🔍 **Hardware Detection:** Automatically reads your exact machine model via motherboard firmware.
* 🔋 **Power Save Mode:** Locks all threads at a strict 2.20 GHz cap to maximize battery and force dead-silent fans.
* 🎮 **Gaming Mode:** Unlocks the native 4.40 GHz peak boost clock, enforces the `performance` governor, and optimizes virtual memory.
* ⚡ **Overclock Tuning:** Clears motherboard register blocks (`0x1FC` BD_PROCHOT) and handles Lenovo-specific throttling quirks.
* 🧹 **Maintenance:** Single-click utility to flush RAM cache layers and run storage SSD TRIM passes.

## 🚀 Quick Setup
```bash
git clone https://github.com
cd YOUR_REPO_NAME
chmod +x perf_toggle.sh
sudo ./perf_toggle.sh
```
