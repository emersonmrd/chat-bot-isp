# Contexto do Projeto: Chatbot para ISPs

## Objetivo
Desenvolver uma solução de chatbot omnichannel para pequenos e médios provedores de internet (ISPs). O sistema deve rotear o cliente para Suporte Técnico (com troubleshooting estruturado), Financeiro ou Comercial, com transbordo humano integrado.

## Arquitetura Atual em Discussão
- **Canal:** WhatsApp
- **API WhatsApp:** Em discussão (Evolution API vs Cloud API oficial)
- **Orquestrador de Fluxos:** n8n
- **Inbox dos Atendentes:** Chatwoot
- **Banco de Dados & Cache:** PostgreSQL e Redis
- **Infraestrutura Inicial:** Local com Docker (estudos), com visão para produção.

## Boas Práticas e Regras de Desenvolvimento (TDD & Git)
1. **Git Flow:** O projeto utiliza Git. Cada nova funcionalidade, alteração de infraestrutura ou fluxo do n8n deve ser desenvolvida em uma branch separada (ex: `feature/infra-docker`, `feature/fluxo-suporte`) e "mergiada" na principal apenas quando funcional.
2. **TDD e Testes:** Antes de implementar fluxos ou configurações, os testes (ou critérios de aceite automatizáveis) devem ser definidos. Para a infra, isso significa escrever `healthchecks` no Docker. Para o n8n, mock de webhooks.
3. **Agentes Recuperáveis:** Todo subagente que for ativado deve ler **este arquivo** (`docs/PROJECT_CONTEXT.md`) antes de iniciar seu trabalho para herdar o estado atual do projeto.

## Estrutura da Equipe de Agentes
- **Arquiteto de Sistemas (`isp_architect`):** Responsável por definir a stack final, infraestrutura e arquitetura de integração.
- **Engenheiro de Automação (`isp_automation_dev`):** Responsável por construir e testar os fluxos JSON do n8n, webhooks e roteamentos.
- **Especialista DevOps (`isp_infra_devops`):** Responsável pela criação do `docker-compose.yml`, variáveis de ambiente, volumes e deploy.

## Estado Atual
Aguardando definição arquitetural final pelo usuário em conjunto com o Arquiteto.
