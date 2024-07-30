#!/bin/bash

[ -f .env ] && source .env

[ -z "$ZULIP_POSTGRESS_PASS" ] && echo "ZULIP_POSTGRESS_PASS="$(openssl rand -base64 15) >> .env ### docker exec zulip-postgres bash -c $'psql -U"$POSTGRES_USER" -c "ALTER ROLE $POSTGRES_USER  WITH PASSWORD \'$POSTGRES_PASSWORD\';"'
[ -z "$ZULIP_MEMCACHED_PASS" ] && echo "ZULIP_MEMCACHED_PASS="$(openssl rand -base64 15) >> .env
[ -z "$ZULIP_RABBITMQ_PASS" ] && echo "ZULIP_RABBITMQ_PASS="$(openssl rand -base64 15) >> .env
[ -z "$ZULIP_REDIS_PASS" ] && echo "ZULIP_REDIS_PASS="$(openssl rand -base64 15) >> .env
[ -z "$ZULIP_SECRET_KEY" ] && echo "ZULIP_SECRET_KEY="$(openssl rand -base64 15) >> .env
[ -z "$ZULIP_LLDAP_PASSWORD" ] && echo "ZULIP_LLDAP_PASSWORD="$(openssl rand -base64 15) >> .env

[ -z "$LLDAP_JWT_SECRET" ] && echo "LLDAP_JWT_SECRET="$(openssl rand -base64 15) >> .env
[ -z "$LLDAP_KEY_SEED" ] && echo "LLDAP_KEY_SEED="$(openssl rand -base64 15) >> .env

[ -z "$JITSI_JICOFO_PASS" ] && echo "JITSI_JICOFO_PASS="$(openssl rand -base64 15) >> .env
[ -z "$JITSI_JVB_PASS" ] && echo "JITSI_JVB_PASS="$(openssl rand -base64 15) >> .env
[ -z "$JITSI_JIGASI_PASS" ] && echo "JITSI_JIGASI_PASS="$(openssl rand -base64 15) >> .env
[ -z "$JITSI_RECORDER_PASS" ] && echo "JITSI_RECORDER_PASS="$(openssl rand -base64 15) >> .env
[ -z "$JITSI_JIBRI_PASS" ] && echo "JITSI_JIBRI_PASS="$(openssl rand -base64 15) >> .env
[ -z "$JITSI_LDAP_PASSWORD" ] && echo "JITSI_LDAP_PASSWORD="$(openssl rand -base64 15) >> .env

[ -z "$VIDEOS_OLD_PASSWORD" ] && echo "VIDEOS_OLD_PASSWORD="$(openssl rand -base64 15) >> .env

[ -z "$BORG_PASSPHRASE" ] && echo "BORG_PASSPHRASE="$(openssl rand -base64 15) >> .env
[ -z "$STORAGEBOX_USER" ] && echo "WARNING, missing STORAGEBOX_USER in .env"
