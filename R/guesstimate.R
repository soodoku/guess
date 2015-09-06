# Likelihood functions 
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

# Data w/ No DK
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
		
# Data with DK
guessdk <- function(x, g1=x[8], data) 
{
	lgg <- x[1]
	lgk <- x[2] 
	lgc <- x[3]
	lkk <- x[4]
	lcg <- x[5]
	lck <- x[6]
	lcc <- x[7]
			
	vec <- NA
	vec[1] <- (1 - g1)*(1 - g1)*lgg
	vec[2] <- (1 - g1)*g1*lgg + (1 - g1)*lgk
	vec[3] <- (1 - g1)*lgc
	vec[4] <- (1 - g1)*g1*lgg
	vec[5] <- g1*g1*lgg+g1*lgk+lkk
	vec[6] <- g1*lgc
	vec[7] <- (1 - g1)*lcg
	vec[8] <- g1*lcg + lck
	vec[9] <- lcc
	
	-sum(data*log(vec))
}

# Functions for constraining lambdas to sum to 1 and to bound params between 0 and 1
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

eqn1 = function(x, g1=NA, data) {
	sum(x[1:3])
}

eqn1dk = function(x, g1=NA, data) {
	sum(x[1:7])
}

# Estimation
# ~~~~~~~~~~~~~~~~
#' guesstimate
#' Calculate item level and aggregate estimates
#' @param pre_test data.frame carrying pre_test items
#' @param pst_test data.frame carrying pst_test items
#' @param subgroup a dummy vector identifying the subset
#' @return estimates
#' @export

guesstimate <- function(pre_test = NULL, pst_test=NULL, subgroup=NULL) {
	
	# get transition matrix
	df 			<- multi_transmat(pre_test, pst_test, subgroup)
	
	# Initialize results mat
	nitems	<- nrow(df)
	nparams <- ifelse(ncol(df)==4, 4, 8)
	est.opt <- matrix(ncol=nitems, nrow=nparams)
	
	# calculating parameter estimates
	if (nparams == 4) {
		for (i in 1:nitems) {
			est.opt[,i]	 <- tryCatch(solnp(c(.3,.1,.1,.25), guess_lik, eqfun = eqn1, eqB = c(1), LB = rep(0,4), UB = rep(1,4), data=df[i,])[[1]], error=function(e) NULL)
		}
	} else {
		for (i in 1:nitems) {
			est.opt[,i]	 <- tryCatch(solnp(c(.3,.1,.2,.05,.1,.1,.05,.25), guessdk, eqfun = eqn1dk, eqB = c(1), LB = rep(0,8), UB = rep(1,8), data=df[i,])[[1]], error=function(e) rep(NA,8))
		}
	}

	# Assign row names
	if (nrow(est.opt) == 8){
			row.names(est.opt) 	<- c("lgg", "lgk", "lgc", "lkk", "lcg", "lck", "lcc", "gamma")
	} else {
		row.names(est.opt) 		<- c("lgg", "lgk",  "lkk", "gamma")
	}

	return(invisible(est.opt))
}