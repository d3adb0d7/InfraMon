# InfraMon - Infrastructure Monitoring System

![InfraMon](https://img.shields.io/badge/InfraMon-Monitoring%20System-blue)
![Node.js](https://img.shields.io/badge/Node.js-18+-green)
![React](https://img.shields.io/badge/React-18+-61dafb)
![PostgreSQL](https://img.shields.io/badge/PostgreSQL-14+-336791)

InfraMon is a comprehensive website and service monitoring system that provides real-time monitoring, alerting, and reporting for your infrastructure. It supports multiple monitoring methods including HTTP requests, PING, CURL commands, and custom CURL scripts.

## 🏗️ Project Structure

```
InfraMon/
├── backend/                 # Node.js Backend (Express + Sequelize)
│   ├── config/             # Database configuration
│   ├── migrations/         # Database schema migrations
│   ├── models/            # Sequelize ORM models
│   ├── routes/            # REST API routes
│   ├── services/          # Business logic services
│   ├── middleware/        # Authentication & authorization
│   └── server.js          # Main server entry point
├── frontend/               # React Frontend
│   ├── public/            # Static files
│   │   ├── index.html
│   │   └── manifest.json
│   ├── src/
│   │   ├── components/    # React components
│   │   │   ├── Alerts/    # Alert management
│   │   │   ├── Auth/      # Authentication
│   │   │   ├── Common/    # Shared components
│   │   │   ├── Dashboard/ # Dashboard widgets
│   │   │   ├── Layout/    # App layout
│   │   │   ├── Monitoring/# Monitoring management
│   │   │   └── Reports/   # Reporting components
│   │   ├── contexts/      # React contexts
│   │   ├── pages/         # Main pages
│   │   ├── services/      # API services
│   │   ├── styles/        # Global styles
│   │   └── utils/         # Utility functions
│   └── package.json
└── README.md
```

## 🎯 Features

- **🔍 Multi-method Monitoring**: HTTP, PING, CURL, and custom CURL commands
- **🚨 Real-time Alerts**: Email and Telegram notifications with beautiful templates
- **📊 Beautiful Dashboard**: Real-time status updates and comprehensive statistics
- **👥 User Management**: Role-based access control (admin, user, monitoring_user)
- **📈 Comprehensive Reporting**: Uptime statistics, response time analysis, alert history
- **⚡ Real-time Updates**: Server-Sent Events (SSE) for live status without page refresh
- **🔧 Custom CURL Support**: Advanced monitoring with full command control
- **⏰ Alert Cooldown**: Configurable alert frequency to prevent notification spam
- **🌙 Quiet Hours**: Schedule quiet periods for non-critical alerts
- **📱 Responsive Design**: Mobile-friendly interface built with Tailwind CSS


## 🚀 Quick Start

### Prerequisites

- Node.js 16+ 
- PostgreSQL 12+
- npm or yarn

## 🛠️ Development Deployment

### Backend Setup

1. **Navigate to backend directory:**
   ```bash
   cd backend
   ```

2. **Install dependencies:**
   ```bash
   npm install
   ```

3. **Set up environment variables:**
   ```bash
   cp .env.example .env
   ```
   Edit `.env` file:
   ```env
   # Database
   DB_NAME=InfraMon
   DB_USER=postgres
   DB_PASSWORD=postgres
   DB_HOST=127.0.0.1
   DB_PORT=5432

   # JWT Secret
   JWT_SECRET=your-development-secret-key

   # Email (Optional for development)
   SMTP_HOST=smtp.gmail.com
   SMTP_PORT=587
   SMTP_SECURE=false
   SMTP_USER=your-email@gmail.com
   SMTP_PASS=your-app-password
   SMTP_FROM=InfraMon <noreply@inframon.app>

   # Telegram (Optional for development)
   TELEGRAM_BOT_TOKEN=your-bot-token

   # Server
   PORT=5002
   NODE_ENV=development
   ```

4. **Set up database:**
   ```bash
   # Create database
   npx sequelize-cli db:create

   # Run migrations
   npx sequelize-cli db:migrate

   # (Optional) Seed with sample data
   npx sequelize-cli db:seed:all
   ```

5. **Start the backend server:**
   ```bash
   # Development mode with auto-reload
   npm run dev

   # Or production mode
   npm start
   ```

   The backend will be available at `http://localhost:5002`

### Frontend Setup

1. **Navigate to frontend directory:**
   ```bash
   cd frontend
   ```

2. **Install dependencies:**
   ```bash
   npm install
   ```

3. **Set up environment variables:**
   ```bash
   cp .env.example .env
   ```
   Edit `.env` file:
   ```env
   REACT_APP_API_URL=http://localhost:5002/api
   REACT_APP_WS_URL=http://localhost:5002
   ```

4. **Start the frontend development server:**
   ```bash
   npm start
   ```

   The frontend will be available at `http://localhost:3000`

### Default Login Credentials

After setup, you can login with:
- **Username**: `admin`
- **Password**: `admin`

## 📦 Production Deployment

### Option 1: Traditional VPS/Server Deployment

#### Backend Deployment

1. **Server preparation:**
   ```bash
   # Update system
   sudo apt update && sudo apt upgrade -y

   # Install Node.js
   curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash -
   sudo apt-get install -y nodejs

   # Install PostgreSQL
   sudo apt install postgresql postgresql-contrib -y

   # Create database and user
   sudo -u postgres psql
   CREATE DATABASE InfraMon;
   CREATE USER inframon_user WITH PASSWORD 'secure_password';
   GRANT ALL PRIVILEGES ON DATABASE InfraMon TO inframon_user;
   \q

   # OR
    sudo -u postgres psql -c "CREATE DATABASE InfraMon;"
    sudo -u postgres psql -c "CREATE USER inframon_user WITH PASSWORD 'secure_password';"
    sudo -u postgres psql -c "GRANT ALL PRIVILEGES ON DATABASE InfraMon TO inframon_user;"
   ```

2. **Deploy backend:**
   ```bash
   # Clone repository
   git clone https://github.com/d3adb0d7/InfraMon.git
   cd InfraMon/backend

   # Install dependencies
   npm install --production

   # Set production environment variables
   nano .env
   ```
   Production `.env`:
   ```env
   NODE_ENV=production
   DB_NAME=InfraMon
   DB_USER=inframon_user
   DB_PASSWORD=secure_password
   DB_HOST=localhost
   DB_PORT=5432
   JWT_SECRET=your-super-secure-jwt-secret
   # ... other production settings
   ```

3. **Database setup:**
   ```bash
   npx sequelize-cli db:migrate
   ```

4. **Setup process manager:**
   ```bash
   # Install PM2
   npm install -g pm2

   # Start application with PM2
   pm2 start server.js --name "inframon-backend"

   # Setup startup script
   pm2 startup
   pm2 save
   ```

5. **Setup reverse proxy (Nginx):**
   ```bash
   sudo apt install nginx -y
   sudo nano /etc/nginx/sites-available/inframon
   ```
   Nginx configuration:
   ```nginx
   server {
    listen 1337;
    server_name inframon.mynagad.com.bd;

    # Backend API
    location /api {
        proxy_pass http://localhost:5002;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
        proxy_cache_bypass $http_upgrade;
    }

    # Server-Sent Events
    location /events {
        proxy_pass http://localhost:5002;
        proxy_http_version 1.1;
        proxy_set_header Connection '';
        proxy_set_header Content-Type 'text/event-stream';
        proxy_buffering off;
        proxy_cache off;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }

    # Frontend static files
    location / {
        root /path/to/InfraMon/frontend/build;
        try_files $uri $uri/ /index.html;
        index index.html;
    }
}
   ```bash
   sudo ln -s /etc/nginx/sites-available/inframon /etc/nginx/sites-enabled/
   sudo nginx -t
   sudo systemctl reload nginx
   ```

#### Frontend Deployment

1. **Build the frontend:**
   ```bash
   cd frontend
   npm run build
   ```

2. **Deploy build files to Nginx serving directory**

### Option 2: Docker Deployment

#### Using Docker Compose

Create `docker-compose.yml` in project root:

```yaml
version: '3.8'

services:
  postgres:
    image: postgres:14
    environment:
      POSTGRES_DB: InfraMon
      POSTGRES_USER: inframon_user
      POSTGRES_PASSWORD: secure_password
    volumes:
      - postgres_data:/var/lib/postgresql/data
    ports:
      - "5432:5432"

  backend:
    build: ./backend
    ports:
      - "5002:5002"
    environment:
      NODE_ENV: production
      DB_HOST: postgres
      DB_PORT: 5432
      DB_NAME: InfraMon
      DB_USER: inframon_user
      DB_PASSWORD: secure_password
      JWT_SECRET: your-super-secure-jwt-secret
    depends_on:
      - postgres
    volumes:
      - ./backend:/app
      - /app/node_modules

  frontend:
    build: ./frontend
    ports:
      - "3000:80"
    environment:
      REACT_APP_API_URL: http://your-domain.com/api
    depends_on:
      - backend

volumes:
  postgres_data:
```

**Backend Dockerfile** (`backend/Dockerfile`):
```dockerfile
FROM node:18-alpine

WORKDIR /app

COPY package*.json ./
RUN npm install

COPY . .
RUN npx sequelize-cli db:migrate

EXPOSE 5002

CMD ["npm", "start"]
```

**Frontend Dockerfile** (`frontend/Dockerfile`):
```dockerfile
FROM node:18-alpine as build

WORKDIR /app
COPY package*.json ./
RUN npm install
COPY . .
RUN npm run build

FROM nginx:alpine
COPY --from=build /app/build /usr/share/nginx/html
COPY nginx.conf /etc/nginx/conf.d/default.conf

EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
```

**Frontend nginx.conf** (`frontend/nginx.conf`):

```nginx
server {
    listen 80;
    server_name localhost;
    root /usr/share/nginx/html;
    index index.html;

    location / {
        try_files $uri $uri/ /index.html;
    }

    location /api {
        proxy_pass http://backend:5002;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
    }
}
```

**Deploy with Docker:**
```bash
docker-compose up -d
```

### Option 3: Cloud Platform Deployment

#### Deploy to Heroku

1. **Backend on Heroku:**
   ```bash
   # Login to Heroku
   heroku login

   # Create app
   heroku create inframon-backend

   # Add PostgreSQL addon
   heroku addons:create heroku-postgresql:hobby-dev -a inframon-backend

   # Set environment variables
   heroku config:set JWT_SECRET=your-secret -a inframon-backend
   heroku config:set NODE_ENV=production -a inframon-backend

   # Deploy
   git subtree push --prefix backend heroku main
   ```

2. **Frontend on Netlify/Vercel:**
   - Build command: `npm run build`
   - Output directory: `build`
   - Environment variables: - `REACT_APP_API_URL`: `https://inframon-backend.herokuapp.com/api`
    `REACT_APP_WS_URL`: `https://inframon-backend.herokuapp.com`

## 🎨 Frontend Features

### Component Architecture

- **Layout**: Responsive sidebar and header navigation
- **Dashboard**: Real-time overview with uptime charts and statistics
- **Monitoring**: Website management with multiple check methods
- **Alerts**: Comprehensive alert management with filtering
- **Reports**: Detailed analytics and export functionality
- **Settings**: User preferences and alert configuration

### Real-time Capabilities

- Server-Sent Events for live status updates
- Automatic reconnection handling
- Connection status indicators
- Real-time dashboard updates

## 🔧 Configuration

### Monitoring Methods

| Method | Description | Use Case |
|--------|-------------|----------|
| **HTTP GET/POST** | Standard HTTP requests | Web applications, APIs |
| **PING** | ICMP echo requests | Server connectivity |
| **CURL_GET/POST** | cURL-based requests | Complex HTTP scenarios |
| **CUSTOM_CURL** | Custom cURL commands | Advanced monitoring needs |

### Alert Settings

Configure in user settings:
- **Email Notifications**: SMTP-based email alerts
- **Telegram Notifications**: Bot-based Telegram messages
- **Alert Cooldown**: Prevent alert spam (default: 30 minutes)
- **Quiet Hours**: Schedule no-alert periods
- **Uptime Thresholds**: Minimum uptime percentage for alerts
- **Recovery Notifications**: Get notified when services recover

### Database Schema

### Core Tables

- **Users**: User accounts, roles, and alert preferences
- **Websites**: Monitoring targets with configuration
- **MonitorLogs**: Historical check results and response times
- **Alerts**: Sent alert history and notification tracking

## 🚨 Troubleshooting

### Common Issues

**Database Connection Errors:**
```bash
# Check PostgreSQL status
sudo systemctl status postgresql

# Test connection
psql -h localhost -U inframon_user -d InfraMon
```

**Backend Service Issues:**
```bash
# Check PM2 status
pm2 status
pm2 logs inframon-backend

# Restart service
pm2 restart inframon-backend
```

**Frontend Build Issues:**
```bash
# Clear cache and reinstall
rm -rf node_modules package-lock.json
npm install
npm run build
```

**Real-time Updates Not Working:**
- Check SSE endpoint connectivity
- Verify proxy configuration for `/events` endpoint
- Check browser console for WebSocket errors

### Logs Location

- **Backend**: PM2 logs (`pm2 logs inframon-backend`)
- **Frontend**: Browser developer console
- **Database**: PostgreSQL logs (`/var/log/postgresql/`)
- **Nginx**: `/var/log/nginx/access.log` and `error.log`

## 📊 Monitoring Best Practices

1. **Start Simple**: Begin with HTTP GET for basic monitoring
2. **Set Realistic Intervals**: 5-15 minutes for production systems
3. **Use Appropriate Methods**:
   - HTTP for web applications
   - PING for server connectivity
   - CURL for API endpoints
4. **Configure Alert Cooldowns**: Prevent notification fatigue
5. **Set Up Quiet Hours**: Respect off-hours for non-critical systems
6. **Monitor Response Times**: Track performance degradation
7. **Regular Review**: Periodically check alert patterns and thresholds

## 🔒 Security Considerations

1. **Change Default Credentials**: Immediately after first login
2. **Use Strong Secrets**: JWT secrets and database passwords
3. **Secure Database**: Use strong passwords and limit network access
4. **HTTPS Enforcement**: Always use SSL in production
5. **CORS Configuration**: Restrict to trusted domains
6. **Regular Updates**: Keep dependencies updated
7. **Access Control**: Implement proper role-based permissions
8. **Input Validation**: Sanitize all user inputs, especially CURL commands

## 🤝 Contributing

We welcome contributions! Please see our contributing guidelines:

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## 📄 License

This project is licensed under the ISC License - see the [LICENSE](LICENSE) file for details.

## 🆘 Support

- **Documentation**: Check this README and code comments
- **Issues**: Create a GitHub issue for bugs and feature requests
- **Discussions**: Use GitHub Discussions for questions and ideas
- **Email**: Contact the maintainers for security issues

## 🙏 Acknowledgments

- Built with [Node.js](https://nodejs.org//) and [React](https://reactjs.org/)
- Database ORM with [Sequelize](https://sequelize.org/)
- Styling with [Tailwind CSS](https://tailwindcss.com/)
- Icons from [Lucide React](https://lucide.dev/)

---

**InfraMon** - Monitor your infrastructure with confidence! 🚀

For more information, visit our [GitHub repository](https://github.com/d3adb0d7/InfraMon) or join our [community discussions](https://github.com/d3adb0d7/InfraMon/discussions).