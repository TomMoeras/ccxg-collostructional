# Use the project root directory as a base for other file paths
analysis_fp <- file.path(project_dir, "results_analysis", "reproduced_analyses")

# Load the roleset csv file
results_roleset_cxnDT <- read.csv(file.path(analysis_fp, "cxn_roleset_distinctive_reproduced_analysis.csv"), header=TRUE, sep="\t", quote="", comment.char="")

# Create an empty list to store the new dataframes
cxn_roleset_preference_list = list()

# Get the unique constructions in the "PREFERENCE" column
constructions = unique(results_roleset_cxnDT$PREFERENCE)

# Iterate through each construction
for (c in constructions) {
  # Subset the original dataframe to only include rows with the current construction
  subset_df = results_roleset_cxnDT[results_roleset_cxnDT$PREFERENCE == c, ]
  
  # Sort the data frame based on the FYE column
  subset_df = subset_df[order(-subset_df$LOGODDSRATIO), ]
  
  # Assign the subsetted dataframe to a new object named after the construction
  assign(c, subset_df)
  
  # Append the subsetted dataframe to the list of new dataframes
  cxn_roleset_preference_list[[c]] <- subset_df
}

write.table(cxn_roleset_preference_list$`arg0(np)-v(v)-arg1(np)-arg2(pp)`, file = file.path(analysis_fp, "results_arg0(np)-v(v)-arg1(np)-arg2(pp)_roleset_distinctive_reproduced_analysis.csv"), row.names = FALSE, sep = "\t", col.names = TRUE, quote = FALSE)

write.table(cxn_roleset_preference_list$`arg0(np)-v(v)-arg2(np)-arg1(np)`, file = file.path(analysis_fp, "results_arg0(np)-v(v)-arg2(np)-arg1(np)_roleset_distinctive_reproduced_analysis.csv"), row.names = FALSE, sep = "\t", col.names = TRUE, quote = FALSE)


# Load the lemma csv file
results_lemma_cxnDT <- read.csv(file.path(analysis_fp, "cxn_lemma_distinctive_reproduced_analysis.csv"), header=TRUE, sep="\t", quote="", comment.char="")

# Create an empty list to store the new dataframes
cxn_lemma_preference_list = list()

# Get the unique constructions in the "PREFERENCE" column
constructions = unique(results_lemma_cxnDT$PREFERENCE)

# Iterate through each construction
for (c in constructions) {
  # Subset the original dataframe to only include rows with the current construction
  subset_df = results_lemma_cxnDT[results_lemma_cxnDT$PREFERENCE == c, ]
  
  # Sort the data frame based on the FYE column
  subset_df = subset_df[order(-subset_df$LOGODDSRATIO), ]
  
  # Assign the subsetted dataframe to a new object named after the construction
  assign(c, subset_df)
  
  # Append the subsetted dataframe to the list of new dataframes
  cxn_lemma_preference_list[[c]] <- subset_df
}

write.table(cxn_lemma_preference_list$`arg0(np)-v(v)-arg1(np)-arg2(pp)`, file = file.path(analysis_fp, "results_arg0(np)-v(v)-arg1(np)-arg2(pp)_lemma_distinctive_reproduced_analysis.csv"), row.names = FALSE, sep = "\t", col.names = TRUE, quote = FALSE)

write.table(cxn_lemma_preference_list$`arg0(np)-v(v)-arg2(np)-arg1(np)`, file = file.path(analysis_fp, "results_arg0(np)-v(v)-arg2(np)-arg1(np)_lemma_distinctive_reproduced_analysis.csv"), row.names = FALSE, sep = "\t", col.names = TRUE, quote = FALSE)

