#!/usr/bin/env bash

##
## Set environment variables
##

# export BORG_RSH='ssh -i /home/userXY/.ssh/id_ed25519'

export BORG_PASSPHRASE='REMOVED_1'

LOG='/var/log/borg/backup.log'
export REPOSITORY_DIR=`hostname`
export REPOSITORY="ssh://uXXXXXX@uXXXXXX.your-storagebox.de:23/./backups/${REPOSITORY_DIR}"

exec > >(tee -i ${LOG})
exec 2>&1

echo "###### Backup started: $(date) ######"


echo "Transfer files ..."
borg create -v --stats                   \
    $REPOSITORY::'{now:%Y-%m-%d_%H:%M}'  \
    /var/lib/docker/volumes              \
    /root/.env                           \

echo "###### Backup ended: $(date) ######"
