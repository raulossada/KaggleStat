zUrl <- "http://www.bmfbovespa.com.br/pt_br/servicos/market-data/consultas/mercado-de-derivativos/indicadores/indicadores-financeiros/"


library("XML");

tabelas <- readHTMLTable(doc=zUrl);

tabela1 <- tabelas[[1]];

tabela2 <- tabelas[[2]];

tabela3 <- tabelas[[3]];

tabela4 <- tabelas[[4]];

colnames(tabela4)

#####
thepage <- readLines(con=zUrl, warn=FALSE);
datalines <- grep(pattern="<p align=\"right\" class=\"legenda\">atualizado em:", thepage, value=TRUE);
