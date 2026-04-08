# Requirements: Docker SSH Nginx

## Contexto
Atualmente, para atualizar arquivos em um container Nginx, é necessário reconstruir a imagem ou usar comandos manuais como `docker cp`. Isso dificulta o fluxo de trabalho de desenvolvedores que precisam de um ambiente de "preview" rápido onde possam simplesmente arrastar arquivos ou usar `scp`/`rsync`. Esta feature visa automatizar a criação de um ambiente dual onde o Nginx serve os arquivos e um servidor SSH permite a gestão dinâmica desses mesmos arquivos através de um volume compartilhado.

## Pesquisa de Mercado

### 1. Bitnami Nginx + SFTP Sidecar
- **Achado 1:** Utiliza o padrão sidecar para separar a responsabilidade de servir conteúdo da responsabilidade de gerenciar arquivos.
- **Achado 2:** Foca em segurança utilizando usuários não-root, o que exige alinhamento de permissões (UID/GID) entre os containers.
- **Achado 3:** Comumente implementado em ambientes de nuvem para permitir que usuários finais atualizem sites estáticos sem acesso ao cluster.

### 2. LinuxServer.io OpenSSH-Server
- **Achado 1:** Oferece uma imagem altamente customizável via variáveis de ambiente para definir usuários, senhas e chaves públicas.
- **Achado 2:** Facilita o mapeamento de volumes persistentes para diretórios específicos do usuário SSH.
- **Achado 3:** Suporta a execução de scripts de inicialização (custom scripts) para ajustar permissões de arquivos automaticamente.

## Categorias de Descoberta

### 1. Quem usa e qual o problema real?
Desenvolvedores de front-end ou administradores de sistemas que precisam de um servidor de preview rápido. O problema é a fricção no deploy de arquivos estáticos em ambientes de desenvolvimento/staging.

### 2. O que existe hoje?
Workarounds incluem `docker cp`, montagem de volumes locais (que não funcionam em servidores remotos sem SSH) ou pipelines complexos de CI/CD.

### 3. Fluxo Principal
1. O usuário sobe o ambiente com `docker-compose up -d`.
2. O usuário envia arquivos HTML/CSS/JS via `scp` ou `sftp` para a porta 2222.
3. O Nginx detecta os novos arquivos no volume compartilhado e os serve imediatamente na porta 80.

### 4. Fluxos Alternativos e de Erro
- **Erro de Permissão:** O usuário SSH faz upload, mas o Nginx não consegue ler (403 Forbidden). Resolvido forçando o mesmo UID/GID (ex: 1000) para o usuário do Nginx e o usuário SSH através de customização na imagem ou variáveis de ambiente.
- **Falha de Conexão:** Porta 2222 bloqueada no host ou conflito de porta.

### 5. Integrações e Dependências
- Docker Compose como orquestrador.
- Volume compartilhado entre os serviços `web` e `ssh`.
- Autenticação SSH baseada em senha para simplicidade inicial.

### 6. Restrições Técnicas e de Negócio
- Deve ser leve (Alpine Linux).
- Deve ser seguro (não expor a porta 22 padrão do host).
- Cache do Nginx deve ser desativado (`sendfile off`) para garantir que as atualizações sejam imediatas.

### 7. Critérios de Sucesso Mensuráveis
- Tempo de deploy de um arquivo index.html < 5 segundos via SCP.
- Acesso imediato ao arquivo via browser na porta 80 (sem cache).
- Script `test_deploy.sh` executa com sucesso o ciclo completo (upload + verificação).

## Mapa de Dependências
- `docker-compose.yml` depende da existência da pasta `./app`.
- O serviço `web` depende do volume montado.
- O serviço `ssh` depende do volume montado e das variáveis de ambiente de credenciais.
