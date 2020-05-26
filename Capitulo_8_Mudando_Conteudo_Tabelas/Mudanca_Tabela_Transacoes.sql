SELECT * FROM product_changes;

--MERGE
--O merge serve para juntar os registros de uma tabela com outra.
--Na prática ele permite alterar ou inserir registros numa tabela dependendo de as colunas das duas tabelas são iguais(they match) ou não
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

--Concorrencia de transação

--A maneira que o oracle usa para garantir que duas transaçoes não modifiquem o mesmo registro simultaneamente é por travas
--Vamos supor que T1 vai fazer um Update. T1 faz esse update só que não faz o commit. T1 travou o registro
--T2 quer fazer um Update, mas com o registro esta travado por T1, T2 deve esperar até T! fazer o commit ou rollback e liberar a trava
--T1 faz o commit e T2 pode fazer o Update e travar novamente o registro

--Em resumo não é possível um registro ser travado por mai de uma transação. Enquanto uma transação trava o registro que a próxima precisa,
--Essa prócima transação DEVE esperar