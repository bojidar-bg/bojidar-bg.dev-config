# [bojidar-bg.dev](https://bojidar-bg.dev/) Hetzner config

Configuration for the deployment of *.bojidar-bg.dev, with the exception of the main bojidar-bg.dev domain.

Most of the software deployed there has to do with the [small programming course](https://bojidar-bg.dev/курс/) I'm running. Feel free to adapt it at your own risk: this software is provided "as is" with no warranty of any kind, under the MIT/Expat license.

## Architecture

### Git repositories

The server is a Hetzner CAX11 instance running Arm64 Debian. It's `/root/` folder is this Git repository. In addition, the `/var/local/gitrepo` folder holds a bare Git repository, allowing me to push to the server using Git directly.

Both repositories on the server have the Git hooks from `hooks/` installed; with these, pushing a commit would result in a pull of the `/root/` repo, and from there, a run of the `./gen-passwords.sh` script and an update of docker compose configuration.

The hooks are installed by:
```bash
cd .git/hooks/
ln -s ../../hooks/* .
```

As such, after committing a change, deployment is as easy as:
```bash
# git remote add deploy ssh://USER@bojidar-bg.dev/var/local/gitrepo
git push deploy
```

### Secrets management

The `./gen-passwords.sh` script is in charge of generating new secrets whenever they are neccessary. They are stored in `.env`, and this makes `.env` one of the two important files to keep private—the other being `/root/.ssh/id_rsa`, the server's SSH key.

If you set something similar up, **make sure** to back up `BORG_PASSPHRASE` from `.env` somewhere, as without it, you would not be able to read the backup that includes `.env`.

### Docker compose

Docker compose files are use to configure a number of services, but most importantly, [`nginxproxy`](https://github.com/nginx-proxy/nginx-proxy) with [`acme-companion`](https://github.com/nginx-proxy/acme-companion). These two allow us to automatically configure new subdomains and route traffic to them by simply defining the `VIRTUAL_HOST` environment variable on a container.

Other services include a mailserver via [`docker-mailserver`](https://github.com/docker-mailserver/docker-mailserver), used to receive and (soon) send mail, LDAP via [`lldap`](https://github.com/lldap/lldap), used for syncing logins across services, and a Zulip chat instance using [`docker-zulip`](https://zulip.readthedocs.io/en/stable/production/deployment.html#zulip-in-docker), for communicating with people.

A lot of those are included as submodules as well, in order to version them, and to build my own versions from source (sometimes a neccessity, as CAX11 is Arm64-based, and not all projects ship images for this architecture).

### Backups

Backups are configured using `borg` and a Hetzner storagebox, following [this Hetzner community tutorial](https://community.hetzner.com/tutorials/install-and-configure-borgbackup). The borg passphrase, `BORG_PASSPHRASE`, and the storagebox username, `STORAGEBOX_USER`, are configured in `.env`

If you set something similar up, **make sure** to back up `BORG_PASSPHRASE` from `.env` somewhere separatelly, as without it, you would not be able to read the backup if things go wrong.

Backups are also configured to use crontab. This is currently a manual step of the installation, at least, until I start needing to reinstall the server every few months. Crontab config at `/var/spool/cron/crontabs/root`:

```crontab
0 0 * * * "/root/backup.sh" > /dev/null 2>&1
```

This runs the backup script daily.

### External storage

For storing videos for the course, I decided to use the same Hetzner storagebox, with [Rclone](https://rclone.org), following the [Hetzner documentation](https://docs.hetzner.com/robot/storage-box/access/access-ssh-rsync-borg/#rclone), and with the [Rclone Docker volume plugin](https://rclone.org/docker/).

To install the rclone volume plugin, I used something like:
```bash
mkdir -p /var/lib/docker-plugins/rclone/{config,cache}
# cp /root/.config/rclone/rclone.conf /var/lib/docker-plugins/rclone/config 
cp /root/.ssh/id_rsa /var/lib/docker-plugins/rclone/config/id_rsa
docker plugin install rclone/docker-volume-rclone:arm64 args="-v" --alias rclone --grant-all-permissions
```

And here are the contents of the Rclone config at `/var/lib/docker-plugins/rclone/config/rclone.conf`:

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

### Logging

Currently, some tiny bit of care has been taken to not log visitors' IP addresses, but I have not investigated logging any further. Docker logs are not a good place for logs to go, so this will have to be fixed at some point.

Ideally, I will have a way to both not log IP addresses and get some basic analytics for when I port the main bojidar-bg.dev domain over to the Hetzner box.
