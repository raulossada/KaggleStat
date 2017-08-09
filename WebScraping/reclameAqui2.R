library("RSelenium");
library("XML");

zUrl <- "https://www.reclameaqui.com.br/busca/?q=qualy";

# Abre o navegador
zbrowserDriver <- rsDriver(port=4567L, browser = "firefox");
zbrowser <- zbrowserDriver[["client"]];
zbrowser$navigate(zUrl);

tabela1 <- NULL;
################################################################################################
for(ii in 1:28){
  print( paste("Webscrapping page", ii) );
  
  mainPageSource <- zbrowser$getPageSource();
  
  
  mainPageSource <- htmlParse(file=mainPageSource[[1]]);
  
  saveXML(doc=mainPageSource, file="mainPageSource.xml");
  
  mainPageSource <- readLines(con="mainPageSource.xml");
  
  file.remove("mainPageSource.xml");
  
  ################################################################################################
  # Pega os tópicos
  mainPageTopics <- grep(pattern='<h2 class="ng-binding">', x=mainPageSource, value=TRUE);
  
  
  titulo <- sub(pattern='.*<h2 class="ng-binding">', replacement="", x=mainPageTopics);
  titulo <- sub(pattern='</h2>.*', replacement="", x=titulo);
  
  
  link <- sub(pattern='.*</span> <a href="', replacement="", x=mainPageTopics);
  link <- sub(pattern='".*', replacement="", x=link);
  link <- paste0("https://www.reclameaqui.com.br", link);
  
  
  carinha <- sub(pattern='.*<img src="../../images/icons/', replacement="", x=mainPageTopics);
  carinha <- sub(pattern='\\..*', replacement="", x=carinha);
  
  
  empresa <- sub(pattern='.*title="', replacement="", x=mainPageTopics);
  empresa <- sub(pattern='">.*', replacement="", x=empresa);
  
  
  local <- sub(pattern='.*<img class="pin-maps" src="../../../images/pin-maps.52fa5ca3.png" width="10" height="14"> ', replacement="", x=mainPageTopics);
  local <- sub(pattern=' <i.*', replacement="", x=local);
  
  
  data_hora <- sub(pattern='.*<i class=\"fa fa-calendar\"></i> ', replacement="", x=mainPageTopics);
  data_hora <- sub(pattern='<br.*', replacement="", x=data_hora);
  data <- sub(pattern=' às.*', replacement="", x=data_hora);
  hora <- sub(pattern='.*às ', replacement="", x=data_hora);
  
  
  reclamacao_parcial <- sub(pattern='.*removeNewLinesDecorator\">', replacement="", x=mainPageTopics);
  reclamacao_parcial <- sub(pattern='</p> </div>', replacement="", x=reclamacao_parcial);
  reclamacao_parcial <- gsub(pattern='<b>|</b>', replacement="", x=reclamacao_parcial);
  
  
  tabela2 <- data.frame( cbind(titulo, link, carinha, empresa, local, data, hora, reclamacao_parcial) );
  
  tabela1 <- rbind(tabela1, tabela2);
  
  # Zera o source
  mainPageSource <- NULL;
  
  # Vai para a proxima página
  zbuttonNext <- NULL;
  zbuttonNext <- zbrowser$findElement(using="css selector", '.pagination-next > a:nth-child(1)');
  zbuttonNext$highlightElement();
  zbuttonNext$clickElement();
  
  # Pausando a execucao do código, para garantir que a nova página estará carregada
  Sys.sleep(time=10);
  
  # if( is.null(zbutton1)==FALSE ){
  #   # Vai para a proxima página
  #   zbutton2 <- zbrowser$findElement(using="xpath", '//*[@id="search-results"]/div/div[2]/div[1]/div[3]/div/ul[2]/li[9]/a');
  #   zbutton2$highlightElement();
  #   zbutton2$clickElement();
  #   
  # }else{
  #   # Para de buscar
  # }
}
print( "Finished Webscrapping" );

# Fecha o navegador
zbrowser$close();

# Para o servidor do navegador
zbrowserDriver$server$process;
zbrowserDriver$server$stop();
zbrowserDriver$server$process;

write.csv2(x=tabela1, file="reclame_aqui1.csv");

################################################################################################
################################################################################################
ii <- 2;
zUrl <- link[ii];
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

