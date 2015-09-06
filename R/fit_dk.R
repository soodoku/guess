#' fit_dk
#'
#' Calculate fit statistics for data with dk
#' @param g 		estimates of \eqn{\gamma}
#' @param est.param estimated parameters
#' @param pre_test data.frame carrying pre_test items
#' @param pst_test data.frame carrying pst_test items
#' @return fit statistics
#' @export
#' @examples
#' \dontrun{fit_dk(pre_test, pst_test, )}

fit_dk <- function(pre_test, pst_test, g, est.param) 
{

	expec	<- matrix(ncol=nrow(data),nrow=9)
	fit		<- matrix(ncol=nrow(data),nrow=2)
			
	for(i in 1:nrow(data)){
		gi			<- g[[i]]
		expec[1, i]	<- (1 - gi)*(1-gi)*est.param[1,i]*sum(data[i,])
		expec[2, i]	<- ((1 - gi)*gi*est.param[1,i] + (1 - gi)*est.param[2,i])*sum(data[i,])
		expec[3, i]	<- ((1 - gi)*est.param[3,i])*sum(data[i,])
		expec[4, i]	<- ((1 - gi)*gi*est.param[1,i])*sum(data[i,])
		expec[5, i]	<- (gi*gi*est.param[1,i]+gi*est.param[2,i]+est.param[4,i])*sum(data[i,])
		expec[6, i]	<- (gi*est.param[3,i])*sum(data[i,])
		expec[7, i]	<- ((1 - gi)*est.param[5,i])*sum(data[i,])
		expec[8, i]	<- (gi*est.param[5,i] + est.param[6,i])*sum(data[i,])
		expec[9, i]	<- est.param[7,i]*sum(data[i,])
		test 		<- chisq.test(expec[,i], p=data[i,]/sum(data[i,]))
		fit[1:2,i]	<- round(unlist(test[c(1,3)]),3)
	}

	fit
}