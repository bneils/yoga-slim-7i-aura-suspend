#!/bin/bash

systemctl --user disable --now listen-suspend.service
sudo rm /usr/local/bin/listen-suspend /etc/systemd/user/listen-suspend.service
systemctl --user daemon-reload
