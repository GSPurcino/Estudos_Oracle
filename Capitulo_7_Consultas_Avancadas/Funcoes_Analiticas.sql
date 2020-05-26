SELECT *
FROM all_sales;

---------------------------------------Funcoes_analiticas----------------------------

--Janela
--Os registros retornados por uma consulta pode ser chamados de conjunto de resultado.
--Uma janela é um subconjunto de registros do conjunto de resultado
--As funções de janela servem para atuar nesse conjunto de registros.
--exemplo sem qualquer parametro na janela
--Se nada for passado para a janela,ela considera todos os registros que compoem o resultado para fazer a função agregada
--A principal diferença do PARTITION BY em relação ao GROUP by é que o resultado da função agregada é retornado multiplas vezes.
--Isso significa que é possível selecionar colunas que não fazem parte da criação do grupo de registros.
--Na pratica, a existência da janela é determinada pela palavra OVER. 
--Sem OVER, não há janela.

SELECT month,
       SUM(amount) OVER() sum_amount
FROM all_sales;
    
--Comparação entre as funções RANK,DENSE_RANK,ROW_NUMBER e PERCENT_RANK
--essas tres funções são afetadas pela ordem dos registros na janela
  
--RANK
--Retorna um rank numerico de itens em um grupo. Quando o ranking de dois ou mais itens é o mesmo,deixa um buraco no ranking

--DENSE_RANK
--Rankeia os itens também,mas no caso de empates não deixa buracos no ranking

--PERCENT_RANK
--Retorna um valor entre 0 e 1 similar a CUME_DIST. 
--O primeiro valor do RANK sempre vai ser 0(0%) e o ultimo valor pode chegar até a 1.
--Nota-se que em termos percentuais o RANK 0 = 0% e 1 = 100%
--Como o primeiro registro sempre é 0, na pratica o RANK percentual é feito pela quantidade de registros do grupo - 1
--No exemplo abaixo a quantidade de meses é 11, só que o mes 1 é o primeiro no RANK(0). 
--Então o RANK percentual é construido considerando a quantidade total de registros dos 10 meses restantes.
--Esse PERCENT_RANK é bem visível no exemplo abaixo
--GROUP BY em VEZ de DISTINCT com essas funções. O distinct é feito depois, o group by afeta o calculo do PERCENT_RANK

--CONTA DO PERCENT_RANK
(x - 1) / (quantidade de registros do grupo - 1)
--X é o RANK do registro
--é possível perceber principalmente no segundo exemplo como essa formula é respeitada.
--Na pratica o PERCENT_RANK é uma função do RANK e da quantidade de registros do grupo
--Como no RANK há quebra da classificação consecutiva sempre que há repetição do valor classificado isso ocorre no percent_rank
--é por isso que a porcentagem se repete tantas vezes no segundo exemplo

SELECT month,
       RANK() OVER(
        ORDER BY month
    ) rank, 
       PERCENT_RANK() OVER(
        ORDER BY month
    ) percent_rank
FROM all_sales
where month <= 11
GROUP by month
ORDER BY month;

SELECT month,
       ROW_NUMBER() OVER(
        ORDER BY month
    ) row_number,
       RANK() OVER(
        ORDER BY month
    ) rank,
       DENSE_RANK() OVER(
        ORDER BY month
    ) dense_rank,
       PERCENT_RANK() OVER(
        ORDER BY month
    ) percent_rank
FROM all_sales
ORDER BY month;



--RANK como funcao agregada
--Retorna qual é o RANK numerico do valor passado de acordo com a forma que a ordenação é feita
--O DENSE_RANK retorna o DENSE_RANK numerico para o valor passado
--Ambas as funções quando usadas dessa forma SÓ FUNCIONAM com CONSTANTES

