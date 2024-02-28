# R Scripts that auto runs a collostructional analysis on a PropBank-annotated corpus and generates the necessary files for analysis

# Import necessary libraries and install if necessary
library(base)
library(graphics)
library(stats)
library(utils)
library(ggplot2)
library(tibble)
library(jsonlite)
library(dplyr)
library(here)
library(tidyr)
library(stringr)

# Get the path to the project root directory
project_dir <- here::here()

# Run the files automatically
source(file.path(project_dir, "scripts", "utils.R")) # loads several functions used during data processing and analysis
source(file.path(project_dir, "scripts", "load_data.R")) # loads the .json and turns it into a workable data frame
source(file.path(project_dir, "scripts", "clean_data.R")) # cleans the data and creates data frames used for analysis
source(file.path(project_dir, "scripts", "coll.analysis.r")) # Loads functions needed for the DCA # Copyright (C) 2022 Stefan Th. Gries (Latest changes in this version: 21 August 2022)
##########################################################################################################################################
# IMPORTANT: The run.analysis.auto script does not use the FYE association score by default.
# If you want to use FYE, you have to manually turn it on in the script itself (= change the indicated variable to "yes" instead of "no")
# WARNING: It takes a very long time to perform FYE.
##########################################################################################################################################
source(file.path(project_dir, "scripts", "run.analysis.auto.R")) # Runs the DCA
source(file.path(project_dir, "scripts", "clean_analysis.R"))

