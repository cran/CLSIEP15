#' Calculate SE RM for scenario A when “standard error” or “standard uncertainty” (abbreviated by lowercase “u”) or “combined standard uncertainty” (often denoted by “uC ”)
#'
#' @param u “standard error” or “standard uncertainty” (abbreviated by lowercase “u”) or “combined standard uncertainty” (often denoted by “uC ”)
#'
#' @return SE RM
calculate_se_rm_a_u <- function(u){
  return(u)
}

#' Calculate SE RM for scenario A when f the manufacturer supplies an “expanded uncertainty” (abbreviated by uppercase “U”) for the TV and the “coverage factor” (abbreviated by “k”)
#'
#' @param U expanded uncertainty
#' @param k coverage factor
#'
#' @return SE RM
calculate_se_rm_a_Uk <- function(U, k){
  return(U/k)
}

#'  Calculate SE RM for scenario A when f the manufacturer supplies an “expanded uncertainty” (abbreviated by uppercase “U”) for the TV and coverage e.g. 95 or 99,
#' @importFrom stats qnorm
#'
#' @param U expanded uncertainty
#' @param coverage coverage
#'
#' @return SE RM
calculate_se_rm_a_Ucoverage <- function(U, coverage){
  p_dist <- (100 - (100-coverage)/2)/100
  q_dist <- round(qnorm(p_dist), 2)

  return(U/q_dist)
}

#' Calculate SE RM for scenario A when f the manufacturer supplies lower and upper limits and coverage confidence interval (95 or 99...)
#' @importFrom stats qnorm
#'
#' @param upper upper limit
#' @param lower lower limit
#' @param coverage coverage
#'
#' @return SE RM
calculate_se_rm_a_lowerupper <- function(upper, lower, coverage){
  p_dist <- (100 - (100-coverage)/2)/100
  q_dist <- round(qnorm(p_dist), 2)

  return((upper-lower)/(2*q_dist))
}

#' Calculate SE RM for scenario B or C If the reference material has a TV determined by PT or peer group results
#'
#' @param sd_rm SD RM
#' @param nlab number of lab or peer group results
#'
#' @return SE RM
calculate_se_rm_scenario_b_c <- function(sd_rm, nlab){
  returnValue(sd_rm/sqrt(nlab))
}

#' Calculate SE RM for scenario D or E If the TV represents a conventional quantity value or When working with a commercial QC material supplied with a TV for which the standard error cannot be estimated
#'
#' @return SE RM
calculate_se_rm_scenario_d_e <- function(){
  return(0)
}


#' Calculate SE RM given a scenario and a list of additional args that can change based on the selected scenario or sub scenario
#'
#' @param scenario scenario (A, B, C, D, E)
#' @param additional_args additional arguments list
#'
#' @return SE RM
calculate_se_rm <- function(scenario, additional_args){

  if(scenario == 'A'){
    if(is.null(additional_args[['subscenario']]) || !additional_args[['subscenario']] %in% c('u', 'Uk', 'Ucoverage', 'lowerupper')){
      stop("One of the following subscenarios should be supplied:
           'u', 'Uk', 'Ucoverage', 'lowerupper'")
    }
    if(additional_args[['subscenario']] == 'u'){
      if(is.null(additional_args[['u']])){
        stop('For the choosed scenario u must be supplied')
      }

      return(calculate_se_rm_a_u(additional_args[['u']]))
    }else if(additional_args[['subscenario']] == 'Uk'){
      if(
        is.null(additional_args[['U']]) |
        is.null(additional_args[['k']])
      ){
        stop('For the choosed scenario U and k must be supplied')
      }
      return(calculate_se_rm_a_Uk(additional_args[['U']], additional_args[['k']]))
    }else if(additional_args[['subscenario']] == 'Ucoverage'){
      if(
        is.null(additional_args[['U']]) |
        is.null(additional_args[['coverage']])
      ){
        stop('For the choosed scenario U and coverage must be supplied')
      }

      return(calculate_se_rm_a_Ucoverage(additional_args[['U']], additional_args[['coverage']]))
    }else if(additional_args[['subscenario']] == 'lowerupper'){
      if(
        is.null(additional_args[['lower']]) |
        is.null(additional_args[['upper']]) |
        is.null(additional_args[['coverage']])
      ){
        stop('For the choosed scenario lower, upper and coverage must be supplied')
      }

      return(calculate_se_rm_a_lowerupper(additional_args[['lower']], additional_args[['upper']], additional_args[['coverage']]))
    }
  }else if(scenario %in% c('B', 'C')){
    if(
      is.null(additional_args[['sd_rm']]) |
      is.null(additional_args[['nlab']])
    ){
      stop('For the choosed scenario sd_rm and nlab must be supplied')
    }

    return(calculate_se_rm_scenario_b_c(additional_args[['sd_rm']], additional_args[['nlab']]))
  }else if(scenario %in% c('D', 'E')){
    return(calculate_se_rm_scenario_d_e())
  }else{
    stop("Scenario must be one of the following: 'A', 'B', 'C', 'D' or 'E'")
  }
}
