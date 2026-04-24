#!/bin/sh
sudo mkdir -p /etc/systemd/system/apache2.service.d/
sudo cp apache2_override.conf /etc/systemd/system/apache2.service.d/override.conf
sudo systemctl daemon-reload
sudo systemctl restart apache2
