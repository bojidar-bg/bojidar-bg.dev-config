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
