charComma2dot <- function(data){
  data <- gsub(pattern="\\.", replacement="", x=data);
  data <- gsub(pattern=",", replacement="\\.", x=data);
  
  return(data);
}