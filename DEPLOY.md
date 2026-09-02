# Deploy with GitHub Actions

Image: `ghcr.io/ramondiver/gunbound-java-server:latest`

## Workflows

| Workflow | When | What |
|---|---|---|
| `.github/workflows/ci.yml` | push / PR on `main` | Compiles `target/gunbound-server.jar` |
| `.github/workflows/release.yml` | push `main`, tag `v*`, or manual | Builds and pushes the Docker image to GHCR |
| `.github/workflows/deploy.yml` | tag `v*` or **Actions → Deploy → Run workflow** | SSH into the VPS and `docker compose up` |

## 1. VPS (once)

```bash
curl -fsSL https://raw.githubusercontent.com/ramondiver/GunBound-Java-Server/main/deploy/remote-setup.sh | bash
```

Edit `~/gunbound/config/config.properties`:

- `server.public.ip` = public IP of the VPS
- `db.url=jdbc:mariadb://mariadb:3306/gbth?useSSL=false&allowPublicKeyRetrieval=true`

Open firewall: TCP `8372`, `8360`, `8352` and UDP `8381`.

## 2. GitHub secrets

Repo → **Settings → Secrets and variables → Actions**:

| Secret | Purpose |
|---|---|
| `DEPLOY_HOST` | VPS IP or hostname |
| `DEPLOY_USER` | SSH user |
| `DEPLOY_SSH_KEY` | Private key of that user |
| `DEPLOY_PATH` | Optional, default `$HOME/gunbound` |
| `DEPLOY_PORT` | Optional, default `22` |
| `GHCR_TOKEN` | PAT with `read:packages` if the image is private |

Also create the Actions environment named `production` (used by `deploy.yml`).

## 3. Ship a release

```bash
git tag v1.0.0
git push origin v1.0.0
```

Or open **Actions → Deploy → Run workflow** and deploy tag `latest`.
