This is a script meant to enhance standby power efficiency when suspend is not in-use for the Lenovo Yoga Slim 7i Aura. This is work based on the script provided by [Daniel-42-z](https://github.com/Daniel-42-z/lenovo-yoga-sleep-wake-scripts), but has been heavily modified since then. Suspend, hibernate, and lock behavior should be disabled in Plasma's settings.

# Motivation
Entering suspend on most Lunar Lake devices results in the keyboard backlight and fans becoming unresponsive, requiring a restart. 

# Supported Devices
* Lenovo Yoga Slim 7i Aura (15ILL9)
* OS: OpenSUSE Tumbleweed (kernel 6.16.3-1-default) and KDE Plasma (6.4.4)
* Swap: 16 GB / 32 GB depending on your RAM size

# Hibernation with temporary swap
If you have a swap partition, but don't enable it, you must enable the setuid bit for `swapon` and `swapoff` using `sudo chmod u+s /sbin/swapon /sbin/swapoff`. Verify this with `ls -l /sbin/swapon /sbin/swapoff` by looking for `rws`. **Warning**: This action has risks, since now any user can modify your swap! This shouldn't matter though for single-user systems (such as laptops). Make sure to verify that this script's use of `swapon` and `swapoff` is OK for your system, and modify if needed.

# Warnings
Running this script without understanding how it works can result in your system being soft bricked, requiring a restart. Please test this script first. This script is a **work in progress** and does not provide a warranty. Make sure you have enough swap for hibernation or that you disable the feature.

# How it works
When `dbus` detects that your lid has closed it will turn the screen off using `kscreen-doctor`, lock your session, disable all radios using `rfkill`, and switch off the keyboard backlight. When `dbus` receives an "open lid" event it will restore the previous state of your radios and switch your screen back on. Whether it is able to restore the keyboard backlight is finnicky and may not work every time due to firmware.

The script is configured to wait a custom amount of time *off the plug* before hibernating in this state. That time starts when you unplug from AC and resets when you plug back in. I haven't thoroughly tested this but it should work. This feature was added to limit the use of hibernation to long-term breaks.

# Results
With the CPU at idle and everything off, I measured about 1 watt being discharged from the battery. With hibernation set to kick in after 30 minutes, this is about 0.5 watt-hours lost or 0.7% of your battery charge.
