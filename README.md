# Desafio de Projeto de Banco de Dados - E-commerce

Este repositório contém a resolução do Desafio de Projeto de Banco de Dados para um cenário de E-commerce, proposto no bootcamp da DIO. O objetivo foi aplicar os conhecimentos de modelagem de banco de dados, desde o esquema Entidade-Relacionamento (EER) até a criação de scripts SQL para manipulação e consulta de dados.

## 📝 Descrição do Cenário Lógico

O projeto consiste em replicar e refinar a modelagem de um banco de dados para um sistema de e-commerce. O modelo inicial foi aprimorado para atender a requisitos de negócio específicos, resultando em um esquema relacional mais robusto e completo.

### Refinamentos Aplicados

O modelo lógico foi refinado para incluir as seguintes regras de negócio:

- **Cliente (Pessoa Física ou Jurídica):** Um cliente pode ser cadastrado como Pessoa Física (PF) ou Pessoa Jurídica (PJ), mas nunca ambos simultaneamente. Esta é uma relação de generalização/especialização.

  - **Cliente (Tabela `clients`):** Armazena os dados comuns a todos os clientes.
  - **Pessoa Física (Tabela `natural_person`):** Armazena o CPF e herda os dados da tabela `clients`.
  - **Pessoa Jurídica (Tabela `legal_person`):** Armazena o CNPJ, Razão Social e herda os dados da tabela `clients`.

- **Múltiplas Formas de Pagamento:** Um cliente pode ter mais de uma forma de pagamento associada à sua conta, e um pedido pode ser pago com uma combinação dessas formas.

  - **Pagamento (Tabela `payments`):** Tabela que relaciona os pedidos, clientes e as formas de pagamento utilizadas.

- **Entrega com Status e Rastreio:** Cada pedido possui um serviço de entrega associado, que deve conter um status atualizado e um código de rastreamento para acompanhamento.
  - **Entrega (Tabela `delivery`):** Armazena o `status` e o `tracking_code` de cada pedido.

## 🗂️ Esquema Relacional

O diagrama abaixo representa o esquema relacional final implementado.


[clients] <--1-- [natural_person]

[clients] <--1-- [legal_person]

[clients] --1<-- [orders]

[orders] --1<-- [delivery]

[orders] --1<-- [payments]

[orders] >--0< [product] (via [product_order])

[product] >--0< [supplier] (via [product_supplier])

[product] >--0< [seller] (via [product_seller])

[product] >--0< [storage] (via [product_storage])


## 🚀 Scripts SQL

O arquivo `script.sql` está dividido em três seções principais:

1.  **DDL (Data Definition Language):** Contém os comandos `CREATE TABLE` para construir toda a estrutura do banco de dados, incluindo chaves primárias, estrangeiras e constraints de integridade.
2.  **DML (Data Manipulation Language):** Seção com comandos `INSERT INTO` para popular o banco de dados com dados fictícios, permitindo a execução e teste das consultas.
3.  **DQL (Data Query Language):** Uma série de consultas SQL elaboradas para extrair informações relevantes do banco de dados, respondendo a perguntas de negócio específicas e utilizando as cláusulas exigidas no desafio (`SELECT`, `WHERE`, `JOIN`, `ORDER BY`, `GROUP BY` e `HAVING`).

### Perguntas de Negócio Respondidas pelas Queries

As consultas foram criadas para responder às seguintes perguntas:

- Quantos pedidos foram feitos por cada cliente?
- Qual é a relação de produtos, fornecedores e seus respectivos estoques?
- Qual o nome dos fornecedores e os nomes dos produtos que eles fornecem?
- Existem vendedores que também são fornecedores?
- Quais clientes (PF) fizeram 2 ou mais pedidos e qual o valor total gasto?
- Listar todos os produtos da categoria 'Eletrônico' ordenados do mais caro para o mais barato.
- Qual o status dos pedidos e suas respectivas informações de entrega e pagamento?

---

Obrigado por avaliar este desafio!
