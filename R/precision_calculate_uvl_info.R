#' Calculate degres of freedom within-lab as specified in appendix B
#'
#' @param cvr_manufacture CV repeatability informed by the manufacturer
#' @param cvwl_manufacture CV within-lab informed by the manufacturer
#' @param k the number of runs
#' @param n0 the “average” number of results per run
#' @param N the total number of replicates
#'
#' @return dfwl
calculate_dfWL <- function(cvr_manufacture, cvwl_manufacture, k, n0, N){

  p <- cvwl_manufacture/cvr_manufacture

  cv_wl_a <- p

  vw <- (1/100)^2
  vwl <- (cv_wl_a/100)^2

  vb <- vwl - vw

  MS1 = vw + n0 * vb
  MS2 = vw

  DF1 = k-1
  DF2 = N-k

  a1 = 1/n0
  a2 = (n0-1)/n0
  num = (a1*MS1 + a2*MS2)^2

  den1 = ((a1*MS1)^2)/DF1
  den2 = ((a2*MS2)^2)/DF2

  return(round(num/(den1 + den2)))
}

#' Calculate the UVL factor
#'
#' @importFrom stats qchisq
#'
#' @param nsamp n samples in the study
#' @param df degres of freedom
#' @param alpha confidence level
#'
#' @return Uvl factor
#'
calculate_F_uvl <- function(nsamp = 1, df, alpha = 0.05){
  X2 <- qchisq(1-alpha/nsamp, df)
  F_uvl <- sqrt(X2/df)

  return(F_uvl)
}

#' Calculate upper verification limit
#'
#' Generic function for calculating UVL the return is a named list and cv_uvl_r and cv_uvl_wl depends on what is the input (S or CV) if the input is SR and SWL the returns is S
#'
#' @param aov_return Return of calculate_aov_info()
#' @param nsamp number of samples in the experiment
#' @param cvr_or_sr Desirable CV or S repetability
#' @param cvwl_or_swl Desirable CV or S within-lab
#'
#' @return Named list with UVL params
#' @export
#'
#' @examples  data <- create_table_ep_15(ferritin_wider)
#'  aov_t <- calculate_aov_infos(data)
#'  calculate_uvl_info(aov_t, nsamp = 5, cvr_or_sr = .43, cvwl_or_swl = .7)
calculate_uvl_info <- function(aov_return, nsamp = 1, cvr_or_sr, cvwl_or_swl){

  N <- aov_return$N
  k <- aov_return$k
  n0 <-aov_return$n0

  dfR <- N - k
  dfWL <- calculate_dfWL(cvr_manufacture = cvr_or_sr, cvwl_manufacture = cvwl_or_swl, k = k, n0 = n0, N = N)

  f_r <- calculate_F_uvl(df = dfR, nsamp)
  f_wl <- calculate_F_uvl(df = dfWL, nsamp)

  cv_uvl_r <- f_r*cvr_or_sr
  cv_uvl_wl <- f_wl*cvwl_or_swl


  return_object <- list()
  return_object[['dfR']] = dfR
  return_object[['dfWL']] = dfWL
  return_object[['f_r']] = f_r
  return_object[['f_wl']] = f_wl
  return_object[['cv_uvl_r']] = cv_uvl_r
  return_object[['cv_uvl_wl']] = cv_uvl_wl


  return(return_object)
}
