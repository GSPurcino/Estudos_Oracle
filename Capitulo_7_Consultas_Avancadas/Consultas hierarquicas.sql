--------------------------------------------Consultas Hierarquicas---------------------------------

SELECT * FROM more_employees;

--Sintaxe consulta hierarquica
SELECT [LEVEL], column, expression, ...
FROM table
[WHERE where_clause]
[[START WITH start_condition] [CONNECT BY PRIOR prior_condition]];

--LEVEL é uma coluna falsa que diz em qual nivel da arvore o registro está. 
--LEVEL 1 para o elemento inicial, 2 para seus filhos e assim sucessivamente

--Exemplo com start with e connect by prior
SELECT employee_id,
       manager_id,
       first_name,
       last_name
FROM more_employees START WITH employee_id = 1 CONNECT BY PRIOR employee_id = manager_id;
--No CONNECT BY PRIOR, lado esquerdo em relação ao = refere-se ao elemento pai e o lado direito refere-se ao elemento filho

--Exemplo com LEVEL
SELECT level,
       employee_id,
       manager_id,
       first_name,
       last_name
FROM more_employees
START WITH
    employee_id = 1
CONNECT BY
    PRIOR employee_id = manager_id
ORDER BY level;

--Conta quantos niveis diferentes a arvore tem
SELECT COUNT(DISTINCT level) qt_niveis_diferentes_arvore FROM more_employees START WITH employee_id = 1 CONNECT BY PRIOR employee_id
= manager_id;

--Formatação de acordo com o LEVEL
SELECT level,
       lpad(
        ' ',
        2 * level - 1
    )
     || first_name
     || ' '
     || last_name AS employee
FROM more_employees START WITH employee_id = 1 CONNECT BY PRIOR employee_id = manager_id;

--O começo da arvore(raiz) nao necessariamnete precisa ser o começo para consultas hierarquicas

SELECT level,
       lpad(
        ' ',
        2 * level - 1
    )
     || first_name
     || ' '
     || last_name AS employee
FROM more_employees START WITH last_name = 'Jones' CONNECT BY PRIOR employee_id = manager_id;

--Subconsulta no START WITH

SELECT level,
       lpad(
        ' ',
        2 * level - 1
    )
     || first_name
     || ' '
     || last_name AS employee
FROM more_employees START WITH
    employee_id = ( SELECT employee_id FROM more_employees WHERE first_name   = 'Kevin'
    AND
        last_name    = 'Black'
    )
CONNECT BY PRIOR employee_id = manager_id;

--Viajando pela arvore começando por um registro filho
SELECT level,
       lpad(
        ' ',
        2 * level - 1
    )
     || first_name
     || ' '
     || last_name AS employee
FROM more_employees START WITH last_name = 'Blue' CONNECT BY PRIOR manager_id = employee_id;

--Eliminando um no da arvore
SELECT level,
       lpad(
        ' ',
        2 * level - 1
    )
     || first_name
     || ' '
     || last_name AS employee
FROM more_employees WHERE last_name != 'Johnson'
START WITH
    employee_id = 1
CONNECT BY
    PRIOR employee_id = manager_id;

--Eliminando a arvore inteira relacionada ao funcionario Johnson
--Em vez de usar a condição no WHERE, colocar no CONNECT BY PRIOR com AND
--Nesse caso o WHERE filtra a consulta e o CONNECT BY PRIOR filtra a arvore
SELECT level,
       lpad(
        ' ',
        2 * level - 1
    )
     || first_name
     || ' '
     || last_name AS employee
FROM more_employees START WITH employee_id = 1 CONNECT BY PRIOR employee_id = manager_id
AND
    last_name != 'Johnson';