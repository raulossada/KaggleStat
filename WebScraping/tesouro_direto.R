library("XML");

# http://www.tesouro.fazenda.gov.br/tesouro-direto-precos-e-taxas-dos-titulos

zUrl <- "http://www.tesouro.fazenda.gov.br/tesouro-direto-precos-e-taxas-dos-titulos";



webPage <- readLines(con=zUrl, warn=FALSE);
webAtualizadoEm <- htmlParse(file=webPage, useInternalNodes=T);
saveXML(doc=webAtualizadoEm, file="teste.xml");

webPage <- readLines(con="teste.xml");

arquivoNomeXml <- "teste.xml";
if( file.exists(arquivoNomeXml)==TRUE ){
  file.remove(arquivoNomeXml);
}



webAtualizadoEm <- grep(pattern="Atualizado em", x=webPage, value=TRUE);
atualizadoEm <- sub(pattern=".*<b>", replacement="", x=webAtualizadoEm);
atualizadoEm <- sub(pattern="</b>.*", replacement="", x=atualizadoEm);
data_hora <- unlist( strsplit(x=atualizadoEm, split=" ") );



webTabelas <- readHTMLTable(doc=zUrl, header=TRUE, encoding="UTF-8");
investir <- webTabelas[[2]];
investir$atualizado_data <- data_hora[1];
investir$atualizado_hora <- data_hora[2];


resgatar <- webTabelas[[4]];
resgatar$atualizado_data <- data_hora[1];
resgatar$atualizado_hora <- data_hora[2];


removerLinhas1 <- which( investir$`Título` %in% c("Indexados ao IPCA", "Prefixados", "Indexados à Taxa Selic", "Indexados ao IGP-M") );
investir <- investir[-removerLinhas1, ];

removerLinhas2 <- which( resgatar$`Título` %in% c("Indexados ao IPCA", "Prefixados", "Indexados à Taxa Selic", "Indexados ao IGP-M") );
resgatar <- resgatar[-removerLinhas2, ];


# paste
write.csv2(x=investir, file="investir_2017_07_18_15_34.csv", row.names=FALSE);
write.csv2(x=resgatar, file="resgatar_2017_07_18_15_34.csv", row.names=FALSE);



