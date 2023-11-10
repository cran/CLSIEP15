#' Calculate M
#' @importFrom stats qt
#'
#' @param df degrees of freedom
#' @param conf.level confidence interval
#' @param nsamples number of samples
#'
#' @return m factor
calculate_m <- function(df, conf.level=95, nsamples = 1){
  a = 1-(((100-conf.level)/100)/(2*nsamples))

  return(round(qt(a, df), 2))
}
