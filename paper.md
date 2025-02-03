---
title: 'simulacrumR: An R package for Streamlined Access and Analysis of the Simulacrum Cancer Dataset'
authors:
- affiliation: "1, 2"
  name: Jakob Skelmose 
  orcid: 0009-0006-8967-9268
- affiliation: "1, 3"
  name: Rasmus Rask Kragh Jørgensen
  orcid: 0009-0000-7249-2196
- affiliation: "2, 4"
  name: Jennifer Bartell 
  orcid: 0000-0003-2750-9678
- affiliation: "1"
  name: Lars Nielsen  
  orcid: 0000-0002-3715-8528
- affiliation: "1"
  name: Charles Vesteghem  
  orcid: 0000-0003-2301-9081
- affiliation: "1"
  name: Martin Bøgsted
  orcid: 0000-0001-9192-1814
output:
  pdf_document: default
  html_document: default
tags:
- R
- censored cost
affiliations:
- index: 1
  name: Center for Clinical Data Science, Aalborg University , Aalborg, Denmark
- index: 2
  name: Health Data Science Sandbox, University of Copenhagen, Copenhagen, Denmark
- index: 3
  name: Department of Hematology, Aalborg University Hospital, Aalborg, Denmark
- index: 4
  name: Center for Health Data Science, University of Copenhagen, Copenhagen, Denmark
date: 16 January 2025
bibliography: simulacrumrRef.bib
---


# Summary
The simulacrumR R package addresses the technical barriers associated with utilizing Simulacrum through a streamlined workflow for accessing, preprocessing, and validating statistical analyses on the Simulacrum dataset. Thus, making it more accessible to researchers and clinicians with limited database expertise. The main function of this package is the `create_workflow()` function which creates an R script, based on the user's input, that includes all the necessary code and is compatible for execution on the Cancer Administration System (CAS) database servers.
# Statement of need 
The Simulacrum is a synthetic version of the CAS database, enabling the development and testing of code for analysing (Cancer Administrative System) CAS data which is held by the National Disease Registration Service (NDRS) (@national2022guide). The CAS data is stored in an Oracle database, requiring SQL queries for data extraction. A common analysis workflow involves querying the database directly from R, extracting data, and further processing it to produce analytical outputs (the R workflow). The Simulacrum is a synthetic version of the CAS database, enabling the development and testing of code for analysing CAS data. The latest version of Simulacrum contains information about patient characteristics, tumor diagnosis, systematic anti-cancer treatment, radiotherapy, and gene testing data (@frayling2023simulacrum). Code developed on the Simulacrum can be sent to NDRS for execution on the CAS database. This involves first making adjustments to the code. SQL queries need further processing by NDRS due to: 
a) Structural differences between Simulacrum and CAS.
b) Unknown details/specifications of CAS database.
c) Code alignment with NDRS best practices.
Executing the code, assessing outputs for privacy, and releasing the data. This is done free of charge, if under 3 hours of work. Providing easily adaptable and executable code is essential for this to be done in an efficient and timely manner.
The advantages of utilizing Simulacrum can be summarized as follows: 

1.	Accelerated research.
2.	Democratization of data.
3.	Improving Privacy. 
4.	Eliminating Data Dredging.

However, due to Simulacrum prioritizing privacy over fidelity, the dataset is primarily suitable for designing and testing analysis pipelines for the CAS data, not generating actionable results (@bullward2023research). 
The process of accessing the real data through Simulacrum requires users to download CSV files, install a local Oracle database, configure ODBC connections, and construct SQL queries and R scripts. Setting up a full Oracle database can be complex, particularly for new users. This presents a barrier to testing the full R workflow using Simulacrum and may discourage users from doing so (@national2022guide). 
Providing the full R workflow with SQL queries for data extraction helps NDRS understand the exact form and specification of the data needed from the database, making it easier to make required adjustments to the code before executing on the CAS. The SimulacrumWorkflowR Package simplifies testing by removing the need to set up an Oracle database or configure ODBC connections. This allows users to create and test the full R workflow, including SQL queries that demonstrate the exact specification and form of the data required from the CAS database, see Figure 1.
![](fig/figure1_modified.drawio.png)

Figure 1: Overview of the process of running an analysis on the CAS Database using an R workflow tested on Simulacrum and the process of running a similar analysis with the simulacrumR package. 

This can then be easily adapted by NDRS to run on the CAS database. The simulacrumR package is, to our knowledge, the first package designed to enhance usability and provide a complete workflow for utilizing the Simulacrum to facilitate access and execution of analysis on the CAS database.

