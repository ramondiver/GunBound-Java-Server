# Deploy with GitHub Actions

GitHub-hosted runners **cannot** accept inbound GunBound TCP (`8372/8360/8352`).
To stay online without a VPS, the **Online** workflow deploys to [Fly.io](https://fly.io) (free account).

## Online without a VPS

1. Create a Fly.io account: https://fly.io/docs/hands-on/sign-up/
2. Install flyctl and run `fly auth token`
3. Repo → **Settings → Secrets → Actions** → `FLY_API_TOKEN`
4. **Actions → Online → Run workflow**

The job builds `Dockerfile.online` (MariaDB + Game/Broker/Buddy in one machine),
allocates a public IPv4 in `gru` (São Paulo) and prints it in the log.
Point the GunBound client broker to that IPv4, port **8372**.

Test accounts after first boot: `admin/admin`, `player/player`.

## Other workflows

| Workflow | When | What |
|---|---|---|
| `ci.yml` | push / PR | Compiles the fat JAR |
| `release.yml` | push `main` | Pushes `ghcr.io/ramondiver/gunbound-java-server` |
| `online.yml` | manual or push | Deploys to Fly.io |
| `deploy.yml` | optional | SSH deploy if you later get a VPS |
