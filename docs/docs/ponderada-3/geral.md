# Atividade Ponderada - Construção de Aplicativo Híbrido com Flutter

A atividade Ponderada consiste em construir uma aplicação Flutter, integrado a um backend em microsserviços, que seja capaz de consumir os dados da API e exibi-los de forma organizada, além da integração com Nginx e Docker.

## Estrutura de Pastas

```
.
├── microsservices/
├── mobile/
├── nginx/
└── docker-compose.yml
```

- `microsservices/`: Contém os microsserviços que serão utilizados na atividade.
   - `photos/`: Microsserviço responsável por gerenciar as fotos.
   - `user/`: Microsserviço responsável por gerenciar os usuários.
- `mobile/`: Contém o projeto Flutter.
- `nginx/`: Contém o arquivo de configuração do Nginx.
- `docker-compose.yml`: Arquivo de configuração do Docker Compose.

## Rodando a Aplicação

Para rodar a aplicação, basta executar o comando `docker-compose up` na raiz do projeto.

```bash
docker-compose up
```

Após a execução do comando, o swagger dos microsserviços estará disponível nos seguintes endereços:

- `http://localhost:8000/docs/`: Swagger do microsserviço de fotos.
- `http://localhost:8001/docs/`: Swagger do microsserviço de usuários.

O Backend estará disponível nos seguintes endereços:

- `http://localhost:7000/`: Microsserviço passando pelo Nginx.
  - `http://localhost:7000/auth`: Microsserviço de usuários passando pelo Nginx.
  - `http://localhost:7000/photo`: Microsserviço de fotos passando pelo Nginx.
  
## Mobile

O projeto Flutter está localizado na pasta `mobile/`. Para rodar o projeto, basta executar o comando `flutter run` na pasta do projeto.

```bash

cd mobile/ && flutter run

```

## Telas Integradas

- **Tela de Login:** Tela de login que permite o usuário se autenticar no sistema.
- **Tela de Cadastro:** Tela de cadastro que permite o usuário se cadastrar no sistema.
- **Tela de Fotos:** Tela que exibe as fotos cadastradas no sistema.
- **Tela de Visualização de Foto:** Tela que exibe uma foto específica.
- **Tela de Tirar Foto:** Tela que permite o usuário tirar uma foto e cadastrá-la no sistema.
- **Notificações:** Notificações de envio de fotos e sucesso no cadastro.



## Vídeo de Demonstração

<iframe width="560" height="315" src="https://www.youtube.com/embed/RjNtn6tuZNk" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>
