---------------------------Expressoes Regulares----------------------

--Para ver o que cada caractere da expressão faz em detalhes
--Consultar a table no livro em pdf nas páginas 140, 141, 142

--O REGEXP_LIKE serve para procurar um padrão em um texto. 
--Caso o padrão seja encontrado retorna TRUE, senão retorna FALSE.
--é possível passar parametro opcional para afetar como a procura será feita
--c - A procura IRÁ diferenciar maiusculas de minusculas - valor padrão
--i - A procura NÃO IRÁ diferenciar maiusculas de minusculas
--n - permite o uso do operador que representa qualquer caractere
--m - trata o texto como multiplas linhas
--No exemplo abaixo, são consultados todos os clientes que o ultimo nome comece com B
SELECT customer_id, first_name, last_name, dob from customers
where REGEXP_LIKE(last_name, '^B');


--A REGEXP_INSTR serve para retornar a posição do inicio da ocorrência de um padrão ou a posição imediatamente após
--(depende do parametro que define como vai ser o retorno).
--Além do texto e do padrão a ser procurado, é possivel passar também em qual posição deve comecar a busca, e qual ocorrência é desejada
--1 para a primeira e assim sucessivamente
--No exemplo abaixo retorna a posição de l, que é aprimeira letra da palavra light
SELECT regexp_instr('But, soft! What light through yonder window breaks?','l[[:alpha:]]{4}') AS teste FROM dual;

--A REGEXP_REPLACE serve para substituir o texto que bate com o pdrão procurado pelo texto passado. 
--No exemplo substitui light por sound
SELECT regexp_replace('But,soft! What light through yonder window breaks?','l[[:alpha:]]{4}','sound') AS teste
FROM dual;

--A REGEXP_SUBSTR serve para retornar o trecho do texto que bate com o padrão procurado
SELECT regexp_substr('But,soft! What light through yonder window breaks?','l[[:alpha:]]{4}') AS teste
FROM dual;

--A REGEXP_COUNT serve para contar o número de ocorrências no padrão buscado no texto
--No exemplo o padrão de começar com s e ter mais 3 caracteres alfa-numéricos aparece 2 vezes(soft)
SELECT regexp_count('But,soft! What light through yonder window softly breaks?','s[[:alpha:]]{3}') AS teste FROM dual;


