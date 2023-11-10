## ---- include = FALSE---------------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>"
)

## ----eval=FALSE, include=FALSE------------------------------------------------
#  devtools::install_github('clauciorank/CLSIEP15')

## ----setup--------------------------------------------------------------------
library(CLSIEP15)

## ----echo=FALSE---------------------------------------------------------------
knitr::kable(ferritin_wider)

## ----echo=FALSE---------------------------------------------------------------
knitr::kable(head(ferritin_long, 12))

## -----------------------------------------------------------------------------
data <- create_table_ep_15(ferritin_long, data_type = 'long')

## -----------------------------------------------------------------------------
data <- create_table_ep_15(ferritin_wider)

## -----------------------------------------------------------------------------
aov_t <- calculate_aov_infos(data)
aov_t

## -----------------------------------------------------------------------------
uvl_info <- calculate_uvl_info(aov_return = aov_t, cvr_or_sr = .43, cvwl_or_swl = .7)
uvl_info

## ----eval=FALSE---------------------------------------------------------------
#  calculate_bias_interval(
#    scenario,
#    nrun,
#    nrep,
#    SWL,
#    SR,
#    nsamples,
#    expected_mean,
#    user_mean,
#    ...
#  )

## ----eval=FALSE---------------------------------------------------------------
#  calculate_bias_interval('A',
#                          subscenario = 'Uk',
#                          nrun = 7,
#                          nrep = 5,
#                          SWL = .042,
#                          SR = .032,
#                          nsamples = 2,
#                          exppected_mean = 1,
#                          user_mean = .94
#                          )

## -----------------------------------------------------------------------------
calculate_bias_interval('A', 
                        subscenario = 'Uk', 
                        nrun = 7, 
                        nrep = 5, 
                        SWL = .042, 
                        SR = .032, 
                        nsamples = 2, 
                        expected_mean = 1, 
                        user_mean = .94, 
                        U = 140, 
                        k = 1.96
                        )

## -----------------------------------------------------------------------------
calculate_bias_interval('C',  nrun = 7, 
                        nrep = 5, 
                        SWL = .042, 
                        SR = .032, 
                        nsamples = 2, 
                        expected_mean = 1, 
                        user_mean = .94,
                        sd_rm = .05,
                        nlab = 43)

## -----------------------------------------------------------------------------
calculate_bias_interval('E', 
                        nrun = 7, 
                        nrep = 5, 
                        SWL = .042, 
                        SR = .032, 
                        nsamples = 2, 
                        expected_mean = 1, 
                        user_mean = .94
                        )

