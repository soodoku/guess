#' transmat: Across wave transition matrix
#'
#' Cross-wave table of transitions. Converts the table to a vector with a specific order. Used internally. 
#' Missing values are treated as ignorance. Don't know responses need to be coded as NA.
#' @param pre_test_var 
#' @param pst_test_var 
#' @param n_params  
#' @param subset  
#' @return a numeric vector. Assume 1 denotes correct answer, 0 incorrect, and d ignorance.
#' When there is no don't know option and no missing, the entries are: x00, x10, x01, x11
#' When there is a don't know option or missing, the entries of the vector are: x00, x10, xd0, x01, x11, xd1, xd0, x1d, xdd
#' @export
#' @examples
#' pre_test_var <- c(1,0,0,1,0,1,0); pst_test_var <- c(1,0,1,1,0,1,1); transmat(pre_test_var, pst_test_var, 4)

transmat <- function(pre_test_var, pst_test_var, n_params, subset=NULL) 
{	
	if (!is.null(subset))
	{
		pre_test_var <-pre_test_var[subset]
		pst_test_var <-pst_test_var[subset]
	}
	
	# If no missing in pre_test_var, just call table. Else call table with exclude=NULL
	# Rearrange:  x00 <- x[1]; x10 <- x[2]; x01 <- x[3]; x11 <- x[4]
	# x00 <- x[1]; x10 <- x[2]; xd0 <- x[3]; x01 <- x[4]; x11 <- x[5]; xd1 <- x[6]; x0d <- x[7]; x1d <- x[8]; xdd <- x[9]
	# res <- as.vector(table(pre_test_var, pst_test_var, exclude=NULL))[c(1,4,7,2,5,8,3,6,9)]
			
	if (n_params ==4) 
	{ 
		if (sum(is.na(pre_test_var) > 0)) stop("These data should not have any missing values. Missing values on knowledge questions can be treated as ignorance.")

		printres <- t(table(pre_test_var, pst_test_var))
		res <- c(printres)

		# Print
		prmatrix(printres)

	} 

	else {

		printres <- t(table(pre_test_var, pst_test_var, exclude=NULL))
		res <- c(printres)

		# Print
		prmatrix(printres)
	}

  return(invisible(res))

}