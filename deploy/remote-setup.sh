#!/usr/bin/env bash
# First-time setup on the VPS. Run once as the deploy user.
set -euo pipefail

APP_DIR="${APP_DIR:-$HOME/gunbound}"
REPO="${REPO:-https://github.com/ramondiver/GunBound-Java-Server.git}"

mkdir -p "$APP_DIR"
if [ ! -d "$APP_DIR/.git" ]; then
  git clone "$REPO" "$APP_DIR"
fi

cd "$APP_DIR"
git pull --ff-only || true

mkdir -p config
if [ ! -f config/config.properties ]; then
  cp config.properties.example config/config.properties
  echo "Edit config/config.properties before starting:"
  echo "  server.public.ip=<IP publico do VPS>"
  echo "  db.url=jdbc:mariadb://mariadb:3306/gbth?useSSL=false&allowPublicKeyRetrieval=true"
  echo "  db.user=gunbound"
  echo "  db.password=gunbound"
fi

echo "Ready. From GitHub Actions, set secrets:"
echo "  DEPLOY_HOST, DEPLOY_USER, DEPLOY_SSH_KEY, DEPLOY_PATH=$APP_DIR"
echo
echo "Open firewall: TCP 8372,8360,8352 and UDP 8381"
