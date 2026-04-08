# Task: Setup Docker SSH Nginx

**Feature:** docker-ssh-nginx
**Tipo:** FEATURE
**Complexidade:** SMALL

**State:** pending
**Blocked By:** null
**Next Agent:** architect
**Promise:** <promise>AGENT_COMPLETE: client-advocate | Phase 1 ready</promise>

## Contexto
Necessidade de um ambiente Docker que combine um servidor Nginx para distribuição de HTML e um acesso SSH para gerenciamento dinâmico de arquivos no diretório `/app`.

## Acceptance Criteria
- [ ] Given a running docker-compose environment When I upload an `index.html` via SSH using password authentication Then I should see the content when accessing `http://localhost:80` immediately.
- [ ] Given the SSH service is configured When I connect via `ssh -p 2222` Then I should be able to authenticate with a password and list files in the shared directory.
- [ ] Given a change in `index.html` When I re-upload via SSH Then the browser should show the new content without manual cache clearing (Nginx `sendfile off`).

## Subtasks
- [x] Criar estrutura de pastas inicial (`app/`) com arquivo padrão.
  **File:** `app/index.html` (create)
  **Reference:** N/A
  **Test:** `ls app/index.html`
  - ✅ Happy: File exists with content `<h1>Waiting for files...</h1>`.
  - 🔀 Boundary: Empty file `touch app/index.html` returns 200 OK.
  - ❌ Invalid: File with restricted permissions `chmod 000 app/index.html` returns 403.
  - ❌ Error: Directory `app/` not writable during creation.
  **Dependencies:** None
  **Pattern:** HTML5
  **Mocks:** None

- [x] Criar configuração customizada do Nginx para desativar cache.
  **File:** `nginx/nginx.conf` (create)
  **Reference:** N/A
  **Test:** `nginx -t` (inside container)
  - ✅ Happy: `curl -I localhost:80` returns `Cache-Control: no-store, no-cache, must-revalidate, proxy-revalidate, max-age=0`.
  - 🔀 Boundary: `sendfile off;` is present in the config to avoid kernel-level caching.
  - ❌ Invalid: Missing semicolon in `listen 80` causes Nginx startup failure.
  - ❌ Error: Setting `root /invalid/path` causes 404/500 errors on all requests.
  **Dependencies:** `app/index.html`
  **Pattern:** Nginx Mainline
  **Mocks:** None

- [x] Criar Dockerfile customizado para o serviço SSH com alinhamento de UID/GID.
  **File:** `ssh/Dockerfile` (create)
  **Reference:** N/A
  **Test:** `docker build -t custom-ssh ./ssh && docker run --rm custom-ssh id sshuser`
  - ✅ Happy: Returns `uid=1000(sshuser) gid=1000(sshuser)` matching Nginx user.
  - 🔀 Boundary: Build with `ARG USER_ID=1001` successfully creates user with UID 1001.
  - ❌ Invalid: `FROM alpine` without `apk add openssh` results in `ssh` command not found.
  - ❌ Error: Attempting to create user with `UID 0` (root) fails due to collision.
  **Dependencies:** None
  **Pattern:** Alpine-based Dockerfile
  **Mocks:** None

- [x] Configurar o `docker-compose.yml` com os serviços `web` (nginx) e `ssh`.
  **File:** `docker-compose.yml` (create)
  **Reference:** N/A
  **Test:** `docker compose config`
  - ✅ Happy: Config is valid, services `web` and `ssh` are defined with shared volume `./app`.
  - 🔀 Boundary: SSH port `2222` mapped to `22` in container.
  - ❌ Invalid: Missing `services:` key in YAML.
  - ❌ Error: Volume mount path `./non-existent-app` causes container start failure.
  **Dependencies:** `nginx/nginx.conf`, `ssh/Dockerfile`
  **Pattern:** Docker Compose V3.8+
  **Mocks:** None

- [x] Criar script de teste automatizado `test_deploy.sh`.
  **File:** `test_deploy.sh` (create)
  **Reference:** N/A
  **Test:** `./test_deploy.sh`
  - ✅ Happy: `sshpass -p 'password' scp -P 2222 index.html sshuser@localhost:/app/` succeeds and `curl` confirms change.
  - 🔀 Boundary: Uploading a 1MB file `dd if=/dev/urandom of=app/large.bin bs=1M count=1` and verifying via `curl`.
  - ❌ Invalid: Incorrect SSH port `2223` results in "Connection refused".
  - ❌ Error: `sshpass` not installed on host results in command not found.
  **Dependencies:** `docker-compose.yml`
  **Pattern:** Bash script with `curl` and `sshpass`
  **Mocks:** None

- [x] Validar o fluxo completo de upload e visualização imediata.
  **File:** N/A
  **Test:** Execução do `test_deploy.sh` com verificação de timestamp.
  - ✅ Happy: `curl localhost:80` returns content `v2` immediately after upload, with `Cache-Control: no-store`.
  - 🔀 Boundary: Rapid sequential uploads (3 in 1 second) all reflected correctly.
  - ❌ Invalid: SSH authentication failure with wrong password `wrongpass`.
  - ❌ Error: Nginx returns 403 Forbidden if files uploaded via SSH have `600` permissions and UID mismatch.
  **Dependencies:** `test_deploy.sh`
  **Pattern:** Manual/Automated validation
  **Mocks:** None

## Quality Gates
- [ ] Code review (reviewer)
- [ ] Test quality audit (test-auditor)
