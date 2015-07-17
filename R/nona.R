#' No NAs
#'
#' Converts NAs to 0s
#' @param vec Required. Numeric vector. 
#' @return Numeric vector
#' @export
#' @examples
#' x <- c(NA, 1, 2); nona(x)

nona <- function(vec=NULL){
	vec[is.na(vec)] <- 0; 
	vec
}