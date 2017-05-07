#' guesstimate

#' @title Calculate item level and aggregate learning
#' @param transmatrix  transition matrix returned from \code{\link{multi_transmat}}
#' @param nodk_priors Optional. Vector of length 4. Priors for the parameters for model that fits data without Don't Knows
#' @param dk_priors  Optional. Vector of length 8. Priors for the parameters for model that fits data with Don't Knows
#' @return list with two items: parameter estimates and estimates of learning
#' @export
#' @examples
#' # Without DK
#' pre_test <- data.frame(item1 = c(1, 0, 0, 1, 0), item2 = c(1, NA, 0, 1, 0)) 
#' pst_test <- pre_test + cbind(c(0, 1, 1, 0, 0), c(0, 1, 0, 0, 1))
#' transmatrix <- multi_transmat(pre_test, pst_test)
#' res <- lca_cor(transmatrix)

lca_cor <- function(transmatrix = NULL, nodk_priors = c(.3, .1, .1, .25),
                   dk_priors = c(.3, .1, .2, .05, .1, .1, .05, .25)) {

  # Initialize results mat
  nitems  <- nrow(transmatrix)
  nparams <- ifelse(ncol(transmatrix) == 4, 4, 8)
  est.opt <- matrix(ncol = nitems, nrow = nparams)

  # priors
  nodk_priors <- nodk_priors
  dk_priors   <- dk_priors

  # effects
  effects  <- matrix(ncol = nitems, nrow = 1)

  # calculating parameter estimates
  if (nparams == 4) {
    for (i in 1:nitems) {
      est.opt[, i]   <- tryCatch(solnp(nodk_priors,
                                       guess_lik,
                                       eqfun = eqn1,
                                       eqB = c(1),
                                       LB = rep(0, 4),
                                       UB = rep(1, 4),
                                       data = transmatrix[i, ])[[1]],
                                       error = function(e) NULL)
    }

    effects[, 1:nitems] <- est.opt[2, ]

  } else {
    for (i in 1:nitems) {
      est.opt[, i]   <- tryCatch(solnp(dk_priors,
                                       guessdk_lik,
                                       eqfun = eqn1dk,
                                       eqB = c(1),
                                       LB = rep(0, 8),
                                       UB = rep(1, 8),
                                       data = transmatrix[i, ])[[1]],
                                       error = function(e) rep(NA, 8))
    }

    effects[, 1:nitems]   <- est.opt[2, ] + est.opt[6, ]
  }

  # Assign row names
  if (nrow(est.opt) == 8) {

    row.names(est.opt)   <-
        c("lgg", "lgk", "lgc", "lkk", "lcg", "lck", "lcc", "gamma")
  } else {
    row.names(est.opt)   <- c("lgg", "lgk",  "lkk", "gamma")
  }

  list(param.lca = est.opt, est.learning = effects)
}
