---------------------------Expressoes Regulares----------------------

--Para ver o que cada caractere da express�o faz em detalhes
--Consultar a table no livro em pdf nas p�ginas 140, 141, 142

--O REGEXP_LIKE serve para procurar um padr�o em um texto. 
--Caso o padr�o seja encontrado retorna TRUE, sen�o retorna FALSE.
--� poss�vel passar parametro opcional para afetar como a procura ser� feita
--c - A procura IR� diferenciar maiusculas de minusculas - valor padr�o
--i - A procura N�O IR� diferenciar maiusculas de minusculas
--n - permite o uso do operador que representa qualquer caractere
--m - trata o texto como multiplas linhas
--No exemplo abaixo, s�o consultados todos os clientes que o ultimo nome comece com B
SELECT customer_id, first_name, last_name, dob from customers
where REGEXP_LIKE(last_name, '^B');


--A REGEXP_INSTR serve para retornar a posi��o do inicio da ocorr�ncia de um padr�o ou a posi��o imediatamente ap�s
--(depende do parametro que define como vai ser o retorno).
--Al�m do texto e do padr�o a ser procurado, � possivel passar tamb�m em qual posi��o deve comecar a busca, e qual ocorr�ncia � desejada
--1 para a primeira e assim sucessivamente
--No exemplo abaixo retorna a posi��o de l, que � aprimeira letra da palavra light
SELECT regexp_instr('But, soft! What light through yonder window breaks?','l[[:alpha:]]{4}') AS teste FROM dual;

--A REGEXP_REPLACE serve para substituir o texto que bate com o pdr�o procurado pelo texto passado. 
--No exemplo substitui light por sound
SELECT regexp_replace('But,soft! What light through yonder window breaks?','l[[:alpha:]]{4}','sound') AS teste
FROM dual;

--A REGEXP_SUBSTR serve para retornar o trecho do texto que bate com o padr�o procurado
SELECT regexp_substr('But,soft! What light through yonder window breaks?','l[[:alpha:]]{4}') AS teste
FROM dual;

--A REGEXP_COUNT serve para contar o n�mero de ocorr�ncias no padr�o buscado no texto
--No exemplo o padr�o de come�ar com s e ter mais 3 caracteres alfa-num�ricos aparece 2 vezes(soft)
SELECT regexp_count('But,soft! What light through yonder window softly breaks?','s[[:alpha:]]{3}') AS teste FROM dual;


