library("RSelenium");
library("XML");
library("xlsx");

# Inputs do usuario
empresa <- "Sadia";

termo <- "qualy";

usrDataFrom <- "12/03/2017";
usrDataFrom <- strptime(x=usrDataFrom, format="%d/%m/%Y", tz="GMT");


usrDataTo <- "13/08/2017";
# usrDataTo <- strptime(x=usrDataTo, format="%d/%m/%Y", tz="GMT");
usrDataTo <- paste(usrDataTo,"23:59:59", sep=" ");
usrDataTo <- strptime(x=usrDataTo, format="%d/%m/%Y %H:%M:%S", tz="GMT");


# Abre o navegador
zUrl <- "https://www.reclameaqui.com.br/";
# zbrowserDriver <- rsDriver(port=4567L, browser="firefox");
zbrowserDriver <- rsDriver(port=4567L);
zbrowser <- zbrowserDriver[["client"]];
zbrowser$navigate(zUrl);


################################################################################################
zSearchField1 <- zbrowser$findElement(using="xpath", value='//*[@id="reputation-input-search"]');
zSearchField1$highlightElement();
zSearchField1$clearElement();
zSearchField1$sendKeysToElement( list(empresa) );


zSearchButton1 <- zbrowser$findElement(using="xpath", value='//*[@id="cover"]/div[3]/form/div[1]/div[1]/div/div[2]/button');
zSearchButton1$highlightElement();
zSearchButton1$clickElement();

# Pausando a execucao do código, para garantir que a nova página estará carregada
Sys.sleep(time=8);
################################################################################################
zSearchField2 <- zbrowser$findElement(using="xpath", value='//*[@id="search-results"]/div/div[2]/div[1]/div[2]/form/div/input');
zSearchField2$highlightElement();
zSearchField2$clearElement();
zSearchField2$sendKeysToElement( list(termo) );


zSearchButton2 <- zbrowser$findElement(using="xpath", value='//*[@id="search-results"]/div/div[2]/div[1]/div[2]/form/div/span/button');
zSearchButton2$highlightElement();
zSearchButton2$clickElement();



################################################################################################
################################################################################################
tabela1 <- NULL;
continuaBusca <- TRUE;
ii <- 1;
while(continuaBusca==TRUE){
  
  print( paste("Webscrapping page", ii) );
  
  
  # Pausando a execucao do código, para garantir que a nova página estará carregada
  Sys.sleep(time=8);
  
  
  mainPageSource <- zbrowser$getPageSource();
  
  
  mainPageSource <- htmlParse(file=mainPageSource[[1]]);
  
  saveXML(doc=mainPageSource, file="mainPageSource.xml");
  
  mainPageSource <- readLines(con="mainPageSource.xml");
  
  file.remove("mainPageSource.xml");
  
  ################################################################################################
  # Pega os tópicos
  mainPageTopics <- grep(pattern='<h2 class="ng-binding">', x=mainPageSource, value=TRUE);
  
  
  # titulo <- sub(pattern='.*<h2 class="ng-binding">', replacement="", x=mainPageTopics);
  # titulo <- sub(pattern='</h2>.*', replacement="", x=titulo);
  
  
  # URL <- sub(pattern='.*</span> <a href="', replacement="", x=mainPageTopics);
  # URL <- sub(pattern='".*', replacement="", x=URL);
  URL <- sub(pattern='\"> <h2 class=.*', replacement="", x=mainPageTopics);
  URL <- sub(pattern='.*href=\"', replacement="", x=URL);
  URL <- paste0("https://www.reclameaqui.com.br", URL);
  
  
  # carinha <- sub(pattern='.*<img src="../../images/icons/', replacement="", x=mainPageTopics);
  # carinha <- sub(pattern='\\..*', replacement="", x=carinha);
  
  
  # empresa <- sub(pattern='.*title="', replacement="", x=mainPageTopics);
  # empresa <- sub(pattern='">.*', replacement="", x=empresa);
  
  
  # local <- sub(pattern='.*<img class="pin-maps" src="../../../images/pin-maps.52fa5ca3.png" width="10" height="14"> ', replacement="", x=mainPageTopics);
  # local <- sub(pattern=' <i.*', replacement="", x=local);
  
  
  DATE <- sub(pattern='.*<i class=\"fa fa-calendar\"></i> ', replacement="", x=mainPageTopics);
  DATE <- sub(pattern='<br.*', replacement="", x=DATE);
  data <- sub(pattern=' .*', replacement="", x=DATE);
  hora <- sub(pattern='.* ', replacement="", x=DATE);
  DATE <- paste(data, hora, sep=" ");
  DATE <- strptime(x=DATE, format="%d/%m/%y %Hh%M", tz="GMT");
  DATE <- strftime(x=DATE, format="%d/%m/%Y %H:%M:%S", usetz=FALSE);
  
  
  CONTENT <- sub(pattern='.*removeNewLinesDecorator\">', replacement="", x=mainPageTopics);
  CONTENT <- sub(pattern='</p> </div>', replacement="", x=CONTENT);
  CONTENT <- gsub(pattern='<b>|</b>', replacement="", x=CONTENT);
  

  tabela2 <- data.frame( cbind(URL, DATE, CONTENT), stringsAsFactors=FALSE );
  
  tabela1 <- rbind(tabela1, tabela2);
  
  # Zera o source
  mainPageSource <- NULL;
  
  
  ultimaData <- tabela2$DATE[ nrow(tabela2) ];
  ultimaData <- strptime(x=ultimaData, format="%d/%m/%Y %H:%M:%S", tz="GMT");
  
  # Se a última data da tabela2 for após ou igual à data que o usuário quer
  # Continua a busca na próxima página
  # Pois a próxima página pode ter entradas iguais à data desejada pelo usuário
  if(ultimaData>=usrDataFrom){
    # Vai para a proxima página
    zbuttonNext <- NULL;
    zbuttonNext <- zbrowser$findElement(using="css selector", '.pagination-next > a:nth-child(1)');
    zbuttonNext$highlightElement();
    zbuttonNext$clickElement();
    ii <- ii+1;
  }else{
    continuaBusca <- FALSE;
  }
}
print( "Finished Webscrapping" );

