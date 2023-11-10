#' Ferrtin data used in CLSI document examples in wide format
#'
#'
#' @format `ferritin_wider`
#' A data frame with 5 rows and 6 columns:
#' \describe{
#'   \item{rep}{Repetition of sample}
#'   \item{Run_1, Run_2, Run_3, Run_4, Run_5}{Runs from 5 distinct days}
#'   ...
#' }
#' @source CLSI EP15-A3
"ferritin_wider"

#' Ferrtin data used in CLSI document examples in wide format
#'
#'
#' @format `ferritin_long`
#' A data frame with 25 rows and 3 columns:
#' \describe{
#'   \item{rep}{Repetition of sample}
#'   \item{name}{Run of the Runs obtained from 5 distinct days}
#'   \item{value}{result of the observation}
#'   ...
#' }
#' @source CLSI EP15-A3
"ferritin_long"

#' Reference of degrees of freedon based on tau given in the CLSI Manual
#'
#'
#' @format `dfc_references`
#' A data frame with 390 rows and 4 columns:
#' \describe{
#'   \item{tau}{tau}
#'   \item{df}{degrees of freedon}
#'   \item{labs}{number of labs or peers}
#'   \item{runs}{number of runs}
#'   ...
#' }
#' @source CLSI EP15-A3
"dfc_references"
