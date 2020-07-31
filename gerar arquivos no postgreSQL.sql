
COPY(select 
        a.produto,
        a.codigo_antigo,
        a.descricao,
        a.preco_fabrica,
        a.preco_maximo,
        a.desconto_padrao        
      from procfit.tb_produtos a
      limit 10
)to '/mnt/trab/USUARIOS/TI/transferencia/ambulatorio/tb_produtos.csv' with csv;

truncate table desenvolvimento.spfil006_new;
    copy desenvolvimento.spfil006_new (
        produto,
        codigo_antigo,
        descricao,
        preco_fabrica,
        preco_maximo,
        desconto_padrao        
)
from '/mnt/trab/USUARIOS/TI/transferencia/ambulatorio/tb_produtos.csv' DELIMITER ',' CSV;
