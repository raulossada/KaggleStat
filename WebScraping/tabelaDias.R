library("bizdays");

dias <- seq(as.Date("2017-08-04"), as.Date("2020-01-01"), by="days");

diasSemana <- weekdays(dias);

eDiaUtil <- is.bizday(dates=dias, cal="Brazil/ANBIMA");
eDiaUtil <- as.integer(eDiaUtil);

tabela1 <- data.frame(dias, diasSemana, eDiaUtil);



# Tesouro Prefixado 2020 (LTN)	01/01/2020	8,56%	R$32,86	R$821,57


pu <- 821.57
tx_rend <- 8.56/100;

pu_proximo_dia <- 821.57 * (1 + tx_rend)^(1/252);

pu_atual_dia <- 821.57;
coluna1 <- NULL;
for( ii in 1:603){
  pu_proximo_dia <- pu_atual_dia * (1 + tx_rend)^(1/252);
  
  coluna1 <- rbind(coluna1, as.numeric(pu_proximo_dia) );
  
  pu_atual_dia <- pu_proximo_dia;
}

coluna1

sum( coluna1*(0.3/100) )

821.57 * (1 + tx_rend)^(603/252);

(603/252)

820,634803


> 
> 
  > # Cria o calendário
  > 
  > create.calendar(name="Brazil/ANBIMA", 
                    +                 holidays=holidaysANBIMA, 
                    +                 weekdays=c("saturday", "sunday") );
> 
  > qt_dias_uteis <- bizdays(from=data_compra, to=data_vencimento, cal="Brazil/ANBIMA");