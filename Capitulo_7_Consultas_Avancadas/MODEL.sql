--MODEL
--permite que as colunas do registro sejam acessadas como celulas em um array.
--Desse modo é possível fazer calculos de maneira similar a uma planilha.

--Exemplo
SELECT prd_type_id,
       year,
       month,    
       sales_amount
FROM all_sales
WHERE prd_type_id BETWEEN 1 AND 2
    AND
        emp_id   = 21
MODEL
    PARTITION BY ( prd_type_id ) DIMENSION BY ( month,year ) MEASURES ( amount sales_amount )
    RULES( sales_amount[1,2004] = sales_amount[1,2003],
    sales_amount[2,2004] = sales_amount[2,2003] + sales_amount[3,2003],
    sales_amount[3,2004] = round(
        sales_amount[3,2003] * 1.25,
        2
    ) )
ORDER BY prd_type_id,year,month;

--PARTITION BY agrupa os resultados por prd_type_id
--DIMENSION BY define quais colunas formam as dimensoes do vetor(mes e ano)
--MEASURES define o que tem na celula do array(amount) e qual e o nome do array(sales_amount). 
--Para acessar as celulas do array usar sales_amount[1,2003]
--RULES(a palavra é opcional, os parenteses não são) é aqui que está o calculo que pode ser feito para as celulas do array.
--Lembra a parte de fórmula do Excel
--quando um modelo coloca um registro na consulta, ele e colocado depois do ultimo registro da partição.

--Quando usar a clausula MODEL as dimensoes devem ser feitas de modo a poder identificar uma celula de forma unica
SELECT month FROM all_sales WHERE month IN (
            1,2
        )
    AND
        amount IS NOT NULL
MODEL
    DIMENSION BY ( month ) MEASURES ( amount amount_array )
        RULES
    ( amount_array[1] = amount_array[1] * 2 );
    
    
--Não é possível particionar por uma coluna e usar ela nas dimensoes
SELECT month from all_sales WHERE month IN (
            1,2
        )        
MODEL PARTITION BY(month) DIMENSION BY(month) MEASURES(year teste)( );

--Usando model para duplicar o salario do funcionario 1
SELECT employee_id, double_salary FROM employees where employee_id = 1 MODEL
    DIMENSION BY ( employee_id ) MEASURES ( salary double_salary )
        RULES
    ( double_salary[5] = double_salary[1] * 2 );

--Referenciando multiplas celulas no lado esquerdo(1 até 4). 
--E fazendo uma regra no lado direito usando currentv para refenciar o valor atual do employee_id
SELECT employee_id, double_salary FROM employees MODEL
    DIMENSION BY ( employee_id ) MEASURES ( salary double_salary )
        RULES
    ( double_salary[employee_id < 5] = double_salary[CURRENTV()] * 2 )
    ORDER BY employee_id;

--Usando referencia multipla no lado direito
--Somando todos os salarios dos funcionarios
--Usando FOR para referencia multipla em vez de BETWEEN
SELECT employee_id, sum_salary
    FROM employees
    MODEL DIMENSION BY(employee_id) MEASURES(salary sum_salary)
    RULES(sum_salary[5] = SUM(sum_salary)[FOR employee_id FROM 1 TO 4 INCREMENT 1])
    ORDER BY employee_id;
    
--ANY usado para acessar todas as dimensoes(todas as celulas) com notação posicional
--IS ANY é usado para a mesma coisa só que co notação nomeada
 SELECT prd_type_id,
       year,
       month,
       sales_amount
FROM all_sales
WHERE prd_type_id BETWEEN 1 AND 2
    AND
        emp_id   = 21
MODEL
    PARTITION BY ( prd_type_id ) DIMENSION BY ( month,year ) MEASURES ( amount sales_amount )
    RULES( sales_amount[1,2004] = round(
        SUM(sales_amount) [ANY,year IS ANY],
        2
    ) )
ORDER BY prd_type_id,year,month;

--NULLS e valores ausentes
--IS PRESENT -Retorna verdadeiro caso o registro especificado pela referncia na celula exista antes da execução do MODEL
--Como o employee_id 5 e consequentemente o salario nao existem na tabela antes da execução do MODEL, o IS PRESENT retorna falso

SELECT employee_id,
   salaries
FROM employees MODEL
DIMENSION BY ( employee_id ) MEASURES ( salary salaries )
RULES( salaries[FOR employee_id FROM 1 TO 5 INCREMENT 1 ] =
    CASE
        WHEN salaries[currentv() ] IS PRESENT THEN 1
        ELSE 0
    END
)
ORDER BY employee_id;

--PRESENTV() retorna o segundo parâmetro caso o registro exista antes do MODEL, caso o registro senão retorna o terceiro parâmetro

SELECT employee_id,
   salaries
FROM employees MODEL
DIMENSION BY ( employee_id ) MEASURES ( salary salaries )
RULES( salaries[FOR employee_id FROM 1 TO 5 INCREMENT 1 ] =
    PRESENTV(salaries[currentv()], salaries[currentv()], 0)
)
ORDER BY employee_id;

--PRESENTNNV retorna o segundo parâmetro caso o valor refernciado pela dimensão(manager_id) exista antes do MODEL e não seja nulo.
--Caso seja nulo ou não existe na tabela antes do MODEL, retorna o terceiro parâmetro
--No exemplo, o employee_id 1 não tem manager
SELECT employee_id,
       managers
FROM employees MODEL
    DIMENSION BY ( employee_id ) MEASURES ( manager_id managers )
        RULES
    ( managers[employee_id BETWEEN 1 AND 4] = presentnnv(
        managers[currentv() ],
        managers[currentv() ],
        0
    ) )
    order by employee_id;
    
--Usando a funcao cv() para pegar o valor atual da dimensão(nesse exemplo a dimensão é o employee_id)
SELECT employee_id,
       salaries
FROM employees MODEL
    DIMENSION BY ( employee_id ) MEASURES ( salary salaries )
        RULES
    ( salaries[5] = cv(employee_id) );
    
SELECT employee_id,
       double_salary
       from employees
       MODEL DIMENSION BY(employee_id) MEASURES(salary double_salary) RULES()
    
--UPDATE, UPSERT
--Como na regra pede para atualizar os valores do lado esquerdo caso existam, 
--nada é feito no MODEL porque não há o employee_id 5 e o seu salario na tabela antes do MODEL

SELECT employee_id, double_salary FROM employees MODEL
    DIMENSION BY ( employee_id ) MEASURES ( salary double_salary )
        RULES UPDATE
    ( double_salary[5] = double_salary[CURRENTV()] * 2 )
    order by employee_id;
    
--Para coloca-lo no resultado deve-se usar UPSERT já que o registro não existe
--Como não há salario para o employee_id 5, usa-se nulo como padrão e NULL * 2 = NULL
SELECT employee_id, double_salary FROM employees MODEL
    DIMENSION BY ( employee_id ) MEASURES ( salary double_salary )
        RULES UPSERT
    ( double_salary[5] = double_salary[CURRENTV()] * 2 )
    order by employee_id;
    
    
    
    
    
    
    
    
    
    
    