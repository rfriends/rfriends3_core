#!/bin/sh
sudo mkdir -p /etc/systemd/system/httpd.service.d/
sudo cp apache2_override.conf /etc/systemd/system/httpd.service.d/override.conf
sudo systemctl daemon-reload
sudo systemctl restart httpd
