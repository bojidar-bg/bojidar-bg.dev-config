https://zulip.readthedocs.io/en/stable/production/deployment.html#zulip-in-docker

https://github.com/nginx-proxy/nginx-proxy

https://github.com/nginx-proxy/acme-companion

Crontab config at `/var/spool/cron/crontabs/root`:
```cron
0 0 * * * "/root/backup.sh" > /dev/null 2>&1
```

Rclone config at `/var/lib/docker-plugins/rclone/config/rclone.conf`:
```ini
[storagebox]
type = sftp
host = uXXXXXX.your-storagebox.de
user = uXXXXXX
port = 23
key_file = /data/config/id_rsa
shell_type = unix
md5sum_command = md5 -r
sha1sum_command = sha1 -r
```

`/var/lib/docker-plugins/rclone/config/id_rsa` is the key used to access the storagebox.
