const express = require('express');
const app = express();
const PORT = process.env.PORT || 3000;

const DB_HOST = process.env.DB_HOST || 'localhost';
const DB_PORT = process.env.DB_PORT || 5432;
const DB_NAME = process.env.DB_NAME || 'technova';
const DB_USER = process.env.DB_USER || 'technova';
const DB_PASSWORD = process.env.DB_PASSWORD || '';

app.use(express.json());

app.get('/', (req, res) => {
  res.json({
    servico: 'DevOps Portfolio API',
    aluno: 'Matheus Maciel de Paula',
    ra: '6325065',
    aula: '01 - Fundamentos de Git e Docker',
    status: 'online',
    banco: `${DB_HOST}:${DB_PORT}/${DB_NAME}`,
    timestamp: new Date().toISOString()
  });
});

app.get('/health', (req, res) => {
  res.json({ 
    status: 'healthy',
    timestamp: new Date().toISOString(),
    service: 'devops-portfolio-api',
    version: '1.0.0'
  });
});

app.get('/info', (req, res) => {
  res.json({
    empresa: 'TechNova',
    projeto: 'Portfólio DevOps - UniFAAT 2026-2',
    equipe: 'Platform Engineering',
    ambiente: process.env.NODE_ENV || 'development'
  });
});

app.listen(PORT, () => {
  console.log(`Servidor rodando na porta ${PORT}`);
  console.log(`Banco de dados: ${DB_HOST}:${DB_PORT}/${DB_NAME}`);
});