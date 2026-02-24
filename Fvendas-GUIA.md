# 🐳 Docker - API Fvendas Backend

## Estrutura Criada

```
backend_node_app_vendas/
├── Dockerfile
├── docker-compose.yml
├── .dockerignore
├── package.json
├── src/
│   └── server.js
└── node_modules/
```

## Pré-requisitos

- ✅ Docker instalado (já está!)
- ✅ Docker Compose (já vem com o Docker.io)

Verifique:
```bash
docker --version
docker-compose --version
```

---

## 🚀 OPÇÃO 1: Executar com Docker Compose (Recomendado)

### 1️⃣ Configurar o projeto

Copie os arquivos para o diretório do projeto:

```bash
cd /media/lyder/6d26a714-fdfd-4a18-9061-2a3fe930582a/home/lyder/Desktop/BKP/React-Native/Projetos/Fvendas/backend_node_app_vendas

# Copiar Dockerfile
cp ~/Fvendas-Dockerfile ./Dockerfile

# Copiar docker-compose.yml
cp ~/Fvendas-docker-compose.yml ./docker-compose.yml

# Copiar .dockerignore
cp ~/Fvendas-.dockerignore ./.dockerignore
```

### 2️⃣ Criar arquivo .env (opcional mas recomendado)

```bash
cat > .env << 'EOF'
NODE_ENV=production
PORT=3000
DATABASE_URL=postgresql://postgres:senha123@db:5432/fvendas
# Adicione outras variáveis conforme necessário
EOF
```

### 3️⃣ Iniciar os containers

```bash
# Subir API + Banco de Dados + pgAdmin
docker-compose up -d

# Ou com logs ao vivo (para ver erros)
docker-compose up
```

### 4️⃣ Verificar se está rodando

```bash
# Ver containers em execução
docker-compose ps

# Ver logs da API
docker-compose logs -f api

# Ver logs do banco de dados
docker-compose logs -f db
```

### 5️⃣ Acessar a aplicação

- **API**: http://localhost:3000
- **pgAdmin (Banco de dados)**: http://localhost:5050
  - Email: admin@fvendas.com
  - Senha: admin123

### 6️⃣ Parar os containers

```bash
# Parar sem remover
docker-compose stop

# Parar e remover
docker-compose down

# Parar, remover e deletar volumes (CUIDADO!)
docker-compose down -v
```

---

## 🛠️ OPÇÃO 2: Executar manualmente com Docker CLI

### 1️⃣ Construir a imagem

```bash
cd /media/lyder/6d26a714-fdfd-4a18-9061-2a3fe930582a/home/lyder/Desktop/BKP/React-Native/Projetos/Fvendas/backend_node_app_vendas

docker build -t fvendas-api:1.0 .
```

### 2️⃣ Verificar a imagem

```bash
docker images | grep fvendas-api
```

### 3️⃣ Rodar container PostgreSQL (banco de dados)

```bash
docker run -d \
  --name fvendas-db \
  -e POSTGRES_USER=postgres \
  -e POSTGRES_PASSWORD=senha123 \
  -e POSTGRES_DB=fvendas \
  -v postgres_data:/var/lib/postgresql/data \
  postgres:15-alpine
```

### 4️⃣ Rodar container da API

```bash
docker run -d \
  --name fvendas-api \
  -p 3000:3000 \
  -e NODE_ENV=production \
  -e DATABASE_URL=postgresql://postgres:senha123@fvendas-db:5432/fvendas \
  --link fvendas-db:db \
  fvendas-api:1.0
```

### 5️⃣ Verificar se está rodando

```bash
docker ps

# Ver logs
docker logs -f fvendas-api
```

### 6️⃣ Parar e limpar

```bash
# Parar containers
docker stop fvendas-api fvendas-db

# Remover containers
docker rm fvendas-api fvendas-db

# Remover imagem
docker rmi fvendas-api:1.0
```

---

## 📋 Comandos Úteis

### Gerenciar containers com Compose

```bash
# Ver status de todos os serviços
docker-compose ps -a

# Ver logs em tempo real
docker-compose logs -f

# Ver logs de um serviço específico
docker-compose logs -f api
docker-compose logs -f db

# Entrar no container da API
docker-compose exec api sh

# Entrar no banco de dados
docker-compose exec db psql -U postgres -d fvendas

# Reiniciar um serviço
docker-compose restart api

# Rebuild de uma imagem
docker-compose build --no-cache
```

