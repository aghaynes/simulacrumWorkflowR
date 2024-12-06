
<!-- README.md is generated from README.Rmd. Please edit that file -->

simulacrumR is a package which have been developed to assist the users
of The Simulacrum dataset, to be better equipped for using the
Simulacrum to get access to the real patient data at the Cancer
Administration System (CAS).

The simulacrum data is a synthetic version of the real patient data at
CAS, which are made fully public and can be used to create and test a
analysis in R or STATA before getting it executed on the real data.
However, the setup to use Simulacrum demands a process of creating your
own locale Oracle database, import the data and create a ODBC connection
to the database. To ease the usage of Simulacrum, can the simulacrumR
package be usage for automatic setup of a database within R. Multiple
assistance function for preprocessing, query generatin, and query
testing.

## Installation

simulacrumR may be installed using the following command

``` r
devtools::install_github("CLINDA-AAU/simulacrumR") 
# Or including a vignette that demonstrates the bias and coverage of the estimators
devtools::install_github("CLINDA-AAU/simulacrumR", build = TRUE, build_opts = c("--no-resave-data", "--no-manual")) ???????
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

2)  Copy the direction to the location of Simulacrum at your locale
    machine

3)  Incert the dir string into the data loader function in the package

4)  Do the data management and analysis in R

5)  save the complete workflow with the workflow generator function

6)  Send the Workflow to NHS and wait for the results

## Explanation of the workflow

The workflow is built around the SQLdf package where the user are able
to setup a invisible database in the span of seconds and fully
automated. Before the database is intialised, the user is required to
download the latest version of the Simulacrum (v2.1.0) data:
<https://simulacrum.healthdatainsight.org.uk/using-the-simulacrum/requesting-data/>
. Please note, the latest version of Simulacrum have the same formats as
the real data at CAS. When the data is downloaded and saved, the
‘read_csv()’ function can automatically setup the csv files as
dataframes in R:

``` r
source("R/data_col2.R")
dir <- "C:/Users/p90j/Desktop/Jakob/Data/Simulacrum/simulacrum_v2.1.0/Data/"
# Automated data loading 
data_frames_lists <- read_csv(dir, selected_files = c("sim_av_patient", "sim_av_tumour")) 
#> Reading: sim_av_patient
#> Reading: sim_av_tumour
#> Files successfully loaded!
```

You can pick the dataframe you want by calling them from the data list:

``` r
sim_av_patient <- data_frames_lists$sim_av_patient
sim_av_tumour <- data_frames_lists$sim_av_tumour
```

When the dataframes are created. You can start write your queries. It is
recommended to keep the queries as simple as possible and do the data
management in R. As inspiration, use the function ‘table_query_list’
which will produce a list of function which prints queries for joining
tables. If a merge of the three av tables ‘sim_av_patient’,
‘sim_av_tumour’ and, ‘sim_av_gene, the function ’sql_full_av’ will
print:

``` r
query <- "SELECT *
FROM sim_av_patient
INNER JOIN sim_av_tumour ON sim_av_patient.patientid = sim_av_tumour.patientid;"
```

This query can be feed directly into the ‘sql_test()’ function which
creates the database based on the csv files and executes the queries:

``` r
source("R/sqldf.R")
#> Indlæser krævet pakke: gsubfn
#> Indlæser krævet pakke: proto
#> Indlæser krævet pakke: RSQLite
df1 <- sql_test(query)
```

As the NHS have their data stored on Oracle servers and due to the
queries used for Oracle and SQLite differs in some aspects, the
simulacrumR package offers a simple function ‘sqlite2oracle’ which
translate the queries to be compatible with the Oracle standard:

``` r
source("R/sqlite2oracle.R")
query2 <- "select *
from sim_av_patient
where age > 50
limit 500;"

sqlite2oracle(query2)
#> [1] "SELECT *\nFROM sim_av_patient\nWHERE age > 50\nAND ROWNUM <= 500;"
```

Note, the query translator are desgined for common and simple queries.

When the appropriate merges have been made and the user have the desired
dataset. There are a few preprocessing functions which can be used to
get started on the dataset:

- ‘cancer_grouping’()
- ‘group_ethnicity()’
- ‘extended_summary()’
- ‘survival_days()’

These can be used to easily get started with the data analysis.

When the data management, analysis and the table is ready for a full
workflow which can be send to NHS, the workflow generator function can
be used to make the complete workflow and output it as a R function,
which is ready to be send to the NHS:

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
#> Workflow script created at: workflow_20241206_1453.R
```

## References

1.  Simulacrum …

2.  …

3.  …
