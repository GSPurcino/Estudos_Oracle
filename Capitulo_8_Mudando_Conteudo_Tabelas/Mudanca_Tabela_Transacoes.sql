SELECT * FROM product_changes;

--MERGE
--O merge serve para juntar os registros de uma tabela com outra.
--Na pr�tica ele permite alterar ou inserir registros numa tabela dependendo de as colunas das duas tabelas s�o iguais(they match) ou n�o
--Exemplo abaixo:

MERGE INTO products p USING product_changes pc ON (
    p.product_id = pc.product_id
) WHEN MATCHED THEN
    UPDATE
SET p.product_type_id = pc.product_type_id,
    p.name = pc.name,
    p.description = pc.description,
    p.price = pc.price
WHEN NOT MATCHED THEN INSERT ( p.product_id,p.product_type_id,p.name,p.description,p.price ) VALUES ( pc.product_id,pc.product_type_id
,pc.name,pc.description,pc.price );

SELECT product_id, product_type_id, name, price
FROM products
WHERE product_id IN (1, 2, 3, 13, 14, 15);

--Concorrencia de transa��o

--A maneira que o oracle usa para garantir que duas transa�oes n�o modifiquem o mesmo registro simultaneamente � por travas
--Vamos supor que T1 vai fazer um Update. T1 faz esse update s� que n�o faz o commit. T1 travou o registro
--T2 quer fazer um Update, mas com o registro esta travado por T1, T2 deve esperar at� T! fazer o commit ou rollback e liberar a trava
--T1 faz o commit e T2 pode fazer o Update e travar novamente o registro

--Em resumo n�o � poss�vel um registro ser travado por mai de uma transa��o. Enquanto uma transa��o trava o registro que a pr�xima precisa,
--Essa pr�cima transa��o DEVE esperar