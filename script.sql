CREATE DATABASE IF NOT EXISTS ecommerce;
USE ecommerce;

-- Tabela: clients (Generalização)
CREATE TABLE clients(
    idClient INT AUTO_INCREMENT PRIMARY KEY,
    Fname VARCHAR(45),
    Minit CHAR(3),
    Lname VARCHAR(45),
    Address VARCHAR(255),
    clientType ENUM('PF', 'PJ') NOT NULL COMMENT 'PF = Pessoa Física, PJ = Pessoa Jurídica'
);

-- Tabela: natural_person (Especialização de clients)
CREATE TABLE natural_person(
    idNaturalPerson INT AUTO_INCREMENT PRIMARY KEY,
    idClient INT,
    CPF CHAR(11) NOT NULL,
    BirthDate DATE,
    CONSTRAINT uq_cpf_natural_person UNIQUE (CPF),
    CONSTRAINT fk_np_client FOREIGN KEY (idClient) REFERENCES clients(idClient) ON DELETE CASCADE
);

-- Tabela: legal_person (Especialização de clients)
CREATE TABLE legal_person(
    idLegalPerson INT AUTO_INCREMENT PRIMARY KEY,
    idClient INT,
    SocialName VARCHAR(255) NOT NULL,
    CNPJ CHAR(14) NOT NULL,
    CONSTRAINT uq_cnpj_legal_person UNIQUE (CNPJ),
    CONSTRAINT fk_lp_client FOREIGN KEY (idClient) REFERENCES clients(idClient) ON DELETE CASCADE
);

-- Tabela: product
CREATE TABLE product(
    idProduct INT AUTO_INCREMENT PRIMARY KEY,
    Pname VARCHAR(255) NOT NULL,
    category ENUM('Eletrônico', 'Vestimenta', 'Brinquedos', 'Alimentos', 'Móveis') NOT NULL,
    evaluation FLOAT DEFAULT 0,
    size VARCHAR(10),
    price FLOAT NOT NULL
);

-- Tabela: supplier
CREATE TABLE supplier(
    idSupplier INT AUTO_INCREMENT PRIMARY KEY,
    SocialName VARCHAR(255) NOT NULL,
    CNPJ CHAR(14) NOT NULL,
    contact CHAR(11) NOT NULL,
    CONSTRAINT uq_cnpj_supplier UNIQUE (CNPJ)
);

-- Tabela: seller
CREATE TABLE seller(
    idSeller INT AUTO_INCREMENT PRIMARY KEY,
    SocialName VARCHAR(255) NOT NULL,
    AbstName VARCHAR(255),
    CNPJ CHAR(14),
    CPF CHAR(11),
    location VARCHAR(255),
    contact CHAR(11) NOT NULL,
    CONSTRAINT uq_cnpj_seller UNIQUE (CNPJ),
    CONSTRAINT uq_cpf_seller UNIQUE (CPF)
);

-- Tabela: storage
CREATE TABLE storage(
    idStorage INT AUTO_INCREMENT PRIMARY KEY,
    location VARCHAR(255),
    quantity INT DEFAULT 0
);

-- Tabela: orders
CREATE TABLE orders(
    idOrder INT AUTO_INCREMENT PRIMARY KEY,
    idClient INT,
    orderStatus ENUM('Cancelado', 'Confirmado', 'Em processamento', 'Enviado') DEFAULT 'Em processamento',
    orderDescription VARCHAR(255),
    shippingCost FLOAT DEFAULT 10,
    CONSTRAINT fk_orders_client FOREIGN KEY (idClient) REFERENCES clients(idClient) ON UPDATE CASCADE
);

-- Tabela: payments
CREATE TABLE payments(
    idPayment INT AUTO_INCREMENT PRIMARY KEY,
    idOrder INT,
    idClient INT,
    paymentType ENUM('Boleto', 'Cartão', 'Dois cartões'),
    limitAvailable FLOAT,
    CONSTRAINT fk_payment_order FOREIGN KEY (idOrder) REFERENCES orders(idOrder),
    CONSTRAINT fk_payment_client FOREIGN KEY (idClient) REFERENCES clients(idClient)
);

-- Tabela: delivery
CREATE TABLE delivery(
    idDelivery INT AUTO_INCREMENT PRIMARY KEY,
    idOrder INT,
    status ENUM('Aguardando Envio', 'Enviado', 'Em Trânsito', 'Entregue') NOT NULL,
    tracking_code VARCHAR(50) NOT NULL,
    CONSTRAINT fk_delivery_order FOREIGN KEY (idOrder) REFERENCES orders(idOrder)
);

-- Tabelas de Relacionamento N:M

