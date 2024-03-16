#!/bin/bash

tar -cvPf gathered.tar \
  /etc/fstab \
  /var/spool/cron/crontabs/root \
  /var/lib/docker-plugins/rclone/config/rclone.conf \

