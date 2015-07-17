#' multi_transmat: transition matrix of all the items
#'
#' Creates a transition matrix for each item.
#' Needs an 'interleaved' dataframe (see interleave function). Pre-test item should be followed by corresponding post-item item etc. 
#' Don't knows must be coded as NA. Function handles items without don't know responses.
#' The function is used internally. It calls transmat.
#' @param pre_test Required. data.frame carrying responses to pre-test questions.
#' @param pst_test Required. data.frame carrying responses to post-test questions.
#' @param subset a dummy vector identifying the subset. Default is NULL.
#' @return matrix with rows = total number of items + 1 (last row contains aggregate distribution across items)
#' number of columns = 4 when no don't know, and 9 when there is a don't know option
#' @export
#' @examples
#' pre_test <- data.frame(pre_item1=c(1,0,0,1,0), pre_item2=c(1,NA,0,1,0)); 
#' pst_test <- data.frame(pst_item1=pre_test[,1] + c(0,1,1,0,0), 
#'						  pst_item2 = pre_test[,2] + c(0,1,0,0,1))
#' multi_transmat(pre_test, pst_test)

multi_transmat <- function (pre_test = NULL, pst_test=NULL, subset=NULL) 
{

	if (!is.data.frame(pre_test)) stop("Specify pre_test data.frame.") # pre_test data frame is missing
	if (!is.data.frame(pst_test)) stop("Specify pst_test data.frame.") # post_test data frame is missing

	test <- data.frame(pre_test, pst_test); 
	pre  <- names(pre_test)
	pst  <- names(pst_test)
	item_df <- test[,interleave(pre, pst)]
	
	two_n_items <- ncol(item_df)	#2*n items

	n_params <- ifelse(sum(is.na(item_df))==0, 4, 9) # Do items have dk or not

	res <- matrix(ncol=n_params, nrow=(two_n_items/2 + 1))
		
	j <- 1	
	for (i in seq(1, two_n_items, 2))
	{
		res[j,] <- transmat(item_df[,i], item_df[,i+1], n_params, subset)
		j <- j + 1
	}
	res[j,] <- colSums(res, na.rm=T)
	return(invisible(res))
}
	