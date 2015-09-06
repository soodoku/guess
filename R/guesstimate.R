#' guesstimate
#'
#' function to calculate item level and aggregate estimates
#' @param x
#' @param lucky
#' @return interleaved vector
#' @export
#' @examples
#' guesstimate

# Likelihood func
# ~~~~~~~~~~~~~~~~~~~~~~

guess_lik <- function(x, g1=x[4], data) 
{
	lgg <- x[1]
 	lgk <- x[2]
 	lkk <- x[3]
			
	vec <- NA
 	vec[1] <- (1-g1)*(1-g1)*lgg
 	vec[2] <- (1-g1)*g1*lgg + (1-g1)*lgk
 	vec[3] <- (1-g1)*g1*lgg
 	vec[4] <- g1*g1*lgg+g1*lgk+lkk
 	
 	-sum(data*log(vec))	
}

# Functions for constraining lambdas to sum to 1 and to bound params between 0 and 1
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

eqn1 = function(x, g1=NA, data) {
	sum(x[1:3])
}

# Estimation
# ~~~~~~~~~~~~~~~~
guesstimate <- function(pre_test = NULL, pst_test=NULL, subgroup=NULL, lucky = NULL) {
	
	# get transition matrix
	df 			<- multi_transmat(pre_test, pst_test)
	
	# Initialize results mat
	nitems	<- nrow(df)
	nparams <- ifelse(ncol(df)==4, 4, 8)
	est.opt <- matrix(ncol=nitems, nrow=nparams)
	row.names(est.opt) 		<- c("lgg", "lgk",  "lkk", "gamma")
	
	# calculating parameter estimates
	for (i in 1:nitems) {
		est.opt[,i]	 <- tryCatch(Rsolnp::solnp(c(.3,.1,.1,.25), guess_lik, eqfun = eqn1, eqB = c(1), LB = rep(0,4), UB = rep(1,4), data=df[i,])[[1]], error=function(e) NULL)
	}

	est.opt
}


