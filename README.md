# Desafio técnico e-commerce

## Nossas expectativas

A equipe de engenharia da RD Station tem alguns princípios nos quais baseamos nosso trabalho diário. Um deles é: projete seu código para ser mais fácil de entender, não mais fácil de escrever.

Portanto, para nós, é mais importante um código de fácil leitura do que um que utilize recursos complexos e/ou desnecessários.

O que gostaríamos de ver:

- O código deve ser fácil de ler. Clean Code pode te ajudar.
- Notas gerais e informações sobre a versão da linguagem e outras informações importantes para executar seu código.
- Código que se preocupa com a performance (complexidade de algoritmo).
- O seu código deve cobrir todos os casos de uso presentes no README, mesmo que não haja um teste implementado para tal.
- A adição de novos testes é sempre bem-vinda.
- Você deve enviar para nós o link do repositório público com a aplicação desenvolvida (GitHub, BitBucket, etc.).

## Como executar o projeto
Requisitos:
- Docker
- Docker-compose

### Executando a app com o docker
Seguir os comandos abaixo para rodar a app com docker:

Realizar o clone do projeto:
```
  `git clone git@github.com:philipeleandro/tech-interview-backend-entry-level-main.git`
  ou `git clone https://github.com/philipeleandro/tech-interview-backend-entry-level-main.git`
  cd tech-interview-backend-entry-level-main
````

Parar os serviços do redis e do postgres para garantir que não estão rodando com outros serviços:
```
  sudo systemctl stop postgresql
  sudo systemctl stop redis-server.service
```

Buildar a imagem do docker-compose e subir os containers:
```
  docker compose build
  docker compose up web db redis sidekiq
```

Rodar o comando abaixo para listar os containers e buscar o nome do container web:
```
  docker container ls
```

O nome do container é `tech-interview-backend-entry-level-main-web-1`

Executar o comando abaixo para acessar o container web e rodar os comandos:

```
  docker exec -it nome_do_container_web bash
  bundle exec rails db:create
  bundle exec rails db:migrate
  bundle exec rails db:seed
```

O arquivo seeds.rb irá criar um usuário para que utilize nos proximos passos:
```js
    "email": "rd_station_test@test.com"
    "password": "password"
```

## Observações
Os endpoints descritos abaixo necessitam de autenticação, então deve-se passar um token para isso

### POST /users/tokens/sign_in
Use esse endpoint para gerar um token e usa-lo nos headers dos endpoints seguintes

POST ROTA: `/users/tokens/sign_in`
Payload:
```js
{
    "email": "rd_station_test@test.com",
    "password": "password"
}
```

Response body:
```js
  "token": "string",
  "refresh_token": "string",
  "expires_in": "integer",
  "token_type": "string",
  "resource_owner": {
      "id": "integer",
      "email": "string",
      "created_at": "string",
      "updated_at": "string"
  }
```

Nos casos seguintes, passar a chave Authorization nos headers com o valor `Bearer "token"`. Exemplo:
```js
  { "Authorization": "Bearer 'token'"} // 'token' é o valor de retorno "token" na requisição da rota `/users/tokens/sign_in`
```

## O Desafio - Carrinho de compras
O desafio consiste em uma API para gerenciamento do um carrinho de compras de e-commerce.

Você deve desenvolver utilizando a linguagem Ruby e framework Rails, uma API Rest que terá 3 endpoins que deverão implementar as seguintes funcionalidades:

### 1. Registrar um produto no carrinho
Criar um endpoint para inserção de produtos no carrinho.

Se não existir um carrinho para a sessão, criar o carrinho e salvar o ID do carrinho na sessão.

Adicionar o produto no carrinho e devolver o payload com a lista de produtos do carrinho atual.


POST ROTA: `/cart`
Payload:
```js
{
  "product_id": 1, // id do produto sendo adicionado
  "quantity": 2 // quantidade de produto a ser adicionado
}
```

Response
```js
{
  "id": 1, // id do carrinho
  "products": [
    {
      "id": 1,
      "name": "Nome do produto",
      "quantity": 2,
      "unit_price": 1.99, // valor unitário do produto
      "total_price": 3.98, // valor total do produto
    }
  ],
  "total_price": 3.98 // valor total no carrinho
}
```

### 2. Listar itens do carrinho atual
Criar um endpoint para listar os produtos no carrinho atual.

GET ROTA: `/cart`

Response:
```js
{
  "id": 1, // id do carrinho
  "products": [
    {
      "id": 1,
      "name": "Nome do produto",
      "quantity": 2,
      "unit_price": 1.99, // valor unitário do produto
      "total_price": 3.98, // valor total do produto
    },
    {
      "id": 2,
      "name": "Nome do produto 2",
      "quantity": 2,
      "unit_price": 1.99,
      "total_price": 3.98,
    },
  ],
  "total_price": 7.96 // valor total no carrinho
}
```

