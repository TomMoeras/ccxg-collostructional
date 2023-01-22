# Applying CCG and Collostructional Analysis on a PropBank-annotated corpus

This project uses a Computational Construction Grammar (CCG) approach and collostructional analysis on a PropBank-annotated corpus. It explores the data gained from this and focuses on the differences between lemmas and their word senses when used in alternating constructions. The R scripts can be run on any .json output given by the CCxG Explorer available here: https://ehai.ai.vub.ac.be/ccxg-explorer/.

## Running a distinctive collexeme analysis / reproducing results

To analyse your own .json or reproduce the analysis conducted in this study, follow these steps:

* **Install and/or load the necessary packages**
  * ```
    install.packages(c("base", "graphics", "here", "stats", "utils", "ggplot2", "dplyr", "jsonlite", "stringr", "tibble", "tidyr")

    # most of these are available in the tidyverse package
    # install.package("tidyverse")

    # load the packages
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
    ```
* **Reproducing the analysis**
  1. Copy the github repo
  2. Run the script "auto.run.R" located in the "scripts" folder.
  3. The results will be in the "results_analysis/reproduced_analyses" folder.
* **Analysing your own data set**
  1. Copy the github repo
  2. Open "load_data.R"
  3. Change the filepath to your own file you want to analyse
  4. Save "load.data.R"
  5. Open and run "auto.run.R"

## Overview of the files

* **scripts**
  * auto.run.R
    * R Scripts that auto runs a collostructional analysis on a PropBank-annotated corpus and generates the necessary files for analysis.
  * clean_analysis.R
    * R script that cleans the results from the DCA and generates several .csv files that contain the cleaned data analysis.
  * clean_data.R
    * R script that cleans the raw data and creates data frames used for the analysis.
  * coll.analysis.R
    * R script that loads the functions needed for the DCA. Copyright (C) 2022 Stefan Th. Gries (Latest changes in this version: 21 August 2022).
  * load_data.R
    * R script that loads the raw corpus .json file and turns it into a workable data frame.
  * packages_used_scripts.R
    * R script that collects the packages used in the different scripts based on the used functions.
  * run.analysis.auto.R
    * R script that performs a DCA on a set file.
  * run.analysis.fileinput.R
    * R script that performs a DCA on a file choosen by the user.
  * utils.R
    * R script that contains several functions used to interpret and analyze the data.
* **data**
  * corpus_cleaned
    * contains the several files that can be used for a DCA and MDCA
  * raw_data
    * contains the .json raw data output from the CCxG Explorer
    * contains the loaded raw corpus data
* **results_analysis**
  * MDCA
    * contains the results from the MDCA
  * ordered_analysis_cxn
    * contains the ordered results from the DCA analysis in full
  * reproduced_analyses
    * contains the results from the reproduced DCA analyses
