% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/fit_dk.R
\name{fit_dk}
\alias{fit_dk}
\title{Goodness of fit statistics for data with don't know}
\usage{
fit_dk(pre_test, pst_test, g, est.param, force9 = FALSE)
}
\arguments{
\item{pre_test}{data.frame carrying pre_test items}

\item{pst_test}{data.frame carrying pst_test items}

\item{g}{estimates of \eqn{\gamma} produced from \code{\link{lca_cor}}}

\item{est.param}{estimated parameters produced from \code{\link{lca_cor}}}

\item{force9}{Optional. There are cases where DK data doesn't have DK. But we need the entire matrix. By default it is FALSE.}
}
\value{
matrix with two rows: top row carrying chi-square value, and bottom row probability of observing that value
}
\description{
For data with Don't Know, chi-square goodness of fit between true and model based multivariate distribution
}
\details{
fit_nodk
}
\examples{
\dontrun{fit_dk(pre_test, pst_test, g, est.param)}
}
