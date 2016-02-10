#' Person Level Adjustment
#' 
#' @title Adjusts observed 1s based on item level parameters of the LCA model. Currently only takes data with Don't Know.
#' @param t1  t1 data frame
#' @param t2  t2 data frame
#' @return adjusted responses
#' @export
#' @examples
#' pre_test <- data.frame(item1=c(1,0,0,1,0), item2=c(1,NA,0,1,0)) 
#' pst_test <- pre_test + cbind(c(0,1,1,0,0), c(0,1,0,0,1))
#' \dontrun{p_guess(pre_test, pst_test)}

p_guess <- function(t1, t2)
{

  n <- nrow(t1)

  transmatrix <- multi_transmat(t1, t2)
  
  lca_res     <- guesstimate(transmatrix)
  param_lca   <- lca_res$param.lca
  param_lca   <- param_lca[,1:(ncol(param_lca)-1)]

  pk1 <-  n*param_lca["lkk",]/sapply(t1, function(x) sum(x==1))
  pk2 <-  n*(param_lca["lgk",] + param_lca["lkk",] + param_lca["lck",])/sapply(t2, function(x) sum(x==1))

  t1adj <- mapply(function(x, y) ifelse(x==1, y, x), t1, pk1)
  t2adj <- mapply(function(x, y) ifelse(x==1, y, x), t2, pk2)

  t1adj <-  sapply(as.data.frame(t1adj), function(x) {x <- as.character(x); as.numeric(ifelse(x=='d', 0, x))})
  t2adj <-  sapply(as.data.frame(t2adj), function(x) {x <- as.character(x); as.numeric(ifelse(x=='d', 0, x))})

  return(list(t1adj, t2adj)) 
}

