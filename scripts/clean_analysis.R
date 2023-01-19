# Use the project root directory as a base for other file paths
analysis_fp <- file.path(project_dir, "results_analysis", "reproduced_analyses")

# Load the roleset csv file
results_roleset_cxnDT <- read.csv(file.path(analysis_fp, "cxn_roleset_distinctive_reproduced_analysis.csv"), header=TRUE, sep="\t", quote="", comment.char="")

# Create an empty list to store the new dataframes
cxn_roleset_preference_list = list()

# Get the unique constructions in the "PREF" column
constructions = unique(results_roleset_cxnDT$PREF)

constructions_df = data.frame(constructions)

cxn1 = constructions_df$constructions[1]
cxn2 = constructions_df$constructions[2]

colnames(results_roleset_cxnDT)[2] <- cxn1
colnames(results_roleset_cxnDT)[3] <- cxn2

mix_results_all_cxn_roleset <- results_roleset_cxnDT %>% 
  filter(!!as.symbol(cxn1) > 0 & !!as.symbol(cxn2) > 0)

# Order by LLR
mix_results_all_cxn_roleset <- mix_results_all_cxn_roleset[order(-mix_results_all_cxn_roleset$LLR), ]

write.table(mix_results_all_cxn_roleset, file = file.path(analysis_fp, str_glue("results_cxn12_mixed_roleset_reproduced_analysis.csv")), row.names = FALSE, sep = "\t", col.names = TRUE, quote = FALSE)

# Iterate through each construction
for (c in constructions) {
  # Subset the original dataframe to only include rows with the current construction
  subset_df = results_roleset_cxnDT[results_roleset_cxnDT$PREF == c, ]
  
  # Sort the data frame based on the LOGODDSRATIO column
  subset_df = subset_df[order(-subset_df$LLR), ]
  
  # Assign the subsetted dataframe to a new object named after the construction
  assign(c, subset_df)
  
  # Append the subsetted dataframe to the list of new dataframes
  cxn_roleset_preference_list[[c]] <- subset_df
}

write.table(cxn_roleset_preference_list[[cxn1]], file = file.path(analysis_fp, str_glue("results_{cxn1}_roleset_distinctive_reproduced_analysis.csv")), row.names = FALSE, sep = "\t", col.names = TRUE, quote = FALSE)

write.table(cxn_roleset_preference_list[[cxn2]], file = file.path(analysis_fp, str_glue("results_{cxn2}_roleset_distinctive_reproduced_analysis.csv")), row.names = FALSE, sep = "\t", col.names = TRUE, quote = FALSE)


# Load the lemma csv file
results_lemma_cxnDT <- read.csv(file.path(analysis_fp, "cxn_lemma_distinctive_reproduced_analysis.csv"), header=TRUE, sep="\t", quote="", comment.char="")

colnames(results_lemma_cxnDT)[2] <- cxn1
colnames(results_lemma_cxnDT)[3] <- cxn2

mix_results_all_cxn_lemma <- results_lemma_cxnDT %>% 
  filter(!!as.symbol(cxn1) > 0 & !!as.symbol(cxn2) > 0)

mix_results_all_cxn_lemma <- mix_results_all_cxn_lemma[order(-mix_results_all_cxn_lemma$LLR), ]

write.table(mix_results_all_cxn_lemma, file = file.path(analysis_fp, str_glue("results_cxn12_mixed_lemma_reproduced_analysis.csv")), row.names = FALSE, sep = "\t", col.names = TRUE, quote = FALSE)

# Create an empty list to store the new dataframes
cxn_lemma_preference_list = list()

# Iterate through each construction
for (c in constructions) {
  # Subset the original dataframe to only include rows with the current construction
  subset_df = results_lemma_cxnDT[results_lemma_cxnDT$PREF == c, ]
  
  # Sort the data frame based on the LOGODDSRATIO column
  subset_df = subset_df[order(-subset_df$LLR), ]
  
  # Assign the subsetted dataframe to a new object named after the construction
  assign(c, subset_df)
  
  # Append the subsetted dataframe to the list of new dataframes
  cxn_lemma_preference_list[[c]] <- subset_df
}

