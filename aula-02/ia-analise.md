# Análise do Uso de IA — Aula 02 TF

## Prompt Utilizado

"Crie um docker-compose.yml para uma aplicação Node.js 20 com Express que usa PostgreSQL 15 como banco de dados e Redis 7 como cache. A API roda na porta 3000. O PostgreSQL precisa de volume nomeado para persistência. Todos os serviços devem estar na mesma rede bridge customizada. Use variáveis de ambiente com interpolação de arquivo .env. Adicione healthchecks, depends_on com condition, e restart policy unless-stopped."

## Output Original do Kiro

```yaml
version: '3.8'

services:
  api:
    build: .
    container_name: technova-api
    ports:
      - "${PORT:-3000}:3000"
    environment:
      - DB_HOST=${DB_HOST:-postgres}
      - DB_PORT=${DB_PORT:-5432}
      - DB_NAME=${DB_NAME:-technova}
      - DB_USER=${DB_USER:-technova}
      - DB_PASSWORD=${DB_PASSWORD:-senha_padrao}
      - REDIS_HOST=${REDIS_HOST:-redis}
      - REDIS_PORT=${REDIS_PORT:-6379}
    depends_on:
      postgres:
        condition: service_healthy
      redis:
        condition: service_healthy
    networks:
      - custom-bridge
    restart: unless-stopped

  postgres:
    image: postgres:15
    container_name: technova-db
    environment:
      POSTGRES_DB: ${POSTGRES_DB:-technova}
      POSTGRES_USER: ${POSTGRES_USER:-technova}
      POSTGRES_PASSWORD: ${POSTGRES_PASSWORD:-senha_padrao}
    ports:
      - "5432:5432"
    volumes:
      - pg-data:/var/lib/postgresql/data
    healthcheck:
      test: ["CMD-SHELL", "pg_isready -U technova"]
      interval: 10s
      timeout: 5s
      retries: 5
    networks:
      - custom-bridge
    restart: unless-stopped

  redis:
    image: redis:7
    container_name: technova-cache
    ports:
      - "6379:6379"
    healthcheck:
      test: ["CMD", "redis-cli", "ping"]
      interval: 10s
      timeout: 5s
      retries: 3
    networks:
      - custom-bridge
    restart: unless-stopped

networks:
  custom-bridge:
    driver: bridge

volumes:
  pg-data:


O que o Kiro Acertou
A estrutura geral do arquivo YAML veio perfeita, sem erros de indentação.

O mapeamento de portas (ports) e volumes nomeados foi feito certinho de primeira.

A configuração do healthcheck do Postgres e do Redis veio pronta, o que me economizou um bom tempo de pesquisa na documentação de sintaxe do Docker.

Entendeu muito bem o conceito de depends_on com condition: service_healthy para segurar a API até o banco subir.

O que o Kiro Errou ou Omitiu
Ignorou a boa prática de usar imagens Alpine, que é o padrão que estamos adotando.

Deu uma "escorregada" na segurança ao colocar senhas de fallback diretamente no arquivo, o que anula o propósito de ter o .env isolado.

Nomeou a rede como custom-bridge, que é muito genérico. Acabei renomeando para technova-network para fazer mais sentido com o nosso projeto.

Minha Avaliação
Tempo economizado usando IA: Uns 15 minutos, principalmente na digitação da estrutura chata e nos comandos longos de healthcheck.

Tempo gasto validando/corrigindo: Cerca de 10 minutos para revisar linha por linha, entender o que foi feito e aplicar os requisitos da aula (como as versões Alpine).

Nota para o output da IA (1-10): 8.0

Usaria novamente para este tipo de tarefa? Com certeza. Foi uma mão na roda para montar o "esqueleto" da orquestração. Mas ficou muito claro que não dá pra simplesmente copiar e colar pra produção sem revisar, principalmente os pontos cegos de segurança (senhas chumbadas) e otimização das imagens.
EOF