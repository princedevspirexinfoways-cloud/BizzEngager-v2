#!/usr/bin/env bash
# BizzEngager v2 deploy / redeploy.
# Run from the repo root on the VPS:  ./deploy/deploy.sh [--seed] [--sync]
#
#   (no flags)  build images and (re)start the stack
#   --sync      also run DB schema sync (safe: alter, creates/updates tables)
#   --seed      also run the superadmin seed (first deploy only)
#
# Requires: docker + docker compose plugin, and a filled-in .env.prod at repo root.
set -euo pipefail

cd "$(dirname "$0")/.."
COMPOSE="docker compose -f docker-compose.prod.yml --env-file .env.prod"

DO_SYNC=false
DO_SEED=false
for arg in "$@"; do
  case "$arg" in
    --sync) DO_SYNC=true ;;
    --seed) DO_SEED=true ;;
    *) echo "Unknown flag: $arg" >&2; exit 1 ;;
  esac
done

if [[ ! -f .env.prod ]]; then
  echo "✖ .env.prod not found. Copy .env.prod.example → .env.prod and fill it in." >&2
  exit 1
fi

echo "▶ Building images…"
$COMPOSE build

echo "▶ Starting infrastructure (mysql, redis)…"
$COMPOSE up -d mysql redis

echo "▶ Waiting for MySQL to be healthy…"
until [ "$(docker inspect -f '{{.State.Health.Status}}' bizzengager-mysql 2>/dev/null)" = "healthy" ]; do
  sleep 2; echo "  …still starting"
done

if $DO_SYNC; then
  echo "▶ Syncing DB schema…"
  $COMPOSE run --rm api node src/database/sync.js
fi

if $DO_SEED; then
  echo "▶ Seeding superadmin…"
  $COMPOSE run --rm api node src/database/seed.js
fi

echo "▶ Starting / updating app services…"
$COMPOSE up -d --remove-orphans

echo "▶ Pruning dangling images…"
docker image prune -f >/dev/null || true

echo "✔ Deploy complete."
$COMPOSE ps
