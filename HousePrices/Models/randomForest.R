#Testes de modelos
#Dê um setwd na pasta HousePrices, onde quer que ela esteja em sua máquina


#Importando dados

##Treinamento
training_data <- read.csv(file="Data/train.csv", as.is=FALSE);
remover_colunas <- c("Id"); 
training_data <- training_data[ , !(names(training_data) %in% remover_colunas ) ];

##Teste
test_data <- read.csv(file="Data/train.csv", as.is=FALSE);
remover_colunas <- c("Id"); 
test_data <- test_data[ , !(names(test_data) %in% remover_colunas ) ];

#Tratando dados

##Treinamento
training_data$MSSubClass <- as.factor(training_data$MSSubClass);
training_data$OverallQual <- factor(training_data$OverallQual,levels= c(1,2,3,4,5,6,7,8,9,10));
training_data$OverallCond <- factor(training_data$OverallCond,levels= c(1,2,3,4,5,6,7,8,9,10));

vars_tipo <- sapply(X=training_data, FUN=class )

quantitativas_training <- training_data[ , which(vars_tipo == "integer")]
qualitativas_training <- training_data[ , which(vars_tipo == "factor")]

##Test
test_data$MSSubClass <- as.factor(test_data$MSSubClass);
test_data$OverallQual <- factor(test_data$OverallQual,levels= c(1,2,3,4,5,6,7,8,9,10));
test_data$OverallCond <- factor(test_data$OverallCond,levels= c(1,2,3,4,5,6,7,8,9,10));

quantitativas_test <- test_data[ , which(vars_tipo == "integer")]
qualitativas_test <- test_data[ , which(vars_tipo == "factor")]

#Primeiro desafio: Escolher as váriaveis explicativas para usar
#Espaço para a escolha kk


#Random Forest

##Pacotes que serão utilizados
##incluir em libs novos pacotes
libs = c('randomForest');
for(ii in libs){
  if(!( ii %in% installed.packages())){
    install.packages(ii);
  }
  library(ii, character.only=TRUE );
}

#Estudar as assunções para usar o Random Forest
#Somente com váriaveis contínuas? O que fazer com os NAs? Como selecionar váriaveis?
#Tratar as váriaveis categóricas


#Apenas com as váriaveis quantitativas

## Remover NA
quantitativas_training_sem_na <- quantitativas_training[complete.cases(quantitativas_training) , ]


dataframe_of_independent_variables = quantitativas_training_sem_na[ , !(names(quantitativas_training_sem_na) %in% c('SalePrice')) ]
vector_of_dependent_variable  = quantitativas_training_sem_na[ , names(quantitativas_training_sem_na) == 'SalePrice']
number_of_trees = 500


set.seed(1231) #Não sei ainda porque (rever)
regressor = randomForest(x = dataframe_of_independent_variables,
                         y = vector_of_dependent_variable,
                         ntrees = number_of_trees,
                         na.action=na.omit)


quantitativas_test_sem_na <- quantitativas_test[complete.cases(quantitativas_test) , ]

predictor <- predict(regressor,quantitativas_test_sem_na,se.fit=TRUE)


