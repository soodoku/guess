#' Person Level Standard Guessing Correction Adjustment
#' 
#' @description Adjusts observed 1s based on the standard guessing correction. 
#' If NAs are observed in the data, they are treating as acknowledgments of ignorance.
#' @param pre  pre data frame
#' @param pst  pst data frame
#' @param lucky change of getting the right answer by chance
#' @param dk    Numeric. Between 0 and 1. Hidden knowledge behind don't know responses. Default is .03.
#' @return list of pre and post adjusted responses
#' @export
#' @examples
#' pre_test_var <- data.frame(pre=c(1,0,0,1,"d","d",0,1,NA))
#' pst_test_var <- data.frame(pst=c(1,NA,1,"d",1,0,1,1,"d"))
#' lucky <- c(.25)
#' stnd_adj(pre_test_var, pst_test_var, lucky)

stnd_adj <- function(pre=NULL, pst=NULL, lucky=NULL, dk=.03)
{

  n <- nrow(pre)

  if ( sum(is.na(pre)) > 0 | sum(is.na(pst)) > 0 ) {
    cat("NAs will be converted to 0. MCAR is assumed.\n")
    pre <- as.data.frame(lapply(pre, function(x) nona(x)))
    pst <- as.data.frame(lapply(pst, function(x) nona(x)))
  }

  t1adj <- as.data.frame(mapply(function(x, y) ifelse(x==1, y, x), pre, 1 - lucky))
  t2adj <- as.data.frame(mapply(function(x, y) ifelse(x==1, y, x), pst, 1 - lucky))

  t1adj <-  sapply(t1adj, function(x) x[x=='d'] <- dk)
  t2adj <-  sapply(t2adj, function(x) x[x=='d'] <- dk)

  return(list(pre=t1adj, pst=t2adj)) 
}