### 3. Alterar a quantidade de produtos no carrinho
Um carrinho pode ter _N_ produtos, se o produto já existir no carrinho, apenas a quantidade dele deve ser alterada

POST ROTA: `/cart/add_item`

Payload
```json
{
  "product_id": 1,
  "quantity": 1
}
```
Response:
```json
{
  "id": 1,
  "products": [
    {
      "id": 1,
      "name": "Nome do produto X",
      "quantity": 2, // considerando que esse produto já estava no carrinho
      "unit_price": 7.00, 
      "total_price": 14.00, 
    },
    {
      "id": 2,
      "name": "Nome do produto Y",
      "quantity": 1,
      "unit_price": 9.90, 
      "total_price": 9.90, 
    },
  ],
  "total_price": 23.9
}
```

### 4. Remover um produto do carrinho 

Criar um endpoint para excluir um produto do do carrinho. 

DELETE ROTA: `/cart/:product_id`
EX: `http://localhost:3000/cart/1`

Response:
```json
{
  "id": 1,
  "products": [
    {
      "id": 2,
      "name": "Nome do produto Y",
      "quantity": 1,
      "unit_price": 9.90, 
      "total_price": 9.90, 
    }
  ],
  "total_price": 9.90
}


#### Detalhes adicionais:

- Verifique se o produto existe no carrinho antes de tentar removê-lo.
- Se o produto não estiver no carrinho, retorne uma mensagem de erro apropriada.
- Após remover o produto, retorne o payload com a lista atualizada de produtos no carrinho.
- Certifique-se de que o endpoint lida corretamente com casos em que o carrinho está vazio após a remoção do produto.

### 5. Excluir carrinhos abandonados
  Pode ser validado no navegador com a url `http://localhost:3000/sidekiq` e validar que tem jobs sendo processados

Um carrinho é considerado abandonado quando estiver sem interação (adição ou remoção de produtos) há mais de 3 horas.

- Quando este cenário ocorrer, o carrinho deve ser marcado como abandonado.
- Se o carrinho estiver abandonado há mais de 7 dias, remover o carrinho.
- Utilize um Job para gerenciar (marcar como abandonado e remover) carrinhos sem interação.
- Configure a aplicação para executar este Job nos períodos especificados acima.

### Detalhes adicionais:
- O Job deve ser executado regularmente para verificar e marcar carrinhos como abandonados após 3 horas de inatividade.
- O Job também deve verificar periodicamente e excluir carrinhos que foram marcados como abandonados por mais de 7 dias.

### Como resolver

#### Implementação
Você deve usar como base o código disponível nesse repositório e expandi-lo para que atenda as funcionalidade descritas acima.

Há trechos parcialmente implementados e também sugestões de locais para algumas das funcionalidades sinalizados com um `# TODO`. Você pode segui-los ou fazer da maneira que julgar ser a melhor a ser feita, desde que atenda os contratos de API e funcionalidades descritas.

#### Testes
Existem testes pendentes, eles estão marcados como <span style="color:green;">Pending</span>, e devem ser implementados para garantir a cobertura dos trechos de código implementados por você.
Alguns testes já estão passando e outros estão com erro. Com a sua implementação os testes com erro devem passar a funcionar. 
A adição de novos testes é sempre bem-vinda, mas sem alterar os já implementados.


### O que esperamos
- Implementação dos testes faltantes e de novos testes para os métodos/serviços/entidades criados
- Construção das 4 rotas solicitadas
- Implementação de um job para controle dos carrinhos abandonados


### Itens adicionais / Legais de ter
- Utilização de factory na construção dos testes
- Desenvolvimento do docker-compose / dockerização da app

A aplicação já possui um Dockerfile, que define como a aplicação deve ser configurada dentro de um contêiner Docker. No entanto, para completar a dockerização da aplicação, é necessário criar um arquivo `docker-compose.yml`. O arquivo irá definir como os vários serviços da aplicação (por exemplo, aplicação web, banco de dados, etc.) interagem e se comunicam.

- Adicione tratamento de erros para situações excepcionais válidas, por exemplo: garantir que um produto não possa ter quantidade negativa. 

- Se desejar você pode adicionar a configuração faltante no arquivo `docker-compose.yml` e garantir que a aplicação rode de forma correta utilizando Docker. 

## Informações técnicas

### Dependências
- ruby 3.3.1
- rails 7.1.3.2
- postgres 16
- redis 7.0.15

### Como enviar seu projeto
Salve seu código em um versionador de código (GitHub, GitLab, Bitbucket) e nos envie o link publico. Se achar necessário, informe no README as instruções para execução ou qualquer outra informação relevante para correção/entendimento da sua solução.
