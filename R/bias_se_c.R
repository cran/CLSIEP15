#' Calculate SE combined based on SE X and SE RM
#'
#' @param se_x SE X
#' @param se_rm SE RM
#'
#' @return SE C
calculate_se_c <- function(se_x, se_rm){
  return(sqrt(se_x^2 + se_rm^2))
}
