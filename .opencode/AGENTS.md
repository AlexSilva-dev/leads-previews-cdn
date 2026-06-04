# Previews CDN

Projeto de CDN para previews de HTML.

## Arquitetura

- **Nginx**: serve arquivos HTML estáticos de `/usr/share/nginx/html`
- **SSH server**: upload de arquivos via SFTP/SCP para `/app` (mesmo volume do Nginx)

## Diretórios

- `/app/` — HTMLs de preview (único diretório permitido para edição/criação)
- `/opencode-config/` — configuração do opencode (`opencode.json`, `.opencode/`)

## Regras de trabalho

- **Nunca** modifique ou crie mais de **um** arquivo por prompt
- **Nunca** mexa em arquivo não especificado no prompt
- O HTML deve ser único e auto-contido (CSS/JS inline quando necessário)
- Se o prompt pedir melhoria/modificação: altere **apenas** o arquivo informado
- Se o prompt pedir criação: crie **apenas** o arquivo com o nome informado

## Controle de versão (obrigatório)

- Após **toda** criação ou modificação de arquivo, execute `git commit` automaticamente
- Mensagem de commit deve seguir o padrão: `feat(preview): descrição breve do que foi feito`
- Exemplo: `feat(preview): add responsive landing page for lead capture`
- Exemplo: `feat(preview): fix layout breakpoint in product-card.html`
- **Nunca** use `git add .` ou `git add -A` — sempre adicione apenas o(s) arquivo(s) modificado(s)
- O histórico é sagrado: cada alteração deve ser rastreável para permitir rollback

## Rollback (cauteloso)

- Se o usuário pedir para voltar uma alteração, analise o histórico com `git log --oneline`
- Identifique o commit específico que contém a alteração a ser revertida
- Use `git revert <hash>` (nunca `git reset`) para preservar o histórico
- **Nunca** use `git reset --hard` — isso destrói o histórico
- Após o `git revert`, faça commit automático da reversão
