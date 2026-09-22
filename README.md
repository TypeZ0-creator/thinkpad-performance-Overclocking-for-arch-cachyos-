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

---

## 🔍 How to Verify the Unlocked Overclock Mode

Because Intel CPUs scale down dynamically when sitting idle to save power, you must monitor your hardware while running a short workload to verify that the restriction is lifted.

### Step 1: Open a Live Clock Speed Monitor
Open a terminal window and run this command to watch your raw CPU core frequencies update live every 0.5 seconds:
```bash
watch -n 0.5 "grep \"^[c]pu MHz\" /proc/cpuinfo"
```

### Step 2: Trigger a Hardware Workload
Open a second terminal window, select **Option 3 (OVERCLOCK MODE)** in the script, and install a lightweight stress tool:
```bash
sudo pacman -S stress
```
Now, force a heavy math load across all 8 processing threads for 15 seconds:
```bash
stress --cpu 8 --timeout 15
```

### Step 3: Analyze the Outputs
While the stress test runs, look back at your first monitoring window. Your profile is verified as successful if:
1. **The 2.0 GHz Ceiling is Broken:** All 8 threads instantly surge well past 2000 MHz, maintaining heavy all-core target clocks between **3800 MHz and 4200 MHz**.
2. **No Low Drop Valleys:** The notorious Lenovo 400 MHz micro-stutter valleys are completely eliminated.
3. **Register Level Confirmation:** Run `sudo rdmsr -a 0x1FC`. If every single thread outputs **`24005a`** (ending in the even character `a`), the hardware-level `BD_PROCHOT` throttle flag has been completely bypassed.



