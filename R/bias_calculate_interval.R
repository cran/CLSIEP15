#' Calculate bias validation interval
#'
#' @param TV True value
#' @param m factor
#' @param se_c SE Combined
#'
#' @return named list with the interval
bias_validation_interval <-  function(TV, m, se_c){
  return(list(lower_limit = TV - m*se_c, higher_limit = TV + m*se_c))
}

#' Calculate bias interval from TV
#'
#' @param scenario Choosed scenario from section 3.3 of EP15-A3
#' @param nrun Number of runs
#' @param nrep number of repetitions per run (n0)
#' @param SWL S within laboratory (obtained from anova)
#' @param SR S repetability (obtained from anova)
#' @param nsamples total number of samples tested usual 1
#' @param expected_mean Expected mean or TV
#' @param user_mean Mean of all samples (obtained from anova)
#' @param ... additional parameters necessary for processing the choosed scenario
#'
#' @return a named list with the defined mean, the interval significance (user mean should be in for approval), and total bias (user mean - TV)
#' @export
#'
#' @examples calculate_bias_interval(scenario = 'E',
#'nrun = 7,
#'nrep = 5,
#'SWL = .042,
#'SR = .032,
#'nsamples = 2,
#'expected_mean = 1,
#'user_mean = .94
#')
calculate_bias_interval <- function(scenario, nrun, nrep, SWL, SR, nsamples, expected_mean, user_mean, ...){
  if (!missing(...)) {
    additional_args <- list(...)
  }else{
    additional_args <- list()
  }

  nlab<-NA
  for(i in names(additional_args)){
    assign(i, additional_args[[i]])
  }

  se_x <- calculate_se_x(nrun, nrep, SWL, SR)

  se_rm <- calculate_se_rm(scenario, additional_args)

  se_c <- calculate_se_c(se_x, se_rm)

  df_x <- nrun-1

  df_c <- calculate_df_combined(scenario, se_x=se_x, se_rm=se_rm, se_c=se_c, df_x=df_x, nlab=nlab, nrun=nrun)

  m <- calculate_m(df_c, nsamples = nsamples)

  interval <- bias_validation_interval(expected_mean, m, se_c)
  is_significant <- ifelse(user_mean < interval$lower_limit | user_mean > interval$higher_limit, TRUE, FALSE)
  bias = user_mean - expected_mean

  return(
    list(mean = user_mean, TV = expected_mean, interval = interval, signif = is_significant, bias = bias)
  )
}
