#!/bin/bash

[ -f .env ] && source .env

[ -z "$ZULIP_POSTGRESS_PASS" ] && echo "ZULIP_POSTGRESS_PASS="$(openssl rand -base64 15) >> .env
[ -z "$ZULIP_MEMCACHED_PASS" ] && echo "ZULIP_MEMCACHED_PASS="$(openssl rand -base64 15) >> .env
[ -z "$ZULIP_RABBITMQ_PASS" ] && echo "ZULIP_RABBITMQ_PASS="$(openssl rand -base64 15) >> .env
[ -z "$ZULIP_REDIS_PASS" ] && echo "ZULIP_REDIS_PASS="$(openssl rand -base64 15) >> .env
[ -z "$ZULIP_SECRET_KEY" ] && echo "ZULIP_SECRET_KEY="$(openssl rand -base64 15) >> .env
