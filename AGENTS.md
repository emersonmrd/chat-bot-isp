# Regras do Workspace (Antigravity Rules)

## Permissões e Autonomia dos Agentes
1. **Escopo do Projeto:** Todos os agentes (principal e subagentes) têm permissão irrestrita para ler, criar e modificar arquivos dentro do diretório do projeto (`chat-bot-isp`).
2. **Execução de Comandos:** Todos os comandos relacionados a Docker, Git, testes locais e scripts dentro do diretório do projeto devem ser executados de forma autônoma sem solicitar confirmação manual ao usuário.
3. **Subagentes e Contexto:** Todo subagente criado herda este arquivo e o `docs/PROJECT_CONTEXT.md` como diretriz primária.
