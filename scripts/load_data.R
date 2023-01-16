# Import necessary libraries
library(jsonlite)
library(dplyr)
library(here)

# Get the path to the project root directory
project_dir <- here::here()

# Use the project root directory as a base for other file paths
raw_data_file <- file.path(project_dir, "data", "raw_data", "CCxG_Ditrans_10000.json")


# Load the CCxG propbank-annotated .json corpus data
corpus_df <- fromJSON(raw_data_file)

# Convert JSON data to data frame
corpus_df <- as.data.frame(corpus_df)

# Extract the roles from the data frame
roles <- corpus_df[["roles"]]

# Extract the rolesets from the roles data frame
roleset_df <- data.frame(roleset = unlist(lapply(roles, function(x) x$roleset)))

# Remove NA values
roleset_df <- na.omit(roleset_df)

# Extract the rolesets from the roles data frame
lemma_df <- data.frame(lemma = unlist(lapply(roles, function(x) x$lemma)))

# Remove NA values
lemma_df <- na.omit(lemma_df)

add_lemma_column <- function(corpus_df, lemma_df) {
  corpus_df$lemma <- lemma_df$lemma
  return(corpus_df)
}

corpus_df <- add_lemma_column(corpus_df, lemma_df)


# Function that adds an additional column to a dataframe
# The new column is called argument_structure_construction and is a combination of roleType and pos
add_arg_struct <- function(data_frame) {
  # Add a new column called 'argument_structure_construction' to the data frame
  data_frame$argument_structure_construction <- sapply(data_frame$roles, function(x) {
    # Concatenate the roleType and pos columns into a string like 'arg0(np)'
    role_strings <- paste0(x$roleType, "(", x$pos, ")")
    # Collapse the role strings into a single string separated by '-'
    return(paste(role_strings, collapse = "-"))
  })
  # Return the modified data frame
  return(data_frame)
}

# Run the add add_arg_struct function to the corpus dataframe
corpus_df <- add_arg_struct(corpus_df)

# Function that creates the dataframe used for the analysis
# It combines the argument structure and roleset into a dataframe
combine_arg_struct_and_roleset <- function(corpus, rolesets, lemmas) {
  corpus_analysis_df <- data.frame(arg_struc_cxn = corpus$argument_structure_construction, roleset = rolesets$roleset, lemma = lemmas$lemma)
  return(corpus_analysis_df)
}

corpus_analysis_df <- combine_arg_struct_and_roleset(corpus_df, roleset_df, lemma_df)