# Key functionalities 
Providing a streamlined setup for building the workflow in R. The package includes:

1.	Integrated SQL Environment: Leverages the SQLdf (@grothendieck2017sqldf) package to enable SQL queries directly within R, eliminating the need for external database setup and ODBC connections by creating a local temporary SQLite database within the R environment. 
2.	Query Helper: Offers a collection of queries custom-made for the Simulacrum, for pulling and merging certain tables. Additionally, does the `sqlite2oracle` function assist in translating queries to be compatible with the NHS servers.
3.	Helper Tools: Offers a range of data preprocessing functions for cleaning and preparing the data for analysis, ensuring data quality and consistency. Key functions include cancer type grouping, survival status, and logging. 
4.	Workflow Generator: Generates an R script with the complete workflow. Ensuring correct layout and the ability to integrate all the necessary code to obtain a workflow suitable for submission to the NHS and execution on the CAS database. 

# Workflow illustration
simulacrumR was developed with R version 4.3.3. Installation requires Devtools and relies on dependencies listed in the DESCRIPTION file on GitHub. These dependencies are automatically installed during package installation.

### Installation:
```R
if (!require("devtools")) install.packages("devtools")
devtools::install_github("CLINDA-AAU/simulacrumR",
dependencies = TRUE)) 
```

### Loading data:
```R
library(simulacrumR)
#Set the path to the directory where the Simulacrum CSV files are located; 
Dir <- “/path/to/simulacrum/csv/files”;
#Import the Simulacrum data files; 
Data_frames <- read_simulacrum(Dir);
```

### Quering data:
```R
query <- “SELECT * 
          FROM sim_av_patient 
          INNER JOIN sim_av_tumour ON sim_av_patient.patientid = sim_av_tumour.patientid”
merged_data <- query_sql(query)
```

### Generating a Reproducible Workflow for NHS Submission 
```R
create_workflow( 
libraries = "library(dplyr)", 
query = "select * from sim_av_patient where age > 50 limit 500;", 
data_management = "cancer_grouping(sim_av_tumour)",
analysis = "model = glm(Y ~ x1 + x2 + x3, data=data)",
model_results = "html_table_model(model)", 
Logger_report=TRUE)
```

### Oracle Compatibility: 
The `sqlite2oracle` function ensures basic query translation for Oracle databases.

### Logging: 
In the event of an error on NHS servers while executing the analysis pipeline, the `time_management` function and the base R `sink` function will generate a comprehensive log to facilitate seamless debugging.

# Limitations 
Data Differences:
- Coverage: Simulacrum reflects diagnoses from 2016–2019, while CAS includes records dating back to 1971. These restrictions need to be added to code for running on CAS.
- Structure: Simulacrum has a simplified structure for ease of use, but this differs from the evolving CAS database. Requires NDRS to make adjustments for running on CAS

SQLite: While SQLite and Oracle share a common foundation in SQL, variations in certain queries exist. Table 1 highlights some key variations:  

| Feature | SQLite | Oracle |
|---|---|---|
| Case Sensitivity | Doesn't matter if you use upper or lower case for commands. Example: `select`, `Select`, `SELECT`. | Uppercase. Example: `SELECT` |
| Limits on Results | Use `LIMIT`. `LIMIT 50;` | Use `ROWNUM`, `OFFSET`, and `FETCH NEXT`. `WHERE ROWNUM => 50;` |

Table 1: An overview of the difference between basic SQL commands for SQLite and Oracle.  

Time Management: While Simulacrum facilitates SQL query testing, time estimates for queries may not align with CAS performance due to its larger dataset. Similarly, code adjustments will take time that is unaccounted for in this. However, the package remains beneficial for testing time for other aspects of R scripts and to understand which analyses are time consuming. It Is advised to divide the analysis into parts, to make sure some of the analysis can be returned. An example of divided analyses can be found in @nielsen2024simulacrum.

# Acknowledgements
Jakob Skelmose and Jennifer Bartell acknowledge support from the Health Data Science Sandbox (https://hds-sandbox.github.io) funded by the Novo Nordisk Fonden (NNF20OC0063268). Martin Bøgsted and Rasmus Rask acknowledge support from the SE3D project (Synthetic health data: ethical deployment and dissemination via deep learning approaches) funded by the Novo Nordisk Fonden (NNF23OC0083510).

# References 