--A função PERCENT_RANK pode ser usada com WITHIN GROUP também
--Quando a PERCENT_RANK é usada dessa forma a sua fórmula é a seguinte:
(x -1) / quantidade de registros no grupo
--x é o RANK do registro
--Quando a funçao PERCENT_RANK é usada assim, ela é preditiva(ou seja caso o registro seja inserido qual vai ser a porcentagem da classificação dele
--RANK e DENSE_RANK também são preditivas desse jeito.
--Na pratica usar elas assim significa classifique o valor passado no grupo de registros atuais definido, 
--se o dado não existir na tabela, o retorno é preditivo

SELECT RANK(
        6034.84
    ) WITHIN GROUP(ORDER BY
        amount
    ) rank_within_group,
       DENSE_RANK(
        6034.84
    ) WITHIN GROUP(ORDER BY
        amount
    ) dense_rank_within_group,
       PERCENT_RANK(
        6034.84
    ) WITHIN GROUP(ORDER BY
        amount
    ) percent_rank_within_group
FROM all_sales;

--O amount 6034.84 tem o mesmo RANK e DENSE_RANK nessa consulta do que na anterior
SELECT amount,
       RANK() OVER(order by amount) rank,
       DENSE_RANK() OVER (order by amount) dense_rank,
       PERCENT_RANK() OVER(order by amount) percent_rank
       from all_sales;

SELECT prd_type_id,
       SUM(amount),
       RANK() OVER(
        ORDER BY SUM(amount) DESC
    ) AS rank,
       DENSE_RANK() OVER(
        ORDER BY SUM(amount) DESC
    ) AS dense_rank
FROM all_sales
WHERE amount IS NOT NULL
GROUP BY
    prd_type_id
ORDER BY prd_type_id;

--RANK e DENSE_RANK com NULL
--Por padrão,essas funcoes classificam o NULL como primeiro(1).

SELECT prd_type_id,
       SUM(amount),
       RANK() OVER(
        ORDER BY SUM(amount) DESC
    ) AS rank,
       DENSE_RANK() OVER(
        ORDER BY SUM(amount) DESC
    ) AS dense_rank
FROM all_sales
GROUP BY
    prd_type_id
ORDER BY prd_type_id;

--É possível controlar a classificação de NULLS com NULLS FIRST(vem primeiro) e NULLS LAST(vem por ultimo)

SELECT prd_type_id,
       SUM(amount),
       RANK() OVER(
        ORDER BY SUM(amount) DESC NULLS LAST
    ) AS rank,
       DENSE_RANK() OVER(
        ORDER BY SUM(amount) DESC NULLS LAST
    ) AS dense_rank
FROM all_sales
GROUP BY
    prd_type_id
ORDER BY prd_type_id;

--é possível usar funcoes analiticas sem agrupar valores

SELECT employee_id,
       RANK() OVER(
        ORDER BY employee_id
    )
FROM employees;

--FIRST
--Pode ser usada para realizar funções agregadas apenas nos registros com o primeiro lugar em um DENSE_RANK(menor número no dense_rank)
--Pode ser usada em janelas com o OVER

SELECT SUM(amount) sum_amount,
       prd_type_id
FROM all_sales GROUP BY
    prd_type_id;

--Nesse exemplo é possível perceber que o first só fez a soma do amount do primeiro prd_type_id
--No caso do DENSE_RANK LAST como o prd_type_id 5 não tem amount, 
--foi feito um filtro na query para poder mostrar o LAST funcionando mais claramente
SELECT SUM(
        amount
    ) KEEP(DENSE_RANK FIRST ORDER BY
        prd_type_id
    ) sum_first_prd_type_id,
       SUM(
        amount
    ) KEEP(DENSE_RANK LAST ORDER BY
        prd_type_id
    ) sum_last_prd_type_id
FROM all_sales WHERE amount IS NOT NULL;


--ROW_NUMBER
--Retorna um numero para cada registro dentro do grupo. Esse numero nao se repete dentro do mesmo grupo(começa de 1)

SELECT prd_type_id,
       SUM(amount),
       ROW_NUMBER() OVER(
        ORDER BY SUM(amount) DESC
    ) AS row_number
FROM all_sales
GROUP BY
    prd_type_id
ORDER BY prd_type_id;      
      
--LAG e LEAD
--LEAD serve para retornar no registro atual o registro seguinte na janela de acordo com o numero passado
--LAG serve para retornar no registro atual o registro anterior na janela de acordo com o numero passado

--No exemplo, para o LEAD foi passado 1. 
--Para pegar registros mais a frente na janela ou ainda mais atras, basta passar um numero maior para LEAD e LAG respectivamente.
SELECT month,       
       LAG(SUM(amount),1) OVER(
        ORDER BY month
    ) AS previous_month_amount,
    SUM(amount) AS month_amount,
       LEAD(SUM(amount),1) OVER(
        ORDER BY month
    ) AS next_month_amount
FROM all_sales
GROUP BY
    month
ORDER BY month;

--FIRST_VALUE. Retorna o primeiro valor da janela após fazer o order by.
--Quando a janela é construida considerando todo o retorno da query 
--e nao é colocado order by no OVER e nem passado nenhum parametro para a janela,
--a ordenação da query AFETA DIRETAMENTE o retorno de certas funções da janela. 

-- O registro atual não consegue ver todos os registros da query devido a definição padrão de janela
--(Todos os registros anteriores até o atual) RANGE BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
--por isso o retorno de LAST_VALUE foi o mes atual 
--Apenas algumas funcoes permitem definir qual parte da janela deve ser considerada.

SELECT DISTINCT month,
       FIRST_VALUE(month) OVER() first_month_orderless,
       LAST_VALUE(month) OVER() last_month_orderless,
       FIRST_VALUE(
        month
    ) OVER(
        ORDER BY
            month
    ) first_month_ordered,
       LAST_VALUE(
        month
    ) OVER(
        ORDER BY
            month
    ) last_month_ordered,
       FIRST_VALUE(
        month
    ) OVER(
        ORDER BY
            month
        DESC
    ) last_month_first_value,
       LAST_VALUE(
        month
    ) OVER(
        ORDER BY
            month
        DESC
    ) first_month_last_value
FROM all_sales
ORDER BY month;

--Parametros de janela. É possível dependendo da função(window function) chamada definir qual vai ser o tamanho da janela.
--Esses parametros permitem dizer onde começa e termina a janela
--DEVE-SE USAR ORDER BY NO OVER PARA ALTERAR A JANELA
--No exemplo acima, a função LAST_VALUE não retornou o ultimo mes(12) presente na tabela em todos os casos
--Para fazer isso acontecer deve-se mudar o formato da janela.
--A janela do ser definida em termos de ROWS(registros fisicos) ou RANGE(alcance logico)
--A perspectiva é sempre considerando o registro atual para ver o que retorna na janela(facil de ver nas consultas)
--Sintaxe abaixo:

[ROW or RANGE] BETWEEN <start_expr> AND <end_expr>

<start_expr> can be any one of the following
1 UNBOUNDED PECEDING
2 CURRENT ROW
3 <sql_expr> PRECEDING or FOLLOWING.

1 <end_expr> can be any one of the following
2 UNBOUNDED FOLLOWING or
3 CURRENT ROW or
<sql_expr> PRECEDING or FOLLOWING.

--É possível perceber que ROW e RANGE não podem aparecer simultaneamente numa mesma definição de janela
--Começar em CURRENT ROW e terminar CURRENT ROW torna a função de janela em uma função que afeta apenas um registro(bem inutil)
--Obviamente o fim da janela nao pode ser antes do inicio
--Para janelas definidas por registros a <sql_expr> na sintaxe DEVE SER UM NUMERO INTEIRO POSITIVO(0 PRECEDING e 0 FOLLOWING = CURRENT ROW), 
--POIS TRATA-SE DE QUANTIDADE DE REGISTROS
--Caso qualquer ponto da janela(começo ou fim) sejam indefinidos, o começo padrão é UNBOUNDED PRECEDING e o fim padrão é UNBOUNDED FOLLOWING

--Para janelas definidas por REGISTRO a sintaxe é:
Function( ) OVER (PARTITIN BY <expr1> ORDER BY <expr2,..> ROWS BETWEEN <start_expr> AND <end_expr>)
or
Function( ) OVER (PARTITON BY <expr1> ORDER BY <expr2,..> ROWS [<start_expr> PRECEDING or UNBOUNDED PRECEDING]

--Exemplo considerando toda a janela
--Desse jeito é possível pegar o primeiro mes correto assim como o ultimo mes correto porque a função está olhando para todos os registros da janela
--Como a janela é ordenada, para pegar o primeiro pode-se usar
SELECT DISTINCT month,
       FIRST_VALUE(month) OVER(ORDER BY month ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) first_month,
       LAST_VALUE(month) OVER(ORDER BY month ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) last_month
FROM all_sales
ORDER BY month;

--Para pegar quem e o primeiro numa lista ordenada de dados, basta considerar tudo o que vem antes(UNBOUNDED PRECEDING) ate o registro atual(CURRENT ROW)
--Para pegar o ultimo considerar o que vem depois(UNBOUNDED FOLLOWING) até o registro atual(CURRENT ROW)
--Exemplo abaixo com janela menor para atingir o mesmo resultado
SELECT DISTINCT month,
       FIRST_VALUE(month) OVER(ORDER BY month ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) first_month,
       LAST_VALUE(month) OVER(ORDER BY month ROWS BETWEEN CURRENT ROW AND UNBOUNDED FOLLOWING) last_month       
FROM all_sales
ORDER BY month;

--Exemplo passando a janela com quantidade de registros antes e depois do registro atual
SELECT month,
       SUM(month) OVER(ORDER BY month ROWS BETWEEN 1 PRECEDING AND 1 FOLLOWING) sum_between_3_months
FROM all_sales
GROUP BY month
ORDER BY month;
    
--Para janelas definidas por ALCANCE, a sintaxe e:
Function( ) OVER (PARTITION BY <expr1> ORDER BY <expr2> RANGE BETWEEN <start_expr> AND <end_expr>)
or
Function( ) OVER (PARTITION BY <expr1> ORDER BY <expr2> RANGE [<start_expr> PRECEDING or UNBOUNDED PRECEDING]

--Percebe que a janela ROW or RANGE BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING 
--são a mesma coisa na pratica e servem para considerar a JANELA COMPLETA

--Exemplo com RANGE
--A principal diferença de RANGE para ROW é que a janela pode ter diferentes tamanhos para diferentes registros
--Por exemplo para o mes 1 a janela considera todos os meses. Já para o mes 12 a janela começa do mes 6 e vai até ele.
SELECT month,
       SUM(month) OVER(ORDER BY month RANGE BETWEEN month/2 PRECEDING AND UNBOUNDED FOLLOWING) sum_months
FROM all_sales
GROUP BY month
ORDER BY month;

--------------------------------------------------PARTITION BY-------------------------------------------------------------------
--essa opção pode ser usada para dividir em grupos os registros,
--de modo que a função analitica ocorra em cada grupo em vez da consulta inteira

SELECT prd_type_id,
       month,
       SUM(amount),
       RANK() OVER(PARTITION BY
        month
        ORDER BY
            SUM(amount)
        DESC
    ) AS rank
FROM all_sales
WHERE amount IS NOT NULL
GROUP BY
    prd_type_id,
    month
ORDER BY month;

--No exemplo foi criado uma janela para cada mes(se ordenar por mes o RANK vai ser 1 porque só aquele mes faz parte da janela)
--Para ver as outras janelas melhor, basta trazer outro campo na consulta(amount) e ordenar por ele na janela
--Tudo que é colocado dentro do OVER está relacionado a janela
SELECT month,
       amount,
       RANK() OVER(PARTITION BY
        month
        ORDER BY
            amount        
    ) AS rank
FROM all_sales
order by month;

--Como é possível perceber na consulta, como existe uma janela para cada mes, as funcoes atuam somente dentro de uma janela.
--Por exemplo, quando chega o ultimo amount do mes 1, o lead desse não é o primeiro amount do mes 2.
--ESSE EXEMPLO PROVA QUE O PARTITION BY DIVIDE UMA JANELA EM MULTIPLAS JANELAS
--(nesse contexto janela e grupo de registros podem ser considerados sinonimos)

SELECT month,           
       LAG(amount,1) OVER(PARTITION by month order by amount) previous_amount,
       amount current_amount,
       LEAD(amount,1) OVER(PARTITION by month order by amount) next_amount
       from all_sales
       order by month, amount;
              
---------------------------------------Funcoes analiticas com extensoes de GROUP BY-------------------------------------------

SELECT prd_type_id,
       SUM(amount),
       RANK() OVER(
        ORDER BY SUM(amount) DESC
    ) AS rank
FROM all_sales
GROUP BY
    ROLLUP(prd_type_id)
ORDER BY prd_type_id;

SELECT prd_type_id,
       emp_id,
       SUM(amount),
       RANK() OVER(
        ORDER BY SUM(amount) DESC
    ) AS rank
FROM all_sales
GROUP BY
    CUBE(prd_type_id,emp_id)
ORDER BY prd_type_id,emp_id;

SELECT prd_type_id,
       emp_id,
       SUM(amount),
       RANK() OVER(
        ORDER BY SUM(amount) DESC
    ) AS rank
FROM all_sales
GROUP BY
    GROUPING SETS ( prd_type_id,emp_id )
ORDER BY prd_type_id,emp_id;

-------------------------------------------------------------------------------------------------------------------------------------------

--CUME_DIST - Calcula a posição específica de um valor dentro de um grupo de valores
--PERCENT_RANK - Calcula a porcentagem de um valor em relação a um grupo de valores
--Ambas as funcoes indicam em numeros ou porcentagens,quantos valores estão acima
--(quando ordenado DESC) ou valores abaixo(quando ordenados ASC0

SELECT prd_type_id,
       SUM(amount),
       CUME_DIST() OVER(
        ORDER BY SUM(amount) DESC
    ) AS cume_dist,
       PERCENT_RANK() OVER(
        ORDER BY SUM(amount) DESC
    ) AS percent_rank
FROM all_sales
WHERE amount IS NOT NULL
GROUP BY
    prd_type_id
ORDER BY prd_type_id;

SELECT prd_type_id,
       SUM(amount),
       CUME_DIST() OVER(
        ORDER BY SUM(amount)
    ) AS cume_dist,
       PERCENT_RANK() OVER(
        ORDER BY SUM(amount)
    ) AS percent_rank
FROM all_sales
WHERE amount IS NOT NULL
GROUP BY
    prd_type_id
ORDER BY prd_type_id;

--NTILE
--Divide os registros em grupos de acordo com o parametro passado. NTILE(2) divide os registros em dois grupos.

SELECT prd_type_id,
       SUM(amount),
       NTILE(
        2
    ) OVER(
        ORDER BY
            SUM(amount)
        DESC
    ) AS ntile
FROM all_sales
WHERE amount IS NOT NULL
GROUP BY
    prd_type_id
ORDER BY prd_type_id;

--PERCENTILE_CONT
--PERCENTILE_DISC

SELECT PERCENTILE_CONT(
        0.1
    ) WITHIN GROUP(ORDER BY
        SUM(amount)
    DESC) AS percentile_cont,
       PERCENTILE_DISC(
        0.1
    ) WITHIN GROUP(ORDER BY
        SUM(amount)
    DESC) AS percentile_disc
FROM all_sales GROUP BY
    prd_type_id;

--Exemplo com soma cumulativa.
--UNBOUNDED PRECEDING significa que a janela vai começar no primeiro registro do conjunto de resultado.
-- AND CURRENT ROW significa que a janela vai até o registro atual. 
--Ou seja a quantidade de janelas é igual a quantidade de registros nesse caso.
--Na janela,foi feita a soma do campo amount de forma cumulativa

SELECT month,
       SUM(amount) AS month_amount,
       SUM(
        SUM(amount)
    ) OVER(
        ORDER BY
            month
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ) AS cumulative_amount
FROM all_sales
GROUP BY
    month
ORDER BY month;

--somente o retorno da janela com group by

SELECT SUM(
        SUM(amount)
    ) OVER(
        ORDER BY
            month
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ) AS cumulative_amount
FROM all_sales
GROUP BY
    month
ORDER BY month;