# Use the project root directory as a base for other file paths
corpus_cleaned_fp <- file.path(project_dir, "data", "corpus_cleaned")

# Detect the rolesets used by each lemma
lemma_rolesets_df <- detect_rolesets_by_lemma(corpus_analysis_df)

# Count the frequency of each argument structure, roleset, and lemma
freq_list <- count_frequency(corpus_analysis_df)

# Create a data frame with the number of types for each of the three categories
numbers_df <- data.frame(lemma = integer(), roleset = integer(), arg_struc_cxn = integer(), stringsAsFactors = FALSE)

numbers_df <- numbers_df %>% add_row(lemma = length(freq_list[[3]]), roleset = length(freq_list[[2]]), arg_struc_cxn = length(freq_list[[1]]))

rownames(numbers_df) <- c("#types")

# Save the results in a .csv file
write.table(numbers_df, file = file.path(corpus_cleaned_fp, "numbers.csv"), row.names = FALSE, sep = "\t", col.names = TRUE, quote = FALSE)

# Combine the argument structure, roleset, and lemma columns to create a data frame with all possible combinations of these three categories
df_cxn_lemma_multiple <- combine_columns(corpus_analysis_df, corpus_analysis_df, "arg_struc_cxn", "lemma")

write.table(df_cxn_lemma_multiple, file = file.path(corpus_cleaned_fp, "cxn_lemma_multiple.csv"), row.names = FALSE, sep = "\t", col.names = TRUE, quote = FALSE)

df_cxn_roleset_multiple <- combine_columns(corpus_analysis_df, corpus_analysis_df, "arg_struc_cxn", "roleset")

write.table(df_cxn_roleset_multiple, file = file.path(corpus_cleaned_fp, "cxn_roleset_multiple.csv"), row.names = FALSE, sep = "\t", col.names = TRUE, quote = FALSE)

# Filter the data frame to only include argument structures that occur more than once
df_cxn_roleset_lemma_distinctive <- filter_by_n_most_frequent_arg_struc_cxn(corpus_analysis_df, 2)

# Combine the argument structure, roleset, and lemma columns to create a data frame with all possible combinations of these three categories
df_cxn_lemma_distinctive <- combine_columns(df_cxn_roleset_lemma_distinctive, df_cxn_roleset_lemma_distinctive, "arg_struc_cxn", "lemma")

write.table(df_cxn_lemma_distinctive, file = file.path(corpus_cleaned_fp, "cxn_lemma_distinctive.csv"), row.names = FALSE, sep = "\t", col.names = TRUE, quote = FALSE)

df_cxn_roleset_distinctive <- combine_columns(df_cxn_roleset_lemma_distinctive, df_cxn_roleset_lemma_distinctive, "arg_struc_cxn", "roleset")

write.table(df_cxn_roleset_distinctive, file = file.path(corpus_cleaned_fp, "cxn_roleset_distinctive.csv"), row.names = FALSE, sep = "\t", col.names = TRUE, quote = FALSE)

#

# Get a list of the unique construction types in the corpus
unique_cxn_list <- unique(corpus_analysis_df$arg_struc_cxn)

# Create a new dataframe with the lemma and roleset for each unique lemma
df_summary_corpus <- corpus_analysis_df %>%
  group_by(lemma) %>%
  summarise(roleset)

# Count the frequency of each roleset in each construction
construction_counts <- corpus_analysis_df %>%
  group_by(lemma, roleset, arg_struc_cxn) %>%
  summarize(count = n())

# Pivot the dataframe
df_summary_corpus <- pivot_wider(construction_counts, names_from = arg_struc_cxn, values_from = count)

# Sum the total number of constructions for each lemma
df_summary_corpus$total <- rowSums(df_summary_corpus[,3:ncol(df_summary_corpus)], na.rm = TRUE)

# Create a dataframe of the construction types in descending order of frequency
cxn_freq_table <- data.frame(sort(freq_list[[1]], decreasing = TRUE, by = "value"))
colnames(cxn_freq_table)[1]<-"arg_struc_cxn"
cxn_freq_df <- data.frame(cxn_freq_table$arg_struc_cxn)
col_order <- c(cxn_freq_df$cxn_freq_table.arg_struc_cxn)

# Create a new dataframe with the lemmas and constructions in descending order of frequency
alph_lemma_df <- select(df_summary_corpus, "lemma", "roleset", "total", c(col_order))

# Write the dataframe to a file
write.table(alph_lemma_df, file = file.path(corpus_cleaned_fp, "alph_lemma_roleset_cxn.csv"), row.names = FALSE, sep = "\t", col.names = TRUE, quote = FALSE)

# Create another dataframe with the lemmas and constructions in descending order of frequency
df_summary_corpus <- df_summary_corpus %>%
  arrange(desc(total))

# Create a new dataframe of the construction types in descending order of frequency
corpus_cleaned_overview <- select(df_summary_corpus, "lemma", "roleset", "total", c(col_order))

write.table(corpus_cleaned_overview, file = file.path(corpus_cleaned_fp, "corpus_cleaned_summary.csv"), row.names = FALSE, sep = "\t", col.names = TRUE, quote = FALSE)
write.table(cxn_freq_table, file = file.path(corpus_cleaned_fp, "cxn_frequency_table.csv"), row.names = FALSE, sep = "\t", col.names = TRUE, quote = FALSE)


