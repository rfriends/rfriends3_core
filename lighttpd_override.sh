#!/bin/sh
sudo mkdir -p /etc/systemd/system/lighttpd.service.d/
sudo cp override.conf /etc/systemd/system/lighttpd.service.d/override.conf
sudo systemctl daemon-reload
sudo systemctl restart lighttpd
