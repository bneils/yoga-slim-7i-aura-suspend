#!/usr/bin/env bash

PATH="/sbin:/bin:/usr/sbin:/usr/bin:/usr/local/bin"

block_on_sysclock() {
	# https://www.gnu.org/software/bash/manual/html_node/Bash-Variables.html
	# SECONDS - "The number of seconds at shell invocation and the current time
	# are always determined by querying the system clock at one-second resolution"
	block_time="$1"
	start="$SECONDS"
	while true; do
		diff="$((SECONDS-start))"
		if [ "$diff" -ge "$block_time" ]; then
			break
		fi
		sleep 0.5
	done
}


swapon -a

systemctl hibernate
echo "t=$SECONDS"
block_on_sysclock 15
echo "t=$SECONDS"

while ! swapoff -a; do
    echo "Swapoff failed. Retrying."
    sleep 1
done

echo Done
