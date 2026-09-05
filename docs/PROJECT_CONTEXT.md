# Contexto do Projeto: Chatbot para ISPs

## Objetivo
Desenvolver uma solução de chatbot omnichannel para pequenos e médios provedores de internet (ISPs). O sistema roteia o cliente para Suporte Técnico (com troubleshooting estruturado), Financeiro (auto-serviço e 2ª via) ou Comercial (vendas e viabilidade), com transbordo humano integrado no Chatwoot e pesquisa de satisfação (CSAT).

## Arquitetura Final Implementada
- **Canal:** WhatsApp (Evolution API v2.3.6)
- **Orquestrador de Fluxos:** n8n (Máquina de estados baseada em `$getWorkflowStaticData`)
- **Inbox dos Atendentes:** Chatwoot v3.10.0 (canal API integrado com Evolution)
- **Banco de Dados & Cache:** PostgreSQL 15 e Redis 7
- **Infraestrutura:** Docker Compose com rede interna isolada `isp-network`.

## Fluxos e Recursos Operacionais
1. **Menu Principal & Escape:**
   - 1: Suporte Técnico
   - 2: Financeiro & 2ª Via
   - 3: Comercial & Planos
   - Comandos de escape: `menu`, `sair`, `inicio`, `voltar`, `#menu`, `#sair`.
   - Limite de 3 tentativas para entradas inválidas.

2. **Suporte Técnico:**
   - Detecção de LOS/PON vermelha (rompimento de fibra).
   - Guia de reinicialização do roteador (30s).
   - Diagnóstico de Wi-Fi isolado vs falha geral.
   - Transbordo para técnico humano com nota privada contendo histórico de diagnóstico.

3. **Financeiro:**
   - Validação de CPF (11 dígitos).
   - 2ª via de fatura com Código PIX Copia e Cola mockado + Link PDF.
   - Consulta de faturas abertas.
   - Desbloqueio em Confiança por 48 horas.
   - Transbordo para atendente financeiro.

4. **Comercial:**
   - Planos de fibra residencial e corporativos com link dedicado.
   - Simulação de upgrades.
   - Coleta de endereço/CEP para consulta de viabilidade e repasse de lead qualificado ao consultor.

5. **Transbordo Silencioso & CSAT:**
   - Bot silencia 100% durante o atendimento humano.
   - Ao resolver o ticket no Chatwoot (`conversation_status_changed` -> `resolved`), o webhook dispara a pesquisa CSAT (1 a 4).
   - A resposta do cliente encerra o ciclo e reseta para o menu principal.

## Estado Atual
Sistema 100% implementado, testado e validado de ponta a ponta.
