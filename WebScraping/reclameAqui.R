library("RSelenium");

zUrl <- "https://www.reclameaqui.com.br/busca/?q=qualy";

# Abre o navegador
zbrowserDriver <- rsDriver(port=4567L);
zbrowser <- zbrowserDriver[["client"]];
zbrowser$navigate(zUrl);

# “xpath”, “css selector”, “id”, “name”, “tag name”, “class name”, “link text”, “partial link text”
# //*[contains(concat( " ", @class, " " ), concat( " ", "ng-touched", " " ))]
# //*[contains(concat( " ", @class, " " ), concat( " ", "hidden-sm", " " ))]
# 
# 
# //*[contains(concat( " ", @class, " " ), concat( " ", "ng-empty", " " ))]
# //*[contains(concat( " ", @class, " " ), concat( " ", "btn-gray-darkest", " " ))]
zbox <- zbrowser$findElement(using="xpath", '//*[contains(concat( " ", @class, " " ), concat( " ", "ng-empty", " " ))]');
zbox$highlightElement();

webElem <- zbrowser$findElement(using = 'xpath', "//*/input[@class = 'ng-empty']")


zbox$clearElement();
zbox$sendKeysToElement( list("swi la") );


# Fecha o navegador
zbrowser$close();

# Para o servidor do navegador
zbrowserDriver$server$process;
zbrowserDriver$server$stop();
zbrowserDriver$server$process;
