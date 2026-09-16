# Azis / Projeto Integrador

Plataforma acadêmica colaborativa de tarefas e gamificação: organização de equipes,
quadro Kanban, pontos e acompanhamento do trabalho.

**Stack desta versão:** React + TypeScript + Vite no frontend; Node.js + Express
na API; PostgreSQL; Docker Compose para o ambiente local.

## Origem e colaboração

Este repositório é um **fork de [gigioaf/Projeto_Integrador](https://github.com/gigioaf/Projeto_Integrador)**,
na rede de [mylenamunizz/Projeto_Integrador](https://github.com/mylenamunizz/Projeto_Integrador).
O [Azis de LariWerneck](https://github.com/LariWerneck/Azis) é outra referência do
projeto do grupo. Os históricos dessas versões não devem ser tratados como idênticos.

O projeto foi desenvolvido em equipe. A tabela abaixo delimita as contribuições
registradas de Guilherme Luizatto neste fork, sem atribuir a ele a criação de
todo o sistema.

## Contribuições de Guilherme Luizatto

| Commit | Alteração registrada |
| --- | --- |
| [48ce486](https://github.com/GuilhermeLuizatto/Projeto_Integrador/commit/48ce4860b6de50bd49d6af4ab524bd2d1b919261) | Ajustes de perfil e histórico de pontos; atualização de dados na interface; campo e tratamento de prazo no Kanban; preservação de pontos na inicialização do banco. |
| [b73be3e](https://github.com/GuilhermeLuizatto/Projeto_Integrador/commit/b73be3e1006bdce5abf53acbe1d0ce6fe2ff0710) | Correção do caminho de migração SQL, valores padrão e persistência local do PostgreSQL no Compose. |
| [1329f10](https://github.com/GuilhermeLuizatto/Projeto_Integrador/commit/1329f10c1ce6e6cb4078f4e57255a9a7b8aebc57) | Inclusão de arquivo de backup SQL no histórico; não equivale à autoria de todos os dados ou do esquema. |
| [651aff4](https://github.com/GuilhermeLuizatto/Projeto_Integrador/commit/651aff48889c50e7bbe4a9ad0ef6596a6b1638d9) | Ajuste de arquivo ignorado pelo Git. |

Os dois primeiros commits registram coautoria de Copilot.
Há contribuições anteriores de Guilherme na versão
[prj-integrador](https://github.com/GuilhermeLuizatto/prj-integrador).

## Arquitetura

```text
React / TypeScript / Vite
          |
          v
API REST — Node.js / Express
          |
          v
       PostgreSQL
```

| Diretório | Responsabilidade |
| --- | --- |
| [frontend/src](frontend/src) | Páginas, componentes e comunicação com a API |
| [backend/routes](backend/routes) | Rotas da API |
| [backend/controllers](backend/controllers) | Operações de usuários, tarefas e demais módulos |
| [backend/config](backend/config) | Conexão e inicialização do banco |
| [backend/src/migrations](backend/src/migrations) | Migrações SQL |
| [docker-compose.yml](docker-compose.yml) | Frontend, backend e PostgreSQL locais |

A implementação inclui autenticação JWT e verificações por perfil/nível de acesso.
Trata-se de código acadêmico em evolução, sem afirmação de prontidão para produção.

## Executar localmente

Pré-requisitos: Git e Docker com Docker Compose.

```bash
git clone https://github.com/GuilhermeLuizatto/Projeto_Integrador.git
cd Projeto_Integrador
docker compose up --build
```

- Frontend: <http://localhost:8080>
- API: <http://localhost:3000>
- Verificação simples da API: <http://localhost:3000/health>

As portas 8080, 3000 e 5432 precisam estar livres. O Compose configura o backend
para acessar o serviço `database` e guarda os dados em `data/postgres`.
A inicialização do banco é chamada por `backend/server.js`.
O fluxo acima não depende de restaurar o arquivo de backup do repositório.

Para encerrar:

```bash
docker compose down
```

A pasta de dados persiste após esse comando.

## Qualidade e limites

- O frontend declara comandos de build, lint e testes em [package.json](frontend/package.json).
- O comando `npm test` do backend ainda é um placeholder que termina com erro.
- A configuração local contém credenciais de desenvolvimento e dados de
  inicialização; use somente dados fictícios e não a exponha como produção.
- As instruções foram conferidas contra os arquivos do projeto; executar os
  containers continua sendo uma verificação separada.

## Créditos

Preserve os autores e coautores no
[histórico](https://github.com/GuilhermeLuizatto/Projeto_Integrador/commits/main/).
Este fork documenta uma participação em projeto colaborativo.
