# Aplicação Flutter



## Descrição

A ponderada 2 é uma atividade que visa avaliar a capacidade de análise e síntese do aluno, bem como a capacidade de aplicar os conceitos aprendidos em sala de aula. A atividade consiste em integrar a API com o APP em Flutter, de forma que o APP seja capaz de consumir os dados da API e exibi-los de forma organizada e amigável ao usuário.

## Monolito ou Microsserviços?

Por ser uma API desenvolvida em Clean Architecture, a API é um monolito. A API foi desenvolvida em Clean Architecture, de forma que a aplicação seja dividida em camadas, facilitando a manutenção e a evolução da aplicação. Além da temática da API ser de funcionamento simples, não havendo a necessidade de dividir a aplicação em microsserviços.

## Sincrona ou Assincrona?

A API por mais que possui os mecanismos para ser assíncrona, foi desenvolvida de forma síncrona. A API foi desenvolvida de forma síncrona, pois a temática da API é de funcionamento simples, não havendo a necessidade de desenvolver a aplicação de forma assíncrona.

## Como rodar a aplicação?

### Backend

Na pasta raiz do projeto, execute o comando `docker-compose up --build` para subir o container do banco de dados e da aplicação. A aplicação estará disponível em `http://localhost:8000/docs` com o Swagger.

### Frontend

Na pasta `mobile/src`, execute o comando `flutter run` para rodar a aplicação em modo de desenvolvimento.

## Integrações Realizadas

- [X] Login
- [X] Sign up
- [X] Listagem de Tags
- [X] Cadastro de Tag
- [X] Edição de Tag
- [X] Exclusão de Tag
- [X] Uma última rota de recuperação de informações do usuário logado

## Estrutura do APP

Na pasta `mobile/src/lib`, a estrutura do APP foi dividida em:

- `Controllers`: Onde estão os controllers da aplicação.
- `Models`: Onde estão os modelos da aplicação.
- `Pages`: Onde estão as páginas da aplicação.
- `Repositories`: Onde estão os repositórios da aplicação.

### Libs Utilizadas

- `http`: Para realizar as requisições HTTP.
- `shared_preferences`: Para armazenar informações locais.


## Vídeo de Demonstração

<iframe width="560" height="315" src="https://www.youtube.com/embed/NOtkBtGJrc4" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>