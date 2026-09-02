# Deploy

## Método grátis (sem VPS, sem cartão)

GitHub Actions e o plano grátis da Fly **não** abrem TCP `8372/8360/8352`.
O caminho zero-custo é rodar o servidor no seu PC e publicar com [playit.gg](https://playit.gg) (3 túneis TCP no free).

```bash
git clone https://github.com/ramondiver/GunBound-Java-Server.git
cd GunBound-Java-Server
bash scripts/free-online.sh
```

1. Conta em https://playit.gg/login/create
2. `docker compose -f docker-compose.free.yml logs -f playit` — abra o link de claim
3. Crie 3 túneis Custom:
   - Broker TCP → `gameserver:8372`
   - Game TCP → `gameserver:8360`
   - Buddy TCP → `gameserver:8352`
4. No `config/config.properties`, `server.public.ip` e `gameserver.port` são o **host:porta público do túnel Game**
5. No client, o broker é o **host:porta público do túnel Broker**
6. `docker compose -f docker-compose.free.yml restart gameserver`

O computador precisa ficar ligado. Contas seed: `admin/admin`, `player/player`.

## Fly.io / VPS (pago ou com cartão cadastrado)

Ver workflow `online.yml` e `deploy.yml`.
