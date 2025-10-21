Enhance powered-on idle behavior when suspend is disabled for the Lenovo Yoga Slim 7i Aura.
Provides options to enter hibernation when the lid is closed.
This is work based on the script provided by [Daniel-42-z](https://github.com/Daniel-42-z/lenovo-yoga-sleep-wake-scripts), but has been heavily modified since then.
Power efficiency gains are not much better than just leaving your computer on, but can still limit lost energy.

# Setup instructions
* Disable suspend, hibernate, and lock behavior in Plasma's settings.
* Modify globals in `listen-suspend` then run `install.sh` to create the systemd service.
* If you configured the script to enter hibernation, then allocate a swap paging file.

# Motivation
Entering suspend (s2idle) on LNL causes several issues with devices not functioning on resume, like the keyboard backlight and fans.
See the following issues:
* [Lenovo Yoga Slim 7i Aura 15ILL9: fans don't turn on after sleep/resume](https://bbs.archlinux.org/viewtopic.php?id=306675)
* [Lenovo Yoga Slim 15ILL9 fans completely stop working after suspend/resume cycle, causing dangerous overheating](https://bugzilla.kernel.org/show_bug.cgi?id=220505)
* [Lenovo Yoga Slim Aura Edition: Keyboard backlight broken after suspend](https://bbs.archlinux.org/viewtopic.php?id=305118)

# Supported Devices
* Lenovo Yoga Slim 7i Aura (15ILL9)
* OS: OpenSUSE Tumbleweed (kernel 6.16) and KDE Plasma (6.4.4)

# Hibernation with temporary swap
If you are in the subset of users who want hibernation but don't want your swap partition being active, then you must fiddle with the sudoers file.
I previously recommended to modify the SUID bit, but this changes between upgrades.
First, [disable swap on startup](https://unix.stackexchange.com/questions/416653/how-to-disable-swap-from-starting-up-on-boot).

1. Change the value of `SWAP_DEV` in the script to your swap device (e.g. `"UUID=12abfd6c-9398-462d-81d3-5c4556a6809d"`, `"/dev/sdX"`) and test it.
2. Run `groups` then check if you are `sudo`, `wheel`, or neither.
3. Run `usermod -aG wheel $USER`
4. Reboot.
5. Run `sudo visudo -f /etc/sudoers.d/swapon`.
Make sure this file doesn't contain periods!
Additionally, make sure this file gets imported by the main `/etc/sudoers` file.
6. Add `%wheel ALL=(root) NOPASSWD: /usr/sbin/swapon`.
7. Add `%wheel ALL=(root) NOPASSWD: /usr/sbin/swapoff`.
8. You can test whether this worked by opening a new terminal and typing `SWAP_DEV="..." sudo swapon "$SWAP_DEV"` as this is exactly how it will appear in the script.

Translation: all users in group `wheel` on all hosts may run as root the program `swapon` without providing a password.

Make sure to verify that this script's use of `swapon` and `swapoff` is OK for your system, and modify if needed.

# Specify always-on hours with cron
Use `extend-timer` to delay the script's hibernation timer.
Relies on a shared memory file in `/dev/shm` to send signals to the main script.
See `extend-timer` for instructions on how this works.

# How it works
When `dbus` detects that your lid has closed it will turn the screen off using `kscreen-doctor`, lock your session, disable all radios using `rfkill`, and switch off the keyboard backlight. 
When `dbus` receives an "open lid" event it will restore the previous state of your radios and switch your screen back on.
Whether it is able to restore the keyboard backlight is finnicky and may not work every time due to firmware.

The script is configured to wait a custom amount of time *off the plug* before hibernating in this state.
That time starts when you unplug from AC and resets when you plug back in.
I haven't thoroughly tested this but it should work.
This feature was added to limit the use of hibernation to long-term breaks.

# Results
With the CPU at idle and everything off, I measured about 1 watt being discharged from the battery.
With hibernation set to kick in after 30 minutes, this is about 0.5 watt-hours lost or 0.7% of your battery charge.
Since nothing in userspace is actually paused, this isn't much better than just letting your laptop screen turn off automatically, but at least limits the CPU utilization of networked programs.

# Warnings
Running this script without understanding how it works can result in your system being soft bricked, requiring a restart.
Please test this script first in a safe environment.
This script is a **work in progress** and does not provide a warranty.
Make sure you have enough swap for hibernation or that you disable the feature (test run `systemctl hibernate` once).