write.table(cxn_lemma_preference_list[[cxn1]], file = file.path(analysis_fp, str_glue("results_{cxn1}_lemma_distinctive_reproduced_analysis.csv")), row.names = FALSE, sep = "\t", col.names = TRUE, quote = FALSE)

write.table(cxn_lemma_preference_list[[cxn2]], file = file.path(analysis_fp, str_glue("results_{cxn2}_lemma_distinctive_reproduced_analysis.csv")), row.names = FALSE, sep = "\t", col.names = TRUE, quote = FALSE)

######

# export the same lists but only with verbs that occur in both constructions

# Load the roleset csv file
mix_results_roleset <- read.table(file.path(analysis_fp, str_glue("results_{cxn1}_roleset_distinctive_reproduced_analysis.csv")), header=TRUE, sep="\t", quote="", comment.char="")

mix_results_roleset <- data.frame(mix_results_roleset)

colnames(mix_results_roleset)[2] <- cxn1
colnames(mix_results_roleset)[3] <- cxn2

cxn1_mixed <- colnames(mix_results_roleset)[2]
cxn2_mixed <- colnames(mix_results_roleset)[3]

# Filter to only larger than 0 in cxn column
mix_results_roleset <- mix_results_roleset %>% 
  filter(!!as.symbol(cxn1_mixed) > 0 & !!as.symbol(cxn2_mixed) > 0)

write.table(mix_results_roleset, file = file.path(analysis_fp, str_glue("results_{cxn1}_mixed_rolesets_reproduced_analysis.csv")), row.names = FALSE, sep = "\t", col.names = TRUE, quote = FALSE)

# Load the roleset csv file
mix_results_roleset <- read.table(file.path(analysis_fp, str_glue("results_{cxn2}_roleset_distinctive_reproduced_analysis.csv")), header=TRUE, sep="\t", quote="", comment.char="")

mix_results_roleset <- data.frame(mix_results_roleset)

colnames(mix_results_roleset)[2] <- cxn1
colnames(mix_results_roleset)[3] <- cxn2

# Filter to only larger than 0 in cxn column
mix_results_roleset <- mix_results_roleset %>% 
  filter(!!as.symbol(cxn1_mixed) > 0 & !!as.symbol(cxn2_mixed) > 0)

write.table(mix_results_roleset, file = file.path(analysis_fp, str_glue("results_{cxn2}_mixed_rolesets_reproduced_analysis.csv")), row.names = FALSE, sep = "\t", col.names = TRUE, quote = FALSE)



# Load the lemma csv file
mix_results_lemma <- read.table(file.path(analysis_fp, str_glue("results_{cxn1}_lemma_distinctive_reproduced_analysis.csv")), header=TRUE, sep="\t", quote="", comment.char="")

mix_results_lemma <- data.frame(mix_results_lemma)

colnames(mix_results_lemma)[2] <- cxn1
colnames(mix_results_lemma)[3] <- cxn2

cxn1_mixed <- colnames(mix_results_roleset)[2]
cxn2_mixed <- colnames(mix_results_roleset)[3]

# Filter to only larger than 0 in cxn column
mix_results_lemma <- mix_results_lemma %>% 
  filter(!!as.symbol(cxn1_mixed) > 0 & !!as.symbol(cxn2_mixed) > 0)

write.table(mix_results_lemma, file = file.path(analysis_fp, str_glue("results_{cxn1}_mixed_lemma_reproduced_analysis.csv")), row.names = FALSE, sep = "\t", col.names = TRUE, quote = FALSE)

# Load the lemma csv file
mix_results_lemma <- read.table(file.path(analysis_fp, str_glue("results_{cxn2}_lemma_distinctive_reproduced_analysis.csv")), header=TRUE, sep="\t", quote="", comment.char="")

mix_results_lemma <- data.frame(mix_results_lemma)

colnames(mix_results_lemma)[2] <- cxn1
colnames(mix_results_lemma)[3] <- cxn2

# Filter to only larger than 0 in cxn column
mix_results_lemma <- mix_results_lemma %>% 
  filter(!!as.symbol(cxn1_mixed) > 0 & !!as.symbol(cxn2_mixed) > 0)

write.table(mix_results_lemma, file = file.path(analysis_fp, str_glue("results_{cxn2}_mixed_lemma_reproduced_analysis.csv")), row.names = FALSE, sep = "\t", col.names = TRUE, quote = FALSE)