# Fecha o navegador
zbrowser$close();

# Para o servidor do navegador
zbrowserDriver$server$process;
zbrowserDriver$server$stop();
zbrowserDriver$server$process;

tabela1$DATE <- strptime(x=tabela1$DATE, format="%d/%m/%Y %H:%M:%S", tz="GMT");

tabela3 <- tabela1[ which(tabela1$DATE >= usrDataFrom), ];
tabela3 <- tabela3[ which(tabela3$DATE <= usrDataTo), ];

nomesColunas <- c("SENTIMENT", "TAG", "TOPICS", "AUDIENCE", "TERM", "AUTHOR_NAME", 
                  "AUTHOR_GENDER", "AUTHOR_LOCATION*", "AUTHOR_CITY", "AUTHOR_PROVINCE", 
                  "AUTHOR_COUNTRY", "AUTHOR_SITE", "SERVICE", "REPERCUSSION", "POPULARITY", 
                  "RELEVANCE", "INFLUENCE");
tabela3[, nomesColunas] <- NA;

termoMaiuscula <- toupper(x=termo);
tabela3$SENTIMENT <- "NEGATIVE";
tabela3$TERM <- termoMaiuscula;
tabela3$SERVICE <- "FORUNS";

# usrMonth <- toupper( strftime(x=usrDataFrom, format="%B") );
# nomeArquivo <- paste0("RA_", termoMaiuscula, "_", usrMonth, ".xlsx");
# write.xlsx2(x=tabela3, file=nomeArquivo, row.names=FALSE);



nomeArquivo2 <- paste0("RA_", termoMaiuscula, "_", 
                       strftime(x=usrDataFrom, format="%Y_%m_%d"), "_a_", 
                       strftime(x=usrDataTo, format="%Y_%m_%d"), ".xlsx");
write.xlsx2(x=tabela3, file=nomeArquivo2, row.names=FALSE);

tabela4 <- tabela3;
tabela4$CONTENT <- iconv(x=tabela4$CONTENT, from="UTF-8", to="ISO-8859-2");
nomeArquivo3 <- paste0("RA_", termoMaiuscula, "_", 
                       strftime(x=usrDataFrom, format="%Y_%m_%d"), "_a_", 
                       strftime(x=usrDataTo, format="%Y_%m_%d"), ".csv");
write.csv2(x=tabela4, file=nomeArquivo3, row.names=FALSE);
################################################################################################
################################################################################################
ii <- 2;
zUrl <- URL[ii];
zUrl

zbrowser$navigate(zUrl);

subPageSource <- zbrowser$getPageSource();

################################################################################################

subPageSource <- htmlParse(file=subPageSource[[1]]);

saveXML(doc=subPageSource, file="subPageSource.xml");

subPageSource <- readLines(con="subPageSource.xml");

file.remove("subPageSource.xml");

################################################################################################

id <- grep(pattern='<b class="ng-binding">', x=subPageSource, value=TRUE);
id <- sub(pattern='.*<b class="ng-binding">ID: ', replacement="", x=id);
id <- sub(pattern='</b></li>', replacement="", x=id);


reclamacao <- grep(pattern='<p class=\"ng-binding\" ng-bind-html=\"reading.complains.description', x=subPageSource, value=TRUE);
reclamacao <- sub(pattern='.*Decorator\">', replacement="", x=reclamacao);
reclamacao <- sub(pattern='</p>.*', replacement="", x=reclamacao);


resposta <- grep(pattern='class="ng-binding ng-scope"', x=subPageSource, value=TRUE);
resposta <- sub(pattern='.*Decorator\">', replacement="", x=resposta);
resposta <- sub(pattern='</p>', replacement="", x=resposta);
resposta <- gsub(pattern='<br><br>', replacement=" ", x=resposta);
resposta <- gsub(pattern='<br>', replacement=" ", x=resposta);


# Fecha o navegador
zbrowser$close();

# Para o servidor do navegador
zbrowserDriver$server$process;
zbrowserDriver$server$stop();
zbrowserDriver$server$process;

################################################################################################

form-control ng-pristine ng-valid ng-empty ng-touched

form-control ng-pristine ng-valid ng-empty ng-touched

zbox <- zbrowser$findElement(using="class name", "form-control ng-pristine ng-valid ng-empty ng-touched");
zbox$clearElement();
zbox$sendKeysToElement( list(dataEscolhida) );

form-control ng-pristine ng-valid ng-empty ng-touched

webElem <- zbrowser$findElement(using="class name", 
                                value="form-control")
webElem$highlightElement()

webElem$sendKeysToElement( list("Tudo bem?") );
webElem$clearElement();



“xpath”, “css selector”, “id”, “link text”, “partial link text”

“name”, “tag name”, “class name”, 

