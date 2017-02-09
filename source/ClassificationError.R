##
## Input: 
## table: cross table with correctly classified observations in each category 
##        in the matrix diagonal
##

ClassificationError <- function(table){
  correctClassified <- sum(diag(table))
  return(1- correctClassified/sum(table))
}