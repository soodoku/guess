#' Standard Guessing Correction for Learning
#'
#' Estimate of learning adjusted with standard correction for guessing. Correction is based on number of options per question.
#' Requirements: separate pre-test and post-test dataframes. Why do we need dataframes? To accomodate multiple items.
#' The items can carry NA (missing). Items must be in the same order in each dataframe. For now we assume that respondents are posed same questions twice. 
#' The function also takes a lucky vector - chance of getting a correct answer if guessing randomly. Each entry is 1/(no. of options).
#' By default, the vector of corrected scores that is returned has same item names as the pre_test items.  
#' However you can assign a vector of names separately via item_names.
#' @param pre_test data.frame carrying responses to pre-test questions.
#' @param pst_test data.frame carrying responses to post-test questions.
#' @param lucky 
#' @return a numeric vector containing adjusted estimates of learning for each item
#' @export
#' @examples
#' pre_test <- data.frame(item1=c(1,0,0,1,0), item2=c(1,NA,0,1,0)); pst_test <-  pre_test + cbind(c(0,1,1,0,0), c(0,1,0,0,1))
#' lucky <- rep(.25, 2); stndcor(pre_test, pst_test, lucky)
 
stndcor <- function(pre_test=NULL, pst_test=NULL, lucky=NULL, item_names=NULL)
{	
	if (is.null(pre_test)) stop("Specify pre_test data.frame.") # pre_test data frame is missing
	if (is.null(pst_test)) stop("Specify pst_test data.frame.") # post_test data frame is missing
	if (is.null(lucky)) stop("Specify lucky vector.")           # lucky vector is missing
	
	if(length(unique(length(pre_test), length(pst_test), length(lucky)))!=1) stop("Length of input varies. Length of pre_test, pst_test, and lucky must be the same.")

	n_items <- length(pre_test)
	pre_test_cor  <- pst_test_cor <- stnd_cor <- rep(NA, length=n_items)
	
	# Names of the return vector
	if (is.null(item_names)) {
		names(stnd_cor) <- names(pre_test)
	} else {
		names(stnd_cor) <- item_names
	}

	for (i in 1:n_items)
	{
		pre_test_cor[i] <- sum(pre_test[,i], na.rm = TRUE) - length(which(pre_test[,i] == 0))/(1/lucky[i] - 1)
		pst_test_cor[i] <- sum(pst_test[,i], na.rm = TRUE) - length(which(pst_test[,i] == 0))/(1/lucky[i] - 1)
		stnd_cor[i]     <- pst_test_cor[i] - pre_test_cor[i]
	}

	stnd_cor/nrow(pre_test)
}