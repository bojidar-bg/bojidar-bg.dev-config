#!/bin/bash

set -e

for i in "$@"; do
  case $i in
    --dry-run)
      DRY_RUN=true
      ;;
    -*|--*)
      echo "Unknown option $i"
      exit 1
      ;;
    *)
      echo "Unknown argument $i"
      ;;
  esac
  shift
done

get_image_tags() {
  sleep 1 # Delay requests because docker.io doesn't like us otherwise
  until skopeo list-tags docker://$1; do sleep 2; done | jq -r '.Tags[]'
}
get_repo_tags() {
  git fetch --tags -q
  git tag -l
}
update_repo_tag() {
  read TAG
  [ -z $DRY_RUN ] && git checkout $TAG -q
  echo $TAG "# via $(basename $(pwd)) repo"
}

generate-config-env() {
  echo '# Docker mailserver'

  echo -n 'DOCKER_MAILSERVER_VERSION='
  get_image_tags mailserver/docker-mailserver | sort -t. -k1,1 -k2,2 -k3,3 -n -r | head -n 1

  echo '# Nginx proxy'

  echo -n 'NGINX_VERSION='
  get_image_tags nginx | grep -- '-alpine$' | sort -t. -k1,1 -k2,2 -k3,3 -n -r | head -n 1

  echo -n 'NGINX_PROXY_VERSION='
  (cd nginx-proxy; get_repo_tags | sort -t. -k1,1 -k2,2 -k3,3 -n -r | head -n 1 | update_repo_tag)

  echo -n 'NGINX_PROXY_ACME_COMPAION_VERSION='
  (cd acme-companion; get_repo_tags | sort -t. -k1.2,1 -k2,2 -k3,3 -n -r | head -n 1 | update_repo_tag)

  echo -n 'NGINX_PROXY_DOCKER_GEN_VERSION='
  (cd docker-gen; get_repo_tags | sort -t. -k1,1 -k2,2 -k3,3 -n -r | head -n 1 | update_repo_tag)

  echo '# LLDAP'

  echo -n 'LLDAP_VERSION='
  echo 'stable-alpine'

  echo '# Zulip'

  echo -n 'ZULIP_VERSION='
  (cd docker-zulip; get_repo_tags | echo 'deploy' | update_repo_tag) # sort -g -r | head -n 1

  echo -n 'ZULIP_POSTGRE_VERSION='
  yq -r '.services[].image' docker-zulip/docker-compose.yml | sed -n 's|zulip/zulip-postgresql:||p'

  echo -n 'ZULIP_MEMCACHED_VERSION='
  get_image_tags memcached | grep -- '-alpine$' | sort -t. -k1,1 -k2,2 -k3,3 -n -r | head -n 1

  echo -n 'ZULIP_RABBITMQ_VERSION='
  yq -r '.services[].image' docker-zulip/docker-compose.yml | sed -n 's|rabbitmq:||p'

  echo -n 'ZULIP_REDIS_VERSION='
  get_image_tags redis | grep -- '-alpine$' | grep -v 'M' | sort -t. -k1,1 -k2,2 -k3,3 -n -r | head -n 1

  echo '# Jitsi'

  echo -n 'JITSI_VERSION='
  get_image_tags jitsi/web | grep -- '^stable-' | sort -t. -k1.8,1 -k2,2 -k3,3 -n -r | head -n 1

  echo -n 'JITSI_EXCALIDRAW_BACKEND_VERSION='
  get_image_tags jitsi/excalidraw-backend | sort -t. -k1,1 -k2,2 -k3,3 -n -r | head -n 1

  yq -r '.services | select(. != null) | to_entries | .[] | select(.value.pull_policy == null) | "# Missing pull_policy!: " + .key' *.yml
}

if [ -z $DRY_RUN ];
  generate-config-env | tee config.env
else
  generate-config-env
fi
