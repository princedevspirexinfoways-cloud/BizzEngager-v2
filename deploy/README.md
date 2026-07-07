# BizzEngager v2 — VPS Deployment

Stack per subdomain:

| Domain                      | Serves        | Container            | Internal port |
|-----------------------------|---------------|----------------------|---------------|
| `v2.bizzengager.com`        | Frontend SPA  | `bizzengager-frontend` | 127.0.0.1:8080 |
| `v2.api.bizzengager.com`    | API + Socket.IO + `/uploads` | `bizzengager-api` | 127.0.0.1:4000 |

Behind them: MySQL 8, Redis 7, and a background `worker` — all in Docker. The host
Nginx terminates TLS and reverse-proxies to the containers (which bind to localhost only).

---

## 0. Prerequisites (Ubuntu/Debian VPS)

```bash
# Docker + compose plugin
curl -fsSL https://get.docker.com | sh
sudo usermod -aG docker "$USER"   # log out/in after this

# Nginx + certbot
sudo apt update
sudo apt install -y nginx python3-certbot-nginx
```

Point DNS **A records** for both subdomains at the VPS IP before requesting certs:

```
v2        A   <vps-ip>
v2.api    A   <vps-ip>
```

---

## 1. Get the code onto the VPS

The frontend and backend are separate git repos. Clone both into one directory that
also holds `docker-compose.prod.yml`, `.env.prod`, and `deploy/`. Simplest layout — keep
the repo structure identical to local:

```bash
mkdir -p /opt/bizzengager && cd /opt/bizzengager
# copy/clone so you end up with:  ./frontend  ./backend  ./docker-compose.prod.yml  ./deploy
```

> The compose file builds `./frontend` and `./backend` and expects `deploy/` and
> `.env.prod` alongside them.

---

## 2. Configure secrets

```bash
cp .env.prod.example .env.prod
# generate secrets:
openssl rand -hex 32   # JWT_ACCESS_SECRET
openssl rand -hex 32   # JWT_REFRESH_SECRET
openssl rand -hex 32   # CREDENTIALS_ENC_KEY  (must be 64 hex chars)
nano .env.prod         # fill in every CHANGE_ME_*
```

Key values that MUST be right:
- `CORS_ORIGINS=https://v2.bizzengager.com`
- `PUBLIC_BASE_URL=https://v2.api.bizzengager.com`  (builds upload/image URLs)
- `VITE_API_URL=https://v2.api.bizzengager.com`      (baked into the frontend build)

---

## 3. First deploy

```bash
./deploy/deploy.sh --sync --seed
```

- `--sync` creates the DB schema (`sequelize.sync({ alter: true })`).
- `--seed` creates the superadmin from `SEED_SUPERADMIN_*`.

On later redeploys just run `./deploy/deploy.sh` (add `--sync` when models change).

Check it's up:
```bash
docker compose -f docker-compose.prod.yml --env-file .env.prod ps
curl -s http://127.0.0.1:4000/api/v1/health   # API
curl -sI http://127.0.0.1:8080/               # frontend
```

---

## 4. Nginx + TLS

```bash
sudo mkdir -p /var/www/certbot
sudo cp deploy/nginx/v2.bizzengager.com.conf      /etc/nginx/sites-available/
sudo cp deploy/nginx/v2.api.bizzengager.com.conf  /etc/nginx/sites-available/
sudo ln -sf /etc/nginx/sites-available/v2.bizzengager.com.conf     /etc/nginx/sites-enabled/
sudo ln -sf /etc/nginx/sites-available/v2.api.bizzengager.com.conf /etc/nginx/sites-enabled/
sudo nginx -t && sudo systemctl reload nginx

# Issue certs — certbot rewrites the server blocks to add TLS + HTTP→HTTPS redirect.
sudo certbot --nginx -d v2.bizzengager.com
sudo certbot --nginx -d v2.api.bizzengager.com
```

Certbot auto-renews via a systemd timer. Verify:
```bash
sudo certbot renew --dry-run
```

Now `https://v2.bizzengager.com` should load the app and log in against the API.

---

## 5. Meta WhatsApp webhook

The inbound status webhook lives under the API. In the Meta app config set the callback to:

```
Callback URL:  https://v2.api.bizzengager.com/api/v1/webhooks/whatsapp
Verify token:  value of META_WA_WEBHOOK_VERIFY_TOKEN
```

---

## Operations

```bash
# logs
docker logs -f bizzengager-api
docker logs -f bizzengager-worker

# restart one service
docker compose -f docker-compose.prod.yml --env-file .env.prod restart api

# stop everything
docker compose -f docker-compose.prod.yml --env-file .env.prod down

# DB backup
docker exec bizzengager-mysql sh -c \
  'exec mysqldump -uroot -p"$MYSQL_ROOT_PASSWORD" bizzengager' > backup-$(date +%F).sql
```

Uploads persist in the `uploads_data` Docker volume; MySQL in `mysql_data`; Redis in
`redis_data`. Back these up (or the mysqldump above) before major changes.
```