CREATE TABLE product_storage(
    idProdStorage INT AUTO_INCREMENT PRIMARY KEY,
    idProduct INT,
    idStorage INT,
    quantity INT DEFAULT 1,
    CONSTRAINT fk_ps_product FOREIGN KEY (idProduct) REFERENCES product(idProduct),
    CONSTRAINT fk_ps_storage FOREIGN KEY (idStorage) REFERENCES storage(idStorage)
);

CREATE TABLE product_order(
    idPOorder INT AUTO_INCREMENT PRIMARY KEY,
    idOrder INT,
    idProduct INT,
    poQuantity INT DEFAULT 1,
    poStatus ENUM('Disponível', 'Sem estoque') DEFAULT 'Disponível',
    CONSTRAINT fk_po_order FOREIGN KEY (idOrder) REFERENCES orders(idOrder),
    CONSTRAINT fk_po_product FOREIGN KEY (idProduct) REFERENCES product(idProduct)
);

CREATE TABLE product_supplier(
    idProdSupplier INT AUTO_INCREMENT PRIMARY KEY,
    idSupplier INT,
    idProduct INT,
    quantity INT NOT NULL,
    CONSTRAINT fk_product_supplier_supplier FOREIGN KEY (idSupplier) REFERENCES supplier(idSupplier),
    CONSTRAINT fk_product_supplier_prodcut FOREIGN KEY (idProduct) REFERENCES product(idProduct)
);

CREATE TABLE product_seller(
    idPseller INT AUTO_INCREMENT PRIMARY KEY,
    idSeller INT,
    idProduct INT,
    prodQuantity INT DEFAULT 1,
    CONSTRAINT fk_product_seller FOREIGN KEY (idSeller) REFERENCES seller(idSeller),
    CONSTRAINT fk_product_product FOREIGN KEY (idProduct) REFERENCES product(idProduct)
);

-- Clientes (PF e PJ)
INSERT INTO clients (Fname, Minit, Lname, Address, clientType) VALUES
('Maria', 'M', 'Silva', 'Rua Silva de Prata 29, Carangola - Cidade das Flores', 'PF'),
('Matheus', 'O', 'Pimentel', 'Rua Alameda 289, Centro - Cidade das Flores', 'PF'),
('Ricardo', 'F', 'Silva', 'Avenida Alameda Vinha 1009, Centro - Cidade das Flores', 'PF'),
('Julia', 'S', 'França', 'Rua Lareijras 861, Centro - Cidade das Flores', 'PF'),
('Supermercado', null, 'Bom Preço', 'Rua das Palmeiras 45, Centro - Cidade Nova', 'PJ'),
('Tech', null, 'Eletrônicos', 'Avenida Principal 1010, Vila Industrial - Cidade Nova', 'PJ');

INSERT INTO natural_person (idClient, CPF, BirthDate) VALUES
(1, '12345678901', '1985-04-15'),
(2, '98765432109', '1990-11-20'),
(3, '45678912302', '1978-07-01'),
(4, '78912345603', '2000-02-25');

INSERT INTO legal_person (idClient, SocialName, CNPJ) VALUES
(5, 'Supermercado Bom Preço Ltda', '12345678000199'),
(6, 'Tech Eletrônicos S.A.', '87654321000155');

-- Produtos
INSERT INTO product (Pname, category, evaluation, size, price) VALUES
('Fone de ouvido', 'Eletrônico', 4.5, null, 150.00),
('Barbie Elsa', 'Brinquedos', 5.0, null, 89.90),
('Body Carters', 'Vestimenta', 4.8, 'M', 120.50),
('Micro-ondas', 'Eletrônico', 4.2, null, 599.99),
('Sofá retrátil', 'Móveis', 4.7, '3x2.5', 2500.00);

-- Fornecedores
INSERT INTO supplier (SocialName, CNPJ, contact) VALUES
('Almeida e filhos', '11122233344455', '21985474'),
('Eletrônicos Silva', '88877766655544', '21985484'),
('Eletrônicos Valma', '99988877766655', '21975474');

-- Vendedores (um deles também é fornecedor)
INSERT INTO seller (SocialName, AbstName, CNPJ, CPF, location, contact) VALUES
('Tech Eletrônicos S.A.', 'Tech Eletro', '87654321000155', null, 'Rio de Janeiro', '219946287'),
('Boutique Durgas', 'Boutique Durgas', null, '123456789', 'Rio de Janeiro', '219567895'),
('Kids World', 'Kids World', '45678912365448', null, 'São Paulo', '1198657484');

-- Estoques
INSERT INTO storage (location, quantity) VALUES
('Rio de Janeiro', 1000),
('Rio de Janeiro', 600),
('São Paulo', 10000),
('São Paulo', 100);

-- Relações N:M
INSERT INTO product_supplier (idSupplier, idProduct, quantity) VALUES (1, 2, 500), (2, 4, 100);
INSERT INTO product_seller (idSeller, idProduct, prodQuantity) VALUES (1, 1, 10), (2, 3, 50);
INSERT INTO product_storage (idProduct, idStorage, quantity) VALUES (1, 1, 50), (4, 3, 20);

