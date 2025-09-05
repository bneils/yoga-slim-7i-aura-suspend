This is a script meant to mitigate suspend issues for the Lenovo Yoga Slim 7i Aura. This is work based on the script provided by [Daniel-42-z](https://github.com/Daniel-42-z/lenovo-yoga-sleep-wake-scripts), but has been heavily modified since then. Suspend and lock behavior should be disabled in Plasma's settings.

# Supported Devices
* Lenovo Yoga Slim 7i Aura (15ILL9)
* OS: OpenSUSE Tumbleweed (kernel 6.16.3-1-default) and KDE Plasma (6.4.4)

# Warnings
Running this script without inspecting the entire script in full, and understanding it, can result in your system being soft bricked, requiring a restart. This script is a **work in progress**, and is not currently fully functional. It may also not work all the time. There is no warranty provided.

# Benefits
Without SIGSTOP being sent to processes, I've already seen a 1W battery discharge with this script in-use.
