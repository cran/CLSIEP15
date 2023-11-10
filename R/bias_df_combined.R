utils::globalVariables(c("dfc_references", "labs", "runs"))

#' Calculate degrees of freedom of SE C (SE combined) given a selected scenario and additional parameters necessary for the scenario
#' @importFrom dplyr filter
#'
#' @param scenario Scenario (A, B, C, D, E)
#' @param ... additional parameters necessary for the scenario
#'
#' @return DF
calculate_df_combined <- function(scenario, ...){
  if (!missing(...)) {
    additional_args <- list(...)
  }else{
    additional_args <- list()
  }

  if(scenario == 'E'){
    if(is.null(additional_args[['df_x']])){
      stop("Can't calc df_combined for scenario E: df_x is necessary")
    }
    return(additional_args[['df_x']])
  }else if(scenario %in% c('A', 'D')){
    if(
      is.null(additional_args[['df_x']]) |
      is.null(additional_args[['se_c']]) |
      is.null(additional_args[['se_x']])
    ){
      stop("Can't calc df_combined for scenario: df_x, se_c, se_x are necessary")
    }
    df_x <- additional_args[['df_x']]
    se_c <- additional_args[['se_c']]
    se_x <- additional_args[['se_x']]

    return(df_x*((se_c/se_x)^4))
  }else if(scenario %in% c('B', 'C')){
    if(
      is.null(additional_args[['se_rm']]) |
      is.null(additional_args[['se_x']]) |
      is.null(additional_args[['nlab']]) |
      is.null(additional_args[['nrun']])
    ){
      stop("Can't calc df_combined for scenario: se_rm, se_x, nrun, nlab are necessary")
    }

    references <- dfc_references

    tau = additional_args[['se_rm']]/additional_args[['se_x']]
    nlab <- additional_args[['nlab']]
    nrun <- additional_args[['nrun']]

    tau <- ifelse(tau == Inf, NA, tau)

    lab_aprox <- unique(references$labs)[which.min(abs(unique(references$labs)-nlab))]

    filtered_reference <-
      references |>
      dplyr::filter(lab_aprox == `labs` & nrun == `runs`)

    return(unique(filtered_reference$df)[which.min(abs(unique(filtered_reference$tau)-tau))]  )
  }else{
    stop('Allowed scenarios must be A, B, C, D or E')
  }
}