-- Pedidos e Entregas
INSERT INTO orders (idClient, orderStatus, orderDescription, shippingCost) VALUES
(1, 'Confirmado', 'Compra via aplicativo', 25.0),
(2, 'Confirmado', 'Compra via aplicativo', 15.0),
(3, 'Em processamento', 'Compra via web site', 30.0),
(4, 'Cancelado', 'Compra via aplicativo', 10.0),
(1, 'Confirmado', 'Compra via web site', 18.0);

INSERT INTO product_order (idOrder, idProduct, poQuantity) VALUES
(1, 1, 1),
(1, 2, 1),
(2, 4, 1),
(3, 3, 2),
(5, 5, 1);

INSERT INTO payments (idOrder, idClient, paymentType) VALUES (1, 1, 'Cartão'), (2, 2, 'Boleto'), (5, 1, 'Dois cartões');

INSERT INTO delivery (idOrder, status, tracking_code) VALUES
(1, 'Em Trânsito', 'BR123456789FR'),
(2, 'Enviado', 'BR987654321PT'),
(5, 'Aguardando Envio', 'BR555444333SP');

-- Pergunta 1: Quantos pedidos foram feitos por cada cliente?
SELECT 
    c.idClient,
    CONCAT(c.Fname, ' ', c.Lname) AS ClientName,
    COUNT(o.idOrder) AS NumberOfOrders
FROM clients c
LEFT JOIN orders o ON c.idClient = o.idClient
GROUP BY c.idClient, ClientName
ORDER BY NumberOfOrders DESC;

-- Pergunta 2: Qual a relação de produtos, fornecedores e seus respectivos estoques?
SELECT 
    p.Pname AS ProductName,
    s.SocialName AS SupplierName,
    st.location AS StorageLocation,
    ps.quantity AS StockQuantity
FROM product p
JOIN product_supplier psu ON p.idProduct = psu.idProduct
JOIN supplier s ON psu.idSupplier = s.idSupplier
JOIN product_storage ps ON p.idProduct = ps.idProduct
JOIN storage st ON ps.idStorage = st.idStorage
ORDER BY p.Pname;

-- Pergunta 3: Qual o nome dos fornecedores e os nomes dos produtos que eles fornecem?
SELECT 
    s.SocialName AS SupplierName,
    p.Pname AS ProductName
FROM supplier s
JOIN product_supplier ps ON s.idSupplier = ps.idSupplier
JOIN product p ON ps.idProduct = p.idProduct
ORDER BY s.SocialName, p.Pname;

-- Pergunta 4: Existem vendedores que também são fornecedores?
SELECT 
    sel.SocialName AS SellerName,
    sel.CNPJ AS SellerCNPJ,
    sup.SocialName AS SupplierName,
    sup.CNPJ AS SupplierCNPJ
FROM seller sel
INNER JOIN supplier sup ON sel.CNPJ = sup.CNPJ;

-- Pergunta 5: Quais clientes (PF) fizeram 2 ou mais pedidos e qual o valor total gasto por eles?
SELECT 
    c.idClient,
    CONCAT(c.Fname, ' ', c.Lname) AS ClientName,
    np.CPF,
    COUNT(o.idOrder) AS TotalOrders,
    SUM(p.price * po.poQuantity + o.shippingCost) AS TotalSpent
FROM clients c
JOIN natural_person np ON c.idClient = np.idClient
JOIN orders o ON c.idClient = o.idClient
JOIN product_order po ON o.idOrder = po.idOrder
JOIN product p ON po.idProduct = p.idProduct
WHERE o.orderStatus != 'Cancelado'
GROUP BY c.idClient, ClientName, np.CPF
HAVING TotalOrders >= 2
ORDER BY TotalSpent DESC;

-- Pergunta 6: Listar todos os produtos da categoria 'Eletrônico' ordenados do mais caro para o mais barato.
SELECT
    Pname,
    category,
    evaluation,
    price
FROM product
WHERE category = 'Eletrônico'
ORDER BY price DESC;

-- Pergunta 7: Qual o status dos pedidos e suas respectivas informações de entrega e pagamento?
SELECT
    o.idOrder,
    CONCAT(c.Fname, ' ', c.Lname) AS Client,
    o.orderStatus,
    p.paymentType,
    d.status AS DeliveryStatus,
    d.tracking_code
FROM orders o
JOIN clients c ON o.idClient = c.idClient
LEFT JOIN payments p ON o.idOrder = p.idOrder
LEFT JOIN delivery d ON o.idOrder = d.idOrder
WHERE o.orderStatus != 'Cancelado'
ORDER BY o.idOrder;
