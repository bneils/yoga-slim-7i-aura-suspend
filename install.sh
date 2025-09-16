#!/bin/bash

sudo cp listen-suspend /usr/local/bin/
sudo cp listen-suspend.service /etc/systemd/user

systemctl --user daemon-reload
systemctl --user enable --now listen-suspend.service
