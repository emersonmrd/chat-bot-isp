# 🤖 Chatbot ISP - Sistema Omnichannel de Autoatendimento para Provedores de Internet

Solução completa, resiliente, gratuita e 100% self-hosted de Chatbot WhatsApp com transbordo humano para Pequenos e Médios Provedores de Internet (ISPs).

---

## 🏗️ Arquitetura & Stack Tecnológica

O projeto é estruturado em containers Docker orquestrados via `docker-compose`:

```
                    ┌─────────────────────────┐
                    │    Cliente WhatsApp     │
                    └────────────┬────────────┘
                                 │
                                 ▼
                    ┌─────────────────────────┐
                    │  Evolution API (v2.3)   │ (Gateway WhatsApp)
                    └──────┬───────────▲──────┘
                           │           │
            Webhook Event  │           │ Mensagem / CSAT
                           ▼           │
                    ┌─────────────────────────┐
                    │     n8n Workflow        │ (Orquestrador & Máquina de Estados)
                    └──────┬───────────┬──────┘
                           │           │
           Notas / Transbordo          │ CSAT ao Resolver
                           ▼           ▼
                    ┌─────────────────────────┐
                    │     Chatwoot (v3.10)    │ (Painel Omnichannel dos Atendentes)
                    └─────────────────────────┘
```

| Componente | Tecnologia / Imagem | Porta Local | Descrição |
| :--- | :--- | :--- | :--- |
| **Banco de Dados** | `postgres:15-alpine` | `5432` | Armazenamento de Evolution API, Chatwoot e n8n |
| **Cache & Filas** | `redis:7-alpine` | `6379` | Gerenciamento de filas do Sidekiq (Chatwoot) e cache |
| **Gateway WhatsApp** | `evoapicloud/evolution-api:v2.3.6` | `8080` | Conexão com WhatsApp Web & Webhooks |
| **Orquestrador de Fluxos** | `docker.n8n.io/n8nio/n8n:stable` | `5678` | Roteamento, triagem e máquina de estados |
| **Painel de Atendentes** | `chatwoot/chatwoot:v3.10.0` | `3000` | Atendimento humano multicanal com histórico |

---

## 🚀 Funcionalidades Implementadas

### 1. 🧭 Menu Principal & Roteador
- **Navegação rápida:** Opções numéricas diretas (`1: Suporte`, `2: Financeiro`, `3: Comercial`).
- **Tolerância a erros:** Tratamento de até 3 tentativas inválidas antes de sugerir reinício assistido.
- **Comandos de escape:** O cliente pode digitar `menu`, `sair`, `#menu` ou `#sair` a qualquer momento para voltar à tela inicial.

### 2. 🔧 Suporte Técnico (Triagem & Diagnóstico Estruturado)
- **Verificação de LEDs (LOS/PON):** Identifica na hora rompimento de fibra óptica e transfere com alerta crítico.
- **Ciclo de Reinicialização (30s):** Guia o cliente para reiniciar o roteador e verifica se o sinal estabilizou.
- **Diagnóstico Wi-Fi vs Cabo:** Isola se o problema é canal/frequência sem fio ou falha geral de rede.
- **Transbordo com Diagnóstico:** Cria nota privada interna no Chatwoot com todo o histórico coletado.

### 3. 💰 Atendimento Financeiro (Auto-serviço & Mock)
- **Validação de CPF:** Exige e sanitiza os 11 dígitos do titular.
- **2ª Via & PIX Copia e Cola:** Retorna dados de fatura, código PIX copia e cola e link do boleto em PDF.
- **Consulta de Faturas:** Exibe faturas abertas e status do plano.
- **Desbloqueio em Confiança (48h):** Realiza liberação provisória automática da conexão.
- **Falar com Atendente:** Encaminha diretamente para a fila financeira.

### 4. 🛒 Comercial & Vendas (Qualificação de Leads)
- **Catálogo de Fibra Residencial & Corporativo:** Apresenta planos de alta velocidade e links dedicados com IP fixo.
- **Simulador de Upgrade:** Oferece opções de upgrade com desconto especial.
- **Consulta de Viabilidade por CEP:** Coleta endereço/CEP do cliente e entrega o Lead pronto no Chatwoot.

### 5. 🤫 Transbordo Silencioso & Pesquisa de Satisfação (CSAT)
- **Silenciamento do Bot:** O robô não interfere enquanto o atendente humano estiver falando no Chatwoot.
- **Respostas do Atendente:** Mensagens digitadas pelos operadores no Chatwoot são entregues diretamente no WhatsApp do cliente via rede Docker interna.
- **CSAT Automático:** Ao clicar em **"Resolver"** no Chatwoot, o sistema envia a pesquisa com notas de 1 a 4. Ao responder, o bot agradece e reseta para o Menu Principal.

---

## 🛠️ Como Executar Localmente

### Pré-requisitos
- [Docker Desktop](https://www.docker.com/products/docker-desktop/) instalado e ativo com WSL2 (Windows) ou nativo (Linux/macOS).
- Git instalado.

### 1. Clonar o Repositório
```bash
git clone https://github.com/emersonmrd/chat-bot-isp.git
cd chat-bot-isp
```

### 2. Configurar Variáveis de Ambiente
Crie um arquivo `.env` baseado no modelo:
```env
POSTGRES_USER=isp_user
POSTGRES_PASSWORD=isp_super_secret_pass
POSTGRES_DB=isp_chatbot_db

EVOLUTION_SERVER_URL=http://isp-evolution:8080
EVOLUTION_API_KEY=evolucao_isp_key_2026

N8N_WEBHOOK_URL=http://localhost:5678
N8N_ENCRYPTION_KEY=n8n_super_secret_key_12345

CHATWOOT_FRONTEND_URL=http://localhost:3000
CHATWOOT_SECRET_KEY=chatwoot_super_secret_base_key_9876543210
```

### 3. Subir os Containers
```bash
docker compose up -d
```

### 4. Importar o Fluxo no n8n
O fluxo principal está disponível em `n8n/workflows/main-router.json`:
```bash
docker cp n8n/workflows/main-router.json isp-n8n:/tmp/main-router.json
docker exec -u node isp-n8n n8n import:workflow --input=/tmp/main-router.json
docker exec -u node isp-n8n n8n publish:workflow --id=WflISPMainRouter01
docker restart isp-n8n
```

---

## 📁 Estrutura do Projeto

```
chat-bot-isp/
├── .env                         # Variáveis de ambiente locais
├── docker-compose.yml           # Definição dos serviços e redes Docker
├── AGENTS.md                    # Diretrizes operacionais e regras do repositório
├── README.md                    # Documentação técnica e guia do usuário
├── docs/
│   └── PROJECT_CONTEXT.md       # Arquitetura, decisões e histórico do projeto
├── n8n/
│   └── workflows/
│       └── main-router.json     # Workflow completo da máquina de estados ISP
└── tests/                       # Scripts e testes automatizados de validação
```

---

## 📄 Licença
Projeto de código aberto sob a licença MIT.
