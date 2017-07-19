# install.packages("data.table");
# install.packages("knitr");
# install.packages("miniUI");
# install.packages("shiny");
# install.packages("taskscheduleR", repos="http://www.datatailor.be/rcube", type="source");


setwd("C:/Users/raul/Desktop/IME_BE/KaggleStat/WebScraping");

listaBasesColetadas <- list.files(path=".", pattern = "ms");


ano1 <- substr(x=listaBasesColetadas[1], start=3, stop=6);
mes1 <- substr(x=listaBasesColetadas[1], start=7, stop=8);
dia1 <- substr(x=listaBasesColetadas[1], start=9, stop=10);
dia2 <- as.character( as.numeric(dia1) - 1 );

nomeArquivoAnterior <- paste("ms", ano1, mes1, dia2, ".csv", sep="");

if( file.exists(nomeArquivoAnterior)==FALSE ){
  
  ano2 <- substr(x=ano1, start=3, stop=4);
  
  falhou <- 1;
  while(falhou==1){
    
    zUrl <- paste("http://www.anbima.com.br/merc_sec/arqs/ms", ano2, mes1, dia2, ".txt", sep="");

    falhou <- tryCatch({
      dados <- read.table(file=zUrl, header=TRUE, sep="@", skip=1, as.is=TRUE);
      falhou <- 0;
    }, warning = function(w) {
      falhou <- 1;
    });
    
    dia2 <- as.character( as.numeric(dia2) - 1 );
    
  }
  dia2 <- as.character( as.numeric(dia2) + 1 );
  
  colnames(dados) <- gsub(pattern="\\.", replacement="", x=colnames(dados) );
  
  dataAnterior <- paste(ano1, "-", mes1, "-", dia2, sep="");
  dados$DataAtualizacao <- dataAnterior;
  
  source("charComma2dot.R");
  dados[, 6:14] <- apply(X=dados[, 6:14], MARGIN=2, FUN=charComma2dot );
  
  falhou <- tryCatch({
  dados[, 6:14] <- apply(X=dados[, 6:14], MARGIN=2, FUN=as.numeric );
  }, warning = function(w) {
  });
  
  nomeArquivo <- paste("ms", ano1, mes1, dia2, ".csv", sep="");
  write.csv2(x=dados, file=nomeArquivo, row.names=FALSE);
}
