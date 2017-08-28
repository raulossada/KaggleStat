#Testes de modelos

#Random Forest
install.packages('randomForest')
library(randomForest)
set.seed(1231) #Não sei ainda porque (rever)
regressor = randomForest(x = dataframe_of_independent_variables,
                         y = vector_of_dependent_variable,
                         ntrees = number_of_trees)