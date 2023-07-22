# DOCKER STACK TEMPLATE - PADRÃO PHPv8.2

Este repositório contém uma **stack Docker pronta para PHP**, incluindo:

- **Nginx** (webserver)  
- **PHP-FPM 8.2** (com extensões comuns + Node.js 20 + Composer)  
- **MySQL 8**  
- **phpMyAdmin**  
- **MailHog** (captura de e-mails em ambiente dev)  
- **Ultrahook** (opcional – tunelamento de webhooks)  
- **Composer2** (Para instalação de dependências, ex: laravel, codeigniter e etc..)

A stack é **parametrizada por um único arquivo de configuração** localizado em:

```
.docker/.config-docker
```

## ESTRUTURA

```
.
├─ docker-compose.yml        # Stack principal
├─ .docker/
│  ├─ .config-docker         # Arquivo de configuração (copie do .example)
│  ├─ php/
│  │  ├─ Dockerfile
│  │  └─ php.ini
│  ├─ nginx/
│  │  └─ default.conf
│  └─ mysql/
│     └─ init-db.sql (definir previlégios para usuário da base de dados)
└─ README.md
```

## CONFIGURAÇÕES

1. **Crie o arquivo de configuração** copiando o exemplo:
   ```bash
   cp .docker/.config-docker.example .docker/.config-docker
   ```

2. **Edite as variáveis** conforme o projeto:
   - `STACK` → nome único da stack (usado em containers, rede e volumes)  
   - `MYSQL_DATABASE`, `MYSQL_USER`, `MYSQL_PASSWORD`, `MYSQL_ROOT_PASSWORD`  
   - `HTTP_PORT`, `HTTPS_PORT`, `PMA_PORT`, `MAILHOG_UI`, etc.  
   - `ULTRAHOOK_API_KEY` (se for usar tunelamento)

Exemplo de `.docker/.config-docker`:

```dotenv
STACK=novo_projeto_2023
COMPOSE_PROJECT_NAME=${STACK}

HTTP_PORT=80
HTTPS_PORT=443
PMA_PORT=8080
MAILHOG_SMTP=1025
MAILHOG_UI=8025

MYSQL_DATABASE=database_${STACK}
MYSQL_USER=db_user_${STACK}
MYSQL_PASSWORD=sEnHasEgUrA
MYSQL_ROOT_PASSWORD=root_password

USE_SSL=false
SSL_CERT_PATH=.docker/php/localhost+2.pem
SSL_KEY_PATH=.docker/php/localhost+2-key.pem

ULTRAHOOK_API_KEY=
```

## SUBINDO UM NOVO PROJETO
Após configurar corretamente o arquivo `.docker/.config-docker`:

Subir os containers:
```bash
docker compose --env-file .docker/.config-docker up -d --build
```

Ver status:
```bash
docker compose --env-file .docker/.config-docker ps
```

Logs:
```bash
docker compose --env-file .docker/.config-docker logs -f
```

Derrubar a stack:
```bash
docker compose --env-file .docker/.config-docker down
```

Resetar dados do MySQL (apaga volume completamente):
```bash
docker volume rm ${STACK}-data
```

## ACESSOS:

- **Aplicação**: [http://localhost:80](http://localhost:80)  
- **phpMyAdmin**: [http://localhost:8080](http://localhost:8080)  
- **MailHog UI**: [http://localhost:8025](http://localhost:8025)  

Credenciais do phpMyAdmin:
- Host: `db`  
- Usuário: `${MYSQL_USER}`  
- Senha: `${MYSQL_PASSWORD}`  
- Ou: `root` / `${MYSQL_ROOT_PASSWORD}`  

## ULTRAHOOK (use se for trabalhar com API/Webhook)

1. Crie uma conta em [https://www.ultrahook.com](https://www.ultrahook.com)  
2. Pegue sua **API Key** no dashboard da conta  
3. Configure no `.docker/.config-docker`:  
   ```dotenv
   ULTRAHOOK_API_KEY=sua_chave_aqui
   ```
4. Suba a stack novamente.

---

## 📖 Licença

Uso interno **FBXWEB - Agência Criativa** © 2023.  
