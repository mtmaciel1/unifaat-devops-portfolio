const express = require('express');
const app = express();
const PORT = process.env.PORT || 3000;

app.use(express.json());

app.get('/', (req, res) => {
  res.json({
    servico: 'DevOps Portfolio - Sistemas de Pedidos',
    aluno: 'SEU NOME AQUI',
    ra: 'SEU RA AQUI',
    aula: '01 - Fundamentos de Git e Docker',
    status: 'online',
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
});