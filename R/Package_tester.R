source("R/preprocessing.R")
library(sqldf)
library(tcltk)

dir <- "C:/Users/p90j/Desktop/Jakob/Data/Simulacrum/simulacrum_v2.1.0/Data/"

read_all_csv <- function(dir)
{
  print("Please wait. It can take a couple of minutes to upload all files ")
  sim_av_patient <- read.csv(paste0(dir, "sim_av_patient.csv"))
  print("sim_av_patient is uploaded")
  sim_av_tumour <- read.csv(paste0(dir, "sim_av_tumour.csv"))
  print("sim_av_tumours is uploaded")
  sim_av_gene <- read.csv(paste0(dir, "sim_av_gene.csv"))
  print("sim_av_gene is uploaded")
  sim_rtds_combined <- read.csv(paste0(dir, "sim_rtds_combined.csv"))
  print("sim_rtds_combined is uploaded")
  sim_sact_outcome <- read.csv(paste0(dir, "sim_sact_outcome.csv"))
  print("sim_sact_outcome is uploaded")
  sim_sact_regimen <- read.csv(paste0(dir, "sim_sact_regimen.csv"))
  print("sim_sact_regimen is uploaded")
  sim_sact_cycle <- read.csv(paste0(dir, "sim_sact_cycle.csv"))
  print("sim_sact_cycle is uploaded")
  sim_sact_drug_detail <- read.csv(paste0(dir, "sim_sact_drug_detail.csv"))
  print("sim_sact_drug_detail is uploaded")
  print("All CSV files is succesfully uploaded!")
  
}

read_all_csv("C:/Users/p90j/Desktop/Jakob/Data/Simulacrum/simulacrum_v2.1.0/Data/")



sql_sim_av_patient <- table_sample(sim_av_patient)
sql_sim_av_tumour <- table_sample(sim_av_tumour)
sql_sim_av_gene <- table_sample(sim_av_gene)


sql_sim_sact_outcome <- table_sample(sim_sact_outcome)
sql_sim_sact_cycle <- table_sample(sim_sact_cycle)
sql_sim_sact_regimen <- table_sample(sim_sact_regimen)
sql_sim_sact_drug_detail <- table_sample(sim_sact_drug_detail)

sql_sim_rtds_combined <- table_sample(sim_rtds_combined)











# Testing out some stuff. 
# code is from: https://medium.com/@amit25173/exploratory-data-analysis-in-r-a-step-by-step-guide-with-code-examples-d5cc08222049


library(plotly)

create_bar_charts_plotly <- function(df) {
  for (col_name in names(df)) {
    plot <- plot_ly(df, x = ~.data[[col_name]], type = 'histogram') %>% 
      layout(title = paste("Bar Chart of", col_name), 
             xaxis = list(title = col_name), 
             yaxis = list(title = "Count"))

    print(plot)
  }
}


create_bar_charts_plotly(sql_sim_av_gene)



create_correlation_plot <- function(df) {

  cor_matrix <- cor(df[, sapply(df, is.numeric)])
  

  plot_ly(
    x = colnames(cor_matrix), 
    y = rownames(cor_matrix),
    z = cor_matrix, 
    type = "heatmap",
    colorscale = "RdBu",  
    zmin = -1, zmax = 1    
  ) %>%
    layout(
      title = "Correlation Matrix",
      xaxis = list(title = ""), 
      yaxis = list(title = "")
    )
}

create_correlation_plot(sql_sim_sact_outcome)


# Example of a density plot
ggplot(sql_sim_av_tumour, aes(x=AGE)) + 
  geom_density(fill="skyblue", alpha=0.7) + 
  theme_minimal() +
  labs(title="Density Plot of Your Numeric Column", x="Your Numeric Column", y="Density")
create_density_plots(sql_sim_av_tumour)


# Example of a boxplot
ggplot(sql_sim_av_tumour, aes(y=c)) + 
  geom_boxplot(fill="lightgreen", color="darkgreen") + 
  theme_minimal() +
  labs(title="Boxplot of Your Numeric Column", y="Your Numeric Column")


library(ggplot2)

# Example of a histogram
ggplot(sql_sim_av_tumour, aes(x=AGE)) + 
  geom_histogram(binwidth=1, fill="steelblue", color="black") + 
  theme_minimal() +
  labs(title="Histogram of Your Numeric Column", x="Your Numeric Column", y="Frequency")

# Faceted plot example
ggplot(sql_sim_av_tumour, aes(x=AGE, fill=GENDER)) + 
  geom_histogram(binwidth=1, color="black") + 
  facet_wrap(~GENDER) +
  theme_minimal() +
  labs(title="Faceted Histogram by Categorical Variable")


library(plotly)

# Example of an interactive scatter plot
fig <- plot_ly(sql_sim_av_tumour, x = ~AGE, y = ~N_BEST, color = ~GENDER, type = 'scatter', mode = 'markers')
fig
