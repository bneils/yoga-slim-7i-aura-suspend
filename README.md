Enhance powered-on idle behavior when suspend is disabled for the Lenovo Yoga Slim 7i Aura.
Provides options to enter hibernation when the lid is closed.
This is work based on the script provided by [Daniel-42-z](https://github.com/Daniel-42-z/lenovo-yoga-sleep-wake-scripts), but has been heavily modified since then.
Currently, this script is not much better than 

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
If you are in the subset of users who want hibernation but don't want your swap partition being active, then you must enable the setuid bit for `swapon` and `swapoff` using `sudo chmod u+s /sbin/swapon /sbin/swapoff`.
Verify this with `ls -l /sbin/swapon /sbin/swapoff` by looking for `rws`.
**Warning**: This action has risks, since now any user can modify your swap! This shouldn't matter though for single-user systems (such as laptops).
Make sure to verify that this script's use of `swapon` and `swapoff` is OK for your system, and modify if needed.
If you are doing this, make sure to [disable swap on startup](https://unix.stackexchange.com/questions/416653/how-to-disable-swap-from-starting-up-on-boot).

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
Since nothing in userspace is actually paused, this isn't much better than just letting your laptop screen turn off.

# Warnings
Running this script without understanding how it works can result in your system being soft bricked, requiring a restart.
Please test this script first in a safe environment.
This script is a **work in progress** and does not provide a warranty.
Make sure you have enough swap for hibernation or that you disable the feature (test run `systemctl hibernate` once).
