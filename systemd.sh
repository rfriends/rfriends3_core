#!/bin/sh
#
# job systemd
#

cat <<EOF > $homedir/rfriends3/config/systemd.ini
; ----------------------------
; ジョブスケジューリング方式
; systemd.ini
; 2026/02/16 for arch linux
; ----------------------------
; cron_type_lnx
; = 0 cron  = 1 systemd
;
; at_type_lnx
; = 0 at  = 1 systemd
; ----------------------------
[systemd]
cron_type_lnx = 1
at_type_lnx = 1
; ----------------------------
EOF

loginctl enable-linger $user

exit 0