### Gerenciar containers manualmente

```bash
# Ver todos os containers
docker ps -a

# Entrar em um container
docker exec -it fvendas-api sh

# Ver logs em tempo real
docker logs -f fvendas-api

# Ver logs com mais detalhes
docker logs -t fvendas-api | tail -100

# Parar gracefully
docker stop fvendas-api

# Forçar parada
docker kill fvendas-api

# Remover container
docker rm fvendas-api

# Remover imagem
docker rmi fvendas-api:1.0
```

### Gerenciar banco de dados

```bash
# Acessar psql diretamente
docker exec -it fvendas-db psql -U postgres -d fvendas

# Executar comando SQL
docker exec -it fvendas-db psql -U postgres -d fvendas -c "SELECT * FROM users;"

# Fazer backup do banco
docker exec fvendas-db pg_dump -U postgres -d fvendas > backup.sql

# Restaurar banco de um backup
docker exec -i fvendas-db psql -U postgres -d fvendas < backup.sql
```

---

## 🔧 Troubleshooting

### "Connection refused" ao conectar no banco

```bash
# Verificar se o container do banco está rodando
docker-compose ps db

# Ver logs do banco
docker-compose logs db

# Tentar reconectar depois de 10s (o banco pode estar ainda iniciando)
sleep 10 && docker-compose logs api
```

### Porta 3000 já está em uso

```bash
# Encontrar processo usando a porta
sudo lsof -i :3000

# Ou mudar a porta no docker-compose.yml
# De: "3000:3000"
# Para: "8080:3000"
```

### Container sai imediatamente

```bash
# Ver o erro
docker-compose logs api

# Ou manualmente
docker run -it fvendas-api:1.0 node src/server.js
```

### Erro de permissão

```bash
# Se receber erro de permissão, adicione ao grupo docker
sudo usermod -aG docker $USER
newgrp docker
```

### Limpar espaço (remover containers e imagens não utilizados)

```bash
# Remover containers parados
docker container prune

# Remover imagens não utilizadas
docker image prune

# Remover tudo
docker system prune -a
```

---

## 🌐 Variáveis de Ambiente

Crie um arquivo `.env` na raiz do projeto:

```bash
cat > .env << 'EOF'
# Configuração da Aplicação
NODE_ENV=production
PORT=3000

# Configuração do Banco de Dados
DATABASE_HOST=db
DATABASE_PORT=5432
DATABASE_NAME=fvendas
DATABASE_USER=postgres
DATABASE_PASSWORD=senha123
DATABASE_URL=postgresql://postgres:senha123@db:5432/fvendas

# Outras variáveis
JWT_SECRET=sua-chave-secreta-aqui
API_KEY=sua-api-key-aqui
EOF
```

E atualize o `src/server.js` para usar as variáveis:

```javascript
require('dotenv').config();

const PORT = process.env.PORT || 3000;
const NODE_ENV = process.env.NODE_ENV || 'development';
```

---

## 📦 Publicar imagem no Docker Hub (opcional)

```bash
# 1. Criar conta em hub.docker.com

# 2. Fazer login
docker login

# 3. Tag da imagem com seu usuário
docker tag fvendas-api:1.0 seu-usuario/fvendas-api:1.0

# 4. Push
docker push seu-usuario/fvendas-api:1.0

# 5. Outro usuario pode fazer pull
docker pull seu-usuario/fvendas-api:1.0
```

---

## 🚀 Em Produção

**Ajustes importantes para produção:**

1. **Remova volumes de desenvolvimento** no docker-compose.yml
2. **Mude senhas padrão** do banco e pgAdmin
3. **Use variáveis de ambiente** em um arquivo `.env` não versionado
4. **Configure um reverse proxy** (nginx) na frente da API
5. **Habilite HTTPS** com certificados SSL
6. **Configure backups automáticos** do banco de dados
7. **Use Docker Swarm ou Kubernetes** para múltiplos servidores

---

## ✨ Próximos Passos

1. Testar a API localmente
2. Configurar CI/CD (GitHub Actions)
3. Deplocar em um servidor Linux (DigitalOcean, AWS, etc)
4. Monitorar containers com Portainer ou similar
5. Fazer backup regular do banco de dados

Boa sorte! 🚀
