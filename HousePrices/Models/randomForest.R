#Testes de modelos
#Dê um setwd na pasta HousePrices, onde quer que ela esteja em sua máquina

training_data <- read.csv(file="Data/train.csv", as.is=FALSE);
remover_colunas <- c("Id"); 
training_data <- training_data[ , !(names(training_data) %in% remover_colunas ) ];

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

dataframe_of_independent_variables = training_data[ , !(names(training_data) %in% c('SalePrice')) ]
vector_of_dependent_variable  = training_data[ , names(training_data) == 'SalePrice']
number_of_trees = 500

set.seed(1231) #Não sei ainda porque (rever)
regressor = randomForest(x = dataframe_of_independent_variables,
                         y = vector_of_dependent_variable,
                         ntrees = number_of_trees)


