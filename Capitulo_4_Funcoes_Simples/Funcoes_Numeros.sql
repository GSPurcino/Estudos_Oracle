-----------------------FUNÇÕES RELACIONADAS A NÚMEROS------------------------------------------

SELECT abs(-10) valor_absoluto_num_negativo,
       abs(10) valor_absoluto_num_positivo
FROM dual;
--Valor absoluto de um número(sem sinal)

SELECT floor(12345.56) menor_que_decimal
FROM dual;
--Retorna o maior inteiro que é menor ou igual ao valor decimal no caso 12345

SELECT ceil(12345.56) maior_que_decimal
FROM dual;
--Retorna o menor inteiro que é maior ou igual ao valor decimal no caso 12346

SELECT round(5.643,2) arredondamento
FROM dual;
--Arredonda o número na quantidade de casas especificadas,no caso 2

SELECT trunc(5.643,2) corte_numero_casas
FROM dual;
--Trunca o número,no caso terá duas casas decimais

SELECT trunc(5643,-2) corte_numero
FROM dual;
--Substitui partes do número por 0 a partir da unidade,depois dezena e assim sucessivamente,
--dependendo do valor negativo especificado

--Retorna o resto da divisão de um número por outro
SELECT mod(8,3) mod
FROM dual;

SELECT sqrt(9) raiz_quadrada
FROM dual;

SELECT power(3,2) elevar_numero
FROM dual;

SELECT sign(-10) sinal_numero_negativo,
       sign(0) sinal_zero,
       sign(10) sinal_numero_positivo
FROM dual;
--Retorna -1 para negativo, 0 para o 0 e 1 para positivo
