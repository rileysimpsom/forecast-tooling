#!/usr/bin/env bash
set -e

case "$1" in
  up)
    docker compose -f infra/docker-compose.yml up --build
    ;;
  down)
    docker compose -f infra/docker-compose.yml down -v
    ;;
  logs)
    docker compose -f infra/docker-compose.yml logs -f
    ;;
  *)
    echo "Usage: ./dev.sh {up|down|logs}"
    ;;
esac