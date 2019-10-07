DESCRIBE customers; 
/*
Apresenta dados sobre as colunas da tabela descrita
Pode ser usado com views e pode ser abreviado como DESC
Sempre pode ser usado na linha de comando, nem sempre pode ser usado com IDEs
*/

INSERT INTO customers(customer_id, first_name, last_name, dob, phone)
VALUES(6, 'Fred','Brown','01-JAN-1970','800-555-1215');
/*
Exemplo de instrução para inserir registro em tabela
Uma chave primária não pode ser violada, cada chave primária deve ser única na tabela
*/

UPDATE customers
SET last_name = 'Orange'
WHERE customer_id = 2;
/*
Exemplo de instrução de alteração de registro
É possível usar a cláusula WHERE para filtrar quais registros devemm ser alterados
É possível alterar o valor de várias colunas com um único UPDATE
A cláusula SET indica quais colunas devem ser alteradas
A chave primária também não pode ser violada nesse comando
*/

DELETE FROM customers 
WHERE customer_id = 2;
/*
Exemplo de instrução de deleção de registro
É possível filtrar quais registros serão deletados com a cláusula WHERE
Caso não exista esse filtro, todos os registros da tabela serão deletados
Por padrão caso algum campo da tabela seja chave estrangeira em outra não é possível deletar o registro devido a regras de integridade
Esse comportamento pode ser alterado, 
por exemplo de modo que sempre o registro da tabela pai for deletado, o registro da tabela filha também seja
*/

SELECT * FROM customers;

ROLLBACK; --Desfazer alterações

/*
O Oracle 10g introduziu dois tipos de dados: BINARY_FLOAT e BINARY_DOUBLE.
O BINARY_FLOAT pode armazenar números de ponto flutuante até 32 bits
O BINARY_DOUBLE pode armazenar números de ponto flutuante até 64 bits
Nesses tipos de dados, a base do número é binária e segue o padrão do IEEE
Esse tipos possui algumas vantagens em relação ao tipo NUMBER
Ambos os tipos podem representar um intervalo maior de números
As operações geralmente são feitas diretamente no hardware, por isso são mais rápidas. 
NUMBER deve ser convertido por software antes da execução das operações
Os tipos BINARY_DOUBLE e BINARY_FLOAT podem representar valores especias como NaN e INFINITY
*/

SELECT * FROM binary_test;

SELECT BINARY_DOUBLE_INFINITY,
       BINARY_DOUBLE_NAN,
       BINARY_FLOAT_INFINITY,
       BINARY_FLOAT_NAN 
       FROM dual; --Exemplo da representação de NaN e Infinity