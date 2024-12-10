
<!-- README.md is generated from README.Rmd. Please edit that file -->

simulacrumR is a package developed to assist users of the Simulacrum
dataset in better preparing to use the dataset as a precursor to
accessing real patient data in the Cancer Administration System (CAS).

The Simulacrum data is a synthetic version of the real patient data at
CAS. It is publicly available and can be used to create and test
analyses in R or STATA before executing them on the real data. However,
setting up Simulacrum requires creating a local Oracle database,
importing the data, and setting up an ODBC connection. To simplify this
process, the simulacrumR package automates the setup of a database
within R and provides various utility functions for preprocessing, query
generation, and query testing.

## Installation

simulacrumR may be installed using the following command:

``` r
devtools::install_github("CLINDA-AAU/simulacrumR") 

devtools::install_github("CLINDA-AAU/simulacrumR", build = TRUE, build_opts = c("--no-resave-data", "--no-manual"))
```

# Overview

The main functions of simulacrumR is:

- Integrated SQL Environment: Leverages the SQLdf package (ref) to make
  the user able to write queries within R.

- Query helper functions: Providing users with premade queries for
  joining tables, query constructor for assisting the user in building
  queries, SQLite to Oracle query transleter

- Time management: logging the time for completing the full workflow or
  to smaller parts of the script.

- Preprocessing: Multiple functions custom built to The Simulacrum
  dataset, which are considered as common operations when working with
  Cancer data and for the nature of the studies, like survival analysis.

# The process

The process of using this package for getting access to the data at CAS
through Simulacrum is as following:

1)  Download the latest version of Simulacrum at:
    <https://simulacrum.healthdatainsight.org.uk/using-the-simulacrum/requesting-data/>

2)  Copy the directory path of the Simulacrum files on your local
    machine

3)  Use the package’s data loader function to load the files into R

4)  Utilize R to handle data preprocessing and analysis

5)  save the complete workflow with the workflow generator function

6)  Send the Workflow to NHS and wait for the results

## Explanation of the workflow

The workflow is built around the SQLdf package where the user are able
to setup a invisible database in the span of seconds and fully
automated. Before the database is intialised, the user is required to
download the latest version of the Simulacrum (v2.1.0) data:
<https://simulacrum.healthdatainsight.org.uk/using-the-simulacrum/requesting-data/>
.

The latest Simulacrum data is formatted identically to the real CAS
data. Once downloaded, the read_csv() function can automatically load
the CSV files as data frames in R:

``` r
source("R/data_col2.R")
dir <- "C:/Users/p90j/Desktop/Jakob/Data/Simulacrum/simulacrum_v2.1.0/Data/"
# Automated data loading 
data_frames_lists <- read_csv(dir, selected_files = c("sim_av_patient", "sim_av_tumour")) 
#> Reading: sim_av_patient
#> Reading: sim_av_tumour
#> Files successfully loaded!
```

Access individual data frames as follows:

``` r
sim_av_patient <- data_frames_lists$sim_av_patient
sim_av_tumour <- data_frames_lists$sim_av_tumour
```

Once data frames are loaded, you can start writing queries. It’s
recommended to keep queries simple and handle data management in R. Use
the table_query_list function to access premade query templates. For
example, to merge tables:

``` r
query <- "SELECT *
FROM sim_av_patient
INNER JOIN sim_av_tumour ON sim_av_patient.patientid = sim_av_tumour.patientid;"
```

Execute queries with the sql_test() function:

``` r
source("R/sqldf.R")
df1 <- sql_test(query)
#> Indlæser krævet pakke: gsubfn
#> Indlæser krævet pakke: proto
#> Indlæser krævet pakke: RSQLite
```

## SQLite to Oracle Query Translation

To accommodate differences between SQLite and Oracle queries, use the
sqlite2oracle() function:

``` r
source("R/sqlite2oracle.R")
query2 <- "select *
from sim_av_patient
where age > 50
limit 500;"

sqlite2oracle(query2)
#> [1] "SELECT *\nFROM sim_av_patient\nWHERE age > 50\nAND ROWNUM <= 500;"
```

## Preprocessing Functions

simulacrumR includes functions to simplify data preprocessing:

- ‘cancer_grouping’()
- ‘group_ethnicity()’
- ‘extended_summary()’
- ‘survival_days()’

## Workflow Generation

When data management and analysis are complete, use the workflow
generator function to produce an R script ready for submission to the
NHS:

``` r
source("R/workflow_generator.R")
create_workflow(
                             libraries = "library(dplyr)",
                             query = "select * 
                             from sim_av_patient
                             where age > 50
                             limit 500;",
                             data_management = "
                             # Run query on SQLite database
                              cancer_grouping(sim_av_tumour)

                              # Additional preprocessing
                              #df2 <- survival_days(df1)
                              ",
                             analysis = "
                                                                  model = glm(x ~ x1 + x2 + x3, data=data)",
                             model_results = "html_table_model(model)")
#> Workflow script created at: workflow_20241210_0915.R
```

This workflow automates the process, ensuring easy integration and
preparation of your Simulacrum data.

## References

- Grothendieck G, (2017). Sqldf: Manipulate R Data Frames Using SQL.
  Link: ggrothendieck/sqldf: Perform SQL  
  Selects on R Data Frames

- Frayling L, Jose S. (2023) Simulacrum v2 User Guide. Health Data
  Insight. Link: Simulacrum-v2-User-Guide.pdf

- National Disease Registration Service (NDRS). (2022). Guide to using
  Simulacrum and Submitting code. Link: NDRS Branded Document

- Nielsen L, Skelmose J, Brøndum R, Bøgsted M. (2024). Simulacrum-study.
  Link: CLINDA-AAU/Simulacrum-study
