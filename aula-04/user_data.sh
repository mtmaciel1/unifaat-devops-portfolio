#!/bin/bash
set -e

LOG_FILE="/var/log/technova-setup.log"

log() {
  echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" | tee -a "$LOG_FILE"
}

log "Iniciando configuracao da TechNova API"

dnf update -y >> "$LOG_FILE" 2>&1

log "Instalando Git"
dnf install -y git >> "$LOG_FILE" 2>&1

log "Configurando Node.js 18"
curl -fsSL https://rpm.nodesource.com/setup_18.x | bash - >> "$LOG_FILE" 2>&1
dnf install -y nodejs >> "$LOG_FILE" 2>&1

log "Criando aplicacao"

mkdir -p /home/ec2-user/api

cat > /home/ec2-user/api/package.json <<'EOF'
{
  "name": "technova-api",
  "version": "1.0.0",
  "main": "index.js",
  "scripts": {
    "start": "node index.js"
  },
  "dependencies": {
    "express": "^4.18.2"
  }
}
EOF

cat > /home/ec2-user/api/index.js <<'EOF'
const express = require("express");
const os = require("os");

const app = express();
const PORT = 3000;

app.get("/", (req, res) => {
  res.json({
    message: "TechNova API - Rodando na AWS!",
    hostname: os.hostname()
  });
});

app.get("/health", (req, res) => {
  res.json({
    status: "healthy",
    service: "technova-api"
  });
});

app.get("/orders", (req, res) => {
  res.json({
    orders: [
      { id: 1, product: "Widget A", status: "shipped" },
      { id: 2, product: "Widget B", status: "pending" }
    ]
  });
});

app.listen(PORT, "0.0.0.0", () => {
  console.log(`TechNova API rodando na porta ${PORT}`);
});
EOF

cd /home/ec2-user/api
npm install >> "$LOG_FILE" 2>&1

chown -R ec2-user:ec2-user /home/ec2-user/api

log "Criando servico systemd"

cat > /etc/systemd/system/technova-api.service <<'EOF'
[Unit]
Description=TechNova Node.js API
After=network.target

[Service]
Type=simple
User=ec2-user
WorkingDirectory=/home/ec2-user/api
ExecStart=/usr/bin/node /home/ec2-user/api/index.js
Restart=always
RestartSec=5

[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reload
systemctl enable technova-api
systemctl start technova-api

log "TechNova API configurada com sucesso"