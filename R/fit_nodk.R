#' fit_nodk
#'
#' fit for data without dk
#' @param g 
#' @param est.param estimated parameters
#' @param data 
#' @return interleaved vector
#' @export
#' @examples
#' \dontrun{fit_nodk()}

fit_nodk <- function(g, est.param, data) {

	expec	<- matrix(ncol=nrow(data), nrow=4)
	fit		<- matrix(ncol=nrow(data), nrow=2)
			
	for (i in 1:nrow(data)) {
		
		gi			<- g[[i]]
		expec[1, i]	<- (1 - gi)*(1 - gi)*est.param[1,i]*sum(data[i,])
		expec[2, i]	<- ((1 - gi)*gi*est.param[1, i] + (1 - gi)*est.param[2, i])*sum(data[i, ])
		expec[3, i]	<- ((1 - gi)*est.param[3, i]*est.param[1, i])*sum(data[i, ])
		expec[4, i]	<- (gi*gi*est.param[1, i] + gi*est.param[2, i] + est.param[3, i])*sum(data[i, ])
		test 		<- suppressWarnings(chisq.test(expec[, i], p=data[i,]/sum(data[i, ])))
		fit[1:2, i]	<- unlist(test[c(1, 3)])
	}

	fit
}