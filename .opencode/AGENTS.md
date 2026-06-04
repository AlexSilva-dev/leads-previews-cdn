# Previews CDN

Projeto de CDN para previews de HTML. A arquitetura usa Docker Compose com dois serviços:

- **Nginx**: serve arquivos HTML estáticos do diretório `/usr/share/nginx/html`
- **SSH server**: permite upload de arquivos via SFTP/SCP para `/app`, que é o mesmo volume dos HTMLs servidos pelo Nginx

## Diretório de trabalho

- `/app/` — diretório onde ficam os HTMLs de preview. É o único diretório externo permitido.
- `/opencode-config/` — contém os arquivos de configuração do opencode (`opencode.json`, `.opencode/`)

## Convenções

- Os arquivos HTML em `/app/` são previews estáticos
- O opencode pode criar, ler, editar e melhorar qualquer arquivo dentro de `/app/`
- Qualquer arquivo fora de `/app/` não deve ser acessado
