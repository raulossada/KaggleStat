zbrowserDriver <- rsDriver(port=4567L);
zbrowser <- zbrowserDriver[["client"]];

for(ii in 1:nrow(tabela1) ){
  
  zUrl <- tabela1$URL[ii];
  
  zbrowser$navigate(zUrl);
  
  Sys.sleep(time=8);
  
}

# Fecha o navegador
zbrowser$close();

# Para o servidor do navegador
zbrowserDriver$server$process;
zbrowserDriver$server$stop();
zbrowserDriver$server$process;
