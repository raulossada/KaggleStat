setwd("C:/Users/raul/Desktop/IME_BE/KaggleStat/WebScraping");

html2char <- function(x){
  # Dicionário com os códigos HTML
  dicionarioHTML <- data.frame(
    html=c("&#xE7;", "&#xE3;", "&#xF3;", "&#xCD;", "&#xC7;", "&#xE9;", "&#xE1;", 
           "&amp;", "&#xD3;", "&#xC2;", "&#xED;", "&#xC1;", "&#xFA;"), 
    simbolo=c("ç", "ã", "ó", "Í", "Ç", "é", "á", "&", "Ó", "Â", "í", "Á", "ú") 
  );
  
  # Para cada código HTML verifica se este aparece na palavra
  for( kk in 1:nrow(dicionarioHTML) ){
    x <- gsub(pattern=dicionarioHTML$html[kk], 
              replacement=dicionarioHTML$simbolo[kk], 
              x=x);
  }
  
  return(x);
}

#############################################################################

library("RSelenium");
library("XML");


zUrl <- "http://www2.bmf.com.br/pages/portal/bmfbovespa/lumis/lum-ajustes-do-pregao-ptBR.asp";

# Abre o navegador
zbrowserDriver <- rsDriver(port=4567L);
zbrowser <- zbrowserDriver[["client"]];
zbrowser$navigate(zUrl);

#############################################################################

listaDatas <- seq(from=as.Date("17/05/2017", format="%d/%m/%Y"), 
                  to=as.Date("31/05/2017", format="%d/%m/%Y"), 
                  by="days");
listaDatas <- format(x=listaDatas, "%d/%m/%Y");


for(dataEscolhida in listaDatas){
  
  # Campo
  zbox <- zbrowser$findElement(using="css selector", "#dData1");
  zbox$clearElement();
  zbox$sendKeysToElement( list(dataEscolhida) );
  
  # Botão
  zbutton <- zbrowser$findElement(using="css selector", ".expand");
  zbutton$clickElement();
  
  rm( list=c("dataEscolhida", "zbox", "zbutton") );
  
  #############################################################################
  
  # Pega a data em que os dados foram atualizados
  webAtualizadoEm <- zbrowser$findElement(using="css selector", ".legenda");
  htmlAtualizadoEm <- webAtualizadoEm$getElementAttribute("outerHTML")[[1]];
  
  atualizadoEm <- sub(pattern=".*: ", replacement="", x=htmlAtualizadoEm);
  atualizadoEm <- sub(pattern="\n.*", replacement="", x=atualizadoEm);
  
  rm( list=c("webAtualizadoEm", "htmlAtualizadoEm") );
  
  #############################################################################
  
  # Pega a versão compactada dos dados XML da página
  
  tryCatch({
    suppressMessages({
      webTabelaDadosAjustes <- zbrowser$findElement(using="id", value="tblDadosAjustes");
      
      htmlTabelaDadosAjustes <- webTabelaDadosAjustes$getElementAttribute("outerHTML")[[1]];
      
      #############################################################################
      
      # Pega o XML da pagina
      xmlTabelaDadosAjustes <- xmlTreeParse(file=htmlTabelaDadosAjustes, useInternalNodes=T);
      
      
      atualizadoEm3 <- strsplit(x=atualizadoEm, "/");
      atualizadoEm3 <- unlist(atualizadoEm3);
      atualizadoEm3 <- paste( atualizadoEm3[3], "_", atualizadoEm3[2], "_", 
                              atualizadoEm3[1], sep="" );
      
      
      atualizadoEm2 <- gsub(pattern="/", replacement="_", x=atualizadoEm);
      arquivoNomeXml <- paste("tabelaXML_", atualizadoEm2, ".xml", sep="");
      
      saveXML(doc=xmlTabelaDadosAjustes, file=arquivoNomeXml);
      
      rm( list=c("webTabelaDadosAjustes", "htmlTabelaDadosAjustes", "xmlTabelaDadosAjustes") );
      
      #############################################################################
      
      # Le o arquivo xml. Foi o jeitinho que eu achei de transformar o xml em char
      thepage <- readLines(con=arquivoNomeXml);
      
      if( file.exists(arquivoNomeXml)==TRUE ){
        file.remove(arquivoNomeXml);
      }
      
      rm( list=c("arquivoNomeXml") );
      
      #############################################################################
      
      # Pega os nomes das colunas da tabela
      webTitulos <- grep(pattern="<th ", x=thepage, value=TRUE);
      titulos <- sub(pattern=".*\">", replacement="", x=webTitulos);
      titulos <- sub(pattern="</th>$", replacement="", x=titulos);
      titulos <- c(titulos, "Data Atualização");
      
      titulos <- html2char(titulos);
      
      rm( list=c("webTitulos") );
      
      #############################################################################
      
      # Separa a tabela HTML
      webTabela <- grep(pattern="<td", x=thepage, value=TRUE);
      # Cria uma tabela com os dados
      tabelaDados <- NULL;
      ii <- 1;
      while(ii < length(webTabela) ){
        tagMercadoria <- sub(pattern=".*<td ", replacement="", x=webTabela[ii]);
        tagMercadoria <- sub(pattern="=.*$", replacement="", x=tagMercadoria);
        
        candidataMercadoria <- sub(pattern=".*>(.*?)", replacement="", x=webTabela[ii]);
        candidataMercadoria <- sub(pattern=" *</td>$", replacement="", x=candidataMercadoria);
        
        if(tagMercadoria!="class"){
          Mercadoria <- candidataMercadoria;
        }else{
          ii <- ii-1;
        }
        
        webLinhaDados <- webTabela[(ii+1):(ii+5)];
        LinhaDados <- sub(pattern=".*\">", replacement="", x=webLinhaDados);
        LinhaDados <- sub(pattern=" </td>$", replacement="", x=LinhaDados);
        LinhaDados <- sub(pattern="</td>$", replacement="", x=LinhaDados);
        LinhaDados <- data.frame( t( c(Mercadoria, LinhaDados) ) );
        
        tabelaDados <- rbind(tabelaDados, LinhaDados);
        ii <- ii+6;
      }
      
      tabelaDados <- cbind(tabelaDados, atualizadoEm);
      
      names(tabelaDados) <- titulos;
      
      tabelaDados$Mercadoria <- html2char(tabelaDados$Mercadoria);
      
      rm( list=c("atualizadoEm", "LinhaDados", "candidataMercadoria", "ii", "Mercadoria", 
                 "thepage", "tagMercadoria", "titulos", "webLinhaDados", "webTabela") );
      
      #############################################################################
      
      arquivoNomeCsvPtBr <- paste("derivativos_ajuste_", atualizadoEm3, ".csv", sep="");
      
      if( file.exists(arquivoNomeCsvPtBr)==FALSE ){
        write.csv2(x=tabelaDados, file=arquivoNomeCsvPtBr, row.names=FALSE);
      }
      
      rm( list=c("tabelaDados", "arquivoNomeCsvPtBr", 
                 "atualizadoEm2", "atualizadoEm3") );
    })
  }, error=function(e){
    erro <- 1;
  });
}

# Fecha o navegador
zbrowser$close();

# Para o servidor do navegador
zbrowserDriver$server$process;
zbrowserDriver$server$stop();
zbrowserDriver$server$process;

rm( list=c("zbrowser", "zbrowserDriver", "html2char", "listaDatas", "zUrl") );
