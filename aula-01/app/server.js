const express = require('express');
const app = express();
const PORT = process.env.PORT || 3000;

app.use(express.json());

app.get('/', (req, res) => {
  res.json({
    servico: 'DevOps Portfolio API',
    aluno: 'SEU NOME AQUI',
    ra: 'SEU RA AQUI',
    aula: '01 - Fundamentos de Git e Docker',
    status: 'online',
    timestamp: new Date().toISOString()
  });
});

app.listen(PORT, () => {
  console.log(`Servidor rodando na porta ${PORT}`);
});