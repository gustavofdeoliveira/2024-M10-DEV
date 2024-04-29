---
sidebar_position: 3
---

# Workflows

Os workflows são uma maneira de automatizar tarefas e fluxos de trabalho. Eles são compostos por uma série de ações, que são executadas em sequência. Cada ação é uma etapa individual que pode ser executada em diferentes ambientes, como Linux, Windows ou macOS. Atualmente, o GitHub Actions é a ferramenta utilizada para a criação e utilização de workflows para esse projeto.

## Objetivo dos Workflows

Por meio dos workflows, é possível automatizar tarefas como testes, deploy, build, entre outras. Dessa forma, é possível garantir a qualidade do código e a integridade do projeto, além de facilitar a colaboração entre os membros da equipe.

## Docusaurus

Atualmente, o Docusaurus é utilizado para a documentação do projeto. O Docusaurus é uma ferramenta de código aberto para a construção de sites estáticos. Ele é fácil de configurar e personalizar, e possui uma série de recursos que facilitam a criação de documentação de qualidade.

### GitHub Actions - YML

```yml	
name: Deploy Docusaurus

on:
  push:
    branches: ["main"]
    paths:
      - "docs/**"
  workflow_dispatch:

permissions:
  contents: read
  pages: write
  id-token: write

concurrency:
  group: "pages"
  cancel-in-progress: true

env:
  NODE_OPTIONS: --max-old-space-size=6144

jobs:
  build-docusaurus:
    environment:
      name: github-pages
      url: ${{ steps.deployment.outputs.page_url }}
    runs-on: ubuntu-latest

    steps:
      - name: Checkout code
        uses: actions/checkout@v4

      - name: Setup Node.js
        uses: actions/setup-node@v4
        with:
          node-version: 20

      - name: Install and Build
        run: |
          cd docs
          npm install
          npm run build
          mv build ../build

      - name: Setup Pages
        uses: actions/configure-pages@v4

      - name: Upload artifact
        uses: actions/upload-pages-artifact@v3
        with:
          path: ./build

      - name: Deploy to GitHub Pages
        id: deployment
        uses: actions/deploy-pages@v4

```

## Testes

Os testes são uma parte fundamental do desenvolvimento de software. Eles garantem que o código está funcionando corretamente e que as alterações feitas não quebraram funcionalidades existentes. Atualmente, o Pytest é utilizado para a realização dos testes no projeto.

### GitHub Actions - YML

```yml
name: pytest

on:
  push:
    branches:
      - main

jobs:
  test:
    runs-on: ubuntu-latest
    env:
      ENV: test
      DB_USER: test
      DB_PASSWORD: test
      DB_HOST: localhost
      DB_PORT: 5432
      DB: postgresql
    strategy:
      matrix:
        python-version: ["3.10"]
    services:
      postgres:
        image: postgres:14
        env:
          POSTGRES_USER: test
          POSTGRES_PASSWORD: test
          POSTGRES_DB: postgres
        ports:
          - 5432:5432
        options: --health-cmd pg_isready --health-interval 10s --health-timeout 5s --health-retries 5

    steps:
      - uses: actions/checkout@v3

      - name: Set up Python ${{ matrix.python-version }}
        uses: actions/setup-python@v4
        with:
          python-version: ${{ matrix.python-version }}

      - name: Install dependencies
        working-directory: ./ponderada-1/src/
        run: pip install -r requirements.txt

      - name: pytest
        working-directory: ./ponderada-1/src/
        run: pytest

```