train  <- read.csv('HousePrices/Data/train.csv')
View(train)



attach(training_data)
factor(MSSubClass,MSZoning,)

library(dplyr)

a <- data.frame(sapply(X=training_data, FUN= class))

a_ <- a %>% filter(sapply.X...training_data..FUN...class. != 'factor')
