# CLSIEP15

## This package aims on Clinical and Laboratory Standards Institute (CLSI) EP15-A3 Calculations

CLSI EP15-A3 provides guidance on the user verification of precision and the estimation of bias for laboratory test methods. It outlines the steps and procedures that clinical laboratories should follow to evaluate the performance of a test method they intend to implement. 

This package is a R implementation of the calculations used in the document

## Install

`devtools::install_github('clauciorank/CLSIEP15')`

`library(CLSIEP15)`

## Usage

### Create a table in the specified format

#### Wider Format

| rep| Run_1| Run_2| Run_3| Run_4| Run_5|
|---:|-----:|-----:|-----:|-----:|-----:|
|   1|   140|   140|   140|   141|   139|
|   2|   139|   143|   138|   144|   140|
|   3|   138|   141|   136|   142|   141|
|   4|   138|   143|   141|   143|   138|
|   5|   140|   137|   136|   144|   141|

#### Long Format

| rep|name  | value|
|---:|:-----|-----:|
|   1|Run_1 |   140|
|   1|Run_2 |   140|
|   1|Run_3 |   140|
|   1|Run_4 |   141|
|   1|Run_5 |   139|
|   2|Run_1 |   139|
|   2|Run_2 |   143|
|   2|Run_3 |   138|
|   2|Run_4 |   144|
|   2|Run_5 |   140|
| ...|...   |   ...|


`ferritin_long` and `ferritin_wider` are provided as data in the package and can be used as example


#### For long format

`data <- create_table_ep_15(ferritin_long, data_type = 'long')`

#### For wide format

`data <- create_table_ep_15(ferritin_wider)`

# Precision

### Calculate Anova parameters and Imprecision Estimates

`aov_t <- calculate_aov_infos(data)`

If user repetibility(SR or CVR) < repetibility claim and Within-lab(SWL or CVWL) < Within-lab claim the 
user has verified manufacture's precision claims if not the upper verification limit (UVL) should be checked

`uvl_info <- calculate_uvl_info(aov_return = aov_t, cvr_or_sr = .43, cvwl_or_swl = .7)` 

Where arguments are the follow:

- aov_return:	Return of calculate_aov_info()

- nsamp: number of samples in the experiment. Default is 1

- cvr_or_sr: Desirable CV or S repetability

- cvwl_or_swl: Desirable CV or S within-lab


Rechek If user repetibility(SR or CVR) < UVL repetibility claim and Within-lab(SWL or CVWL) < UVL Within-lab claim

# Bias

For calculating a range for acceptable bias different scenarios and subscenarios are provided by the document

`calculate_bias_interval` is the function used:

`calculate_bias_interval(
  scenario,
  nrun,
  nrep,
  SWL,
  SR,
  nsamples,
  expected_mean,
  user_mean,
  ...
)`

These are the mandatory parameters:

- scenario: Choosed scenario from section 3.3 of EP15-A3

- nrun: Number of runs

- nrep: number of repetitions per run (n0)

- SWL: S within laboratory (obtained from anova)

- SR: S repetability (obtained from anova)

- nsamples: total number of samples tested usual 1

- expected_mean: Expected mean or TV

- user_mean: Mean of all samples (obtained from anova)

- ... : additional parameters necessary for processing the choosed scenario


## Scenario A:

Bona fide reference materials, can vary depending on the information provided by the manufacturer. 
- Sub scenario "u":
    -  manufacturer supplies a "standard error," "standard uncertainty" (u), or "combined standard uncertainty" (often denoted as uC ) for the TV
- Sub scenario "Uk":
    - manufacturer provides an "expanded uncertainty" (U) for the TV and a "coverage factor" (k)
- Sub scenario "Ucoverage":
    - manufacturer provides an "expanded uncertainty" (U) for the TV and a "coverage percentage"
- Sub scenario "lowerupper":
    - manufacturer provides an lower and upper limits and a "coverage percentage" (CI)

### Example

`calculate_bias_interval('A', subscenario = 'Uk', nrun = 7, nrep = 5, SWL = .042, SR = .032, nsamples = 2, exppected_mean = 1, user_mean = .94)`

Will return

`Error in calculate_se_rm(scenario, additional_args) :
For the choosed scenario U and k must be supplied`

So we need to pass the requested parameters:

`calculate_bias_interval('A', subscenario = 'Uk', nrun = 7, nrep = 5, SWL = .042, SR = .032, nsamples = 2, expected_mean = 1, user_mean = .94, U = 140, k = 1.96)`

## Scenario B and C

When a reference material's total uncertainty (TV) is determined based on Proficiency Testing (PT) (B) or  peer group results from an interlaboratory QC program (C)

Additional parameters necessary are sd_rm and nlab

### Example

`calculate_bias_interval('C',  nrun = 7, 
                        nrep = 5, 
                        SWL = .042, 
                        SR = .032, 
                        nsamples = 2, 
                        expected_mean = 1, 
                        user_mean = .94,
                        sd_rm = .05,
                        nlab = 43)`

## Scenario D and E

If the TV represents a conventional quantity value (D) or When working with a commercial QC material supplied
with a TV for which the standard error cannot be estimated (E)

`calculate_bias_interval('E', nrun = 7, nrep = 5, SWL = .042, SR = .032, nsamples = 2, expected_mean = 1, user_mean = .94)`

## Bias conclusion 

If the mean is inside `interval` object returned in `calculate_bias_interval()` the result is not significant and the observed bias is inside the manufacture claims





