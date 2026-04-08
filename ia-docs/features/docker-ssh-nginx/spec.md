# Spec: Docker SSH Nginx

## O que está construído
Configuração inicial do ambiente Docker Compose para servir arquivos estáticos via Nginx com acesso remoto via SSH para gerenciamento dinâmico de arquivos.

## Regras de negócio
1. **Compartilhamento de Volume:** O serviço Nginx e o serviço SSH devem compartilhar o mesmo volume ou bind mount apontando para a pasta de arquivos estáticos.
2. **Acesso SSH:** O serviço SSH deve permitir a autenticação (preferencialmente via chave pública ou senha configurável) para upload de arquivos.
3. **Distribuição HTML:** O Nginx deve servir o conteúdo da pasta compartilhada na porta 80.
4. **Persistência:** Os arquivos enviados via SSH devem persistir mesmo que os containers sejam reiniciados.

## Decisões técnicas
- **Base Image (Nginx):** `nginx:alpine` para manter o footprint pequeno.
- **Base Image (SSH):** Custom `alpine` image with `openssh` installed to ensure precise UID/GID alignment (1000).
- **Volume:** Bind mount local `./app` mapeado para `/usr/share/nginx/html` no Nginx e para a pasta de upload no SSH.

## Rotas/Telas
- **HTTP:** `http://localhost:80`
- **SSH:** `ssh -p 2222 user@localhost`

## Modelos e dependências
- Docker Engine >= 20.10
- Docker Compose V2

## Histórico de tasks
- [task_setup_docker_ssh_nginx.md](work/done/task_setup_docker_ssh_nginx.md): Configuração inicial do Docker Compose e serviços.
