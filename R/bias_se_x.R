#' Calculate SE x
#'
#' @param nrun Run number
#' @param nrep Number of repetitions per run n0
#' @param SWL SWL from aov table
#' @param SR SR from aov table
#'
#' @return SE X
calculate_se_x <- function(nrun, nrep, SWL, SR){
  f <- 1/nrun
  s <- SWL^2 - ((nrep-1)/nrep) * (SR^2)

  se_mean <- sqrt(f*s)
  return(round(se_mean, 2))
}
