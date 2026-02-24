# Stage 1: Build
FROM node:18-alpine AS builder

WORKDIR /app

# Copiar package.json e package-lock.json
COPY package*.json ./

# Instalar dependências
RUN npm install --production

# Stage 2: Runtime (imagem menor)
FROM node:18-alpine

LABEL maintainer="seu-email@example.com"
LABEL description="API Backend Fvendas - Node.js"

WORKDIR /app

# Copiar node_modules do builder
COPY --from=builder /app/node_modules ./node_modules

# Copiar package.json
COPY package*.json ./

# Copiar código da aplicação
COPY src ./src
COPY servidor.txt ./


# Expor porta (ajuste conforme sua API)
EXPOSE 3000

# Variáveis de ambiente
ENV NODE_ENV=production

# Healthcheck (opcional)
HEALTHCHECK --interval=30s --timeout=10s --start-period=10s --retries=3 \
  CMD wget --no-verbose --tries=1 --spider http://localhost:3000/health || exit 1

# Comando para iniciar a API
CMD ["node", "src/server.js"]
