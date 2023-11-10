utils::globalVariables(c("value"))

#' Create table for precision calculations
#' @importFrom dplyr filter
#' @importFrom tidyr pivot_longer
#' @importFrom utils data
#'
#' @param data a long or a wider data.frame with the same structure of CLSIEP15::ferritin_long or CLSIEP15::ferritin_wider
#' @param data_type c('wider', 'long')
#'
#' @return a data.frame with renamed columns and structure adjustments
#' @export
#'
#' @examples data <- create_table_ep_15(ferritin_long, data_type = "longer")
create_table_ep_15 <- function(data, data_type = 'wider'){

  if(data_type == 'wider'){
    colnames(data) <- c('rep', paste0('Run_', 1:(ncol(data)-1)))

    pivoted <-
      data |>
      pivot_longer(cols = -rep) |>
      dplyr::filter(!is.na(`value`))

    return(pivoted)
  }else if(data_type == 'long'){
    colnames(data) <- c('rep', 'name', 'value')

    return(data)
  }
}
