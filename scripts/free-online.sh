#!/usr/bin/env bash
# Start GunBound locally and expose it for free via playit.gg (no VPS, no card).
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT"

mkdir -p config
if [ ! -f config/config.properties ]; then
  cp config.properties.example config/config.properties
fi

echo "==> Starting MariaDB + GunBound + playit agent"
docker compose -f docker-compose.free.yml up -d

echo
echo "============================================================"
echo " MÉTODO GRÁTIS (playit.gg) — 3 túneis TCP no plano free"
echo "============================================================"
echo
echo "1. Crie conta em https://playit.gg/login/create  (sem cartão)"
echo "2. Veja o código/URL de claim:"
echo "     docker compose -f docker-compose.free.yml logs -f playit"
echo "3. No painel playit crie 3 túneis CUSTOM apontando para:"
echo "     Broker  TCP  gameserver:8372"
echo "     Game    TCP  gameserver:8360"
echo "     Buddy   TCP  gameserver:8352"
echo "4. Anote o host:porta PÚBLICO de cada túnel."
echo "5. Edite config/config.properties:"
echo "     server.public.ip = <host público do túnel GAME>"
echo "     gameserver.port  = <porta pública do túnel GAME>"
echo "   O client conecta no host:porta PÚBLICO do túnel BROKER."
echo "6. Reinicie o gameserver:"
echo "     docker compose -f docker-compose.free.yml restart gameserver"
echo
echo "Contas seed: admin/admin   player/player"
echo "O PC precisa ficar ligado. GitHub Actions / Fly grátis não abrem TCP."
echo "============================================================"
