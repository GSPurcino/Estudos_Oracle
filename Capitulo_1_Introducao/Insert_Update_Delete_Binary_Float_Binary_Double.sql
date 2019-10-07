DESCRIBE customers; 
/*
Apresenta dados sobre as colunas da tabela descrita
Pode ser usado com views e pode ser abreviado como DESC
Sempre pode ser usado na linha de comando, nem sempre pode ser usado com IDEs
*/

INSERT INTO customers(customer_id, first_name, last_name, dob, phone)
VALUES(6, 'Fred','Brown','01-JAN-1970','800-555-1215');
/*
Exemplo de instru��o para inserir registro em tabela
Uma chave prim�ria n�o pode ser violada, cada chave prim�ria deve ser �nica na tabela
*/

UPDATE customers
SET last_name = 'Orange'
WHERE customer_id = 2;
/*
Exemplo de instru��o de altera��o de registro
� poss�vel usar a cl�usula WHERE para filtrar quais registros devemm ser alterados
� poss�vel alterar o valor de v�rias colunas com um �nico UPDATE
A cl�usula SET indica quais colunas devem ser alteradas
A chave prim�ria tamb�m n�o pode ser violada nesse comando
*/

DELETE FROM customers 
WHERE customer_id = 2;
/*
Exemplo de instru��o de dele��o de registro
� poss�vel filtrar quais registros ser�o deletados com a cl�usula WHERE
Caso n�o exista esse filtro, todos os registros da tabela ser�o deletados
Por padr�o caso algum campo da tabela seja chave estrangeira em outra n�o � poss�vel deletar o registro devido a regras de integridade
Esse comportamento pode ser alterado, 
por exemplo de modo que sempre o registro da tabela pai for deletado, o registro da tabela filha tamb�m seja
*/

SELECT * FROM customers;

ROLLBACK; --Desfazer altera��es

/*
O Oracle 10g introduziu dois tipos de dados: BINARY_FLOAT e BINARY_DOUBLE.
O BINARY_FLOAT pode armazenar n�meros de ponto flutuante at� 32 bits
O BINARY_DOUBLE pode armazenar n�meros de ponto flutuante at� 64 bits
Nesses tipos de dados, a base do n�mero � bin�ria e segue o padr�o do IEEE
Esse tipos possui algumas vantagens em rela��o ao tipo NUMBER
Ambos os tipos podem representar um intervalo maior de n�meros
As opera��es geralmente s�o feitas diretamente no hardware, por isso s�o mais r�pidas. 
NUMBER deve ser convertido por software antes da execu��o das opera��es
Os tipos BINARY_DOUBLE e BINARY_FLOAT podem representar valores especias como NaN e INFINITY
*/

SELECT * FROM binary_test;

SELECT BINARY_DOUBLE_INFINITY,
       BINARY_DOUBLE_NAN,
       BINARY_FLOAT_INFINITY,
       BINARY_FLOAT_NAN 
       FROM dual; --Exemplo da representa��o de NaN e Infinity