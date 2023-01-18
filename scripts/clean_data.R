source(file.path(project_dir, "scripts", "utils.R"))

# Use the project root directory as a base for other file paths
corpus_cleaned_fp <- file.path(project_dir, "data", "corpus_cleaned")

lemma_rolesets_df <- detect_rolesets_by_lemma(corpus_analysis_df)

freq_list <- count_frequency(corpus_analysis_df)

numbers_df <- data.frame(lemma = integer(), roleset = integer(), arg_struc_cxn = integer(), stringsAsFactors = FALSE)

numbers_df <- numbers_df %>% add_row(lemma = length(freq_list[[3]]), roleset = length(freq_list[[2]]), arg_struc_cxn = length(freq_list[[1]]))

rownames(numbers_df) <- c("#types")

write.table(numbers_df, file = file.path(corpus_cleaned_fp, "numbers.csv"), row.names = FALSE, sep = "\t", col.names = TRUE, quote = FALSE)

df_cxn_lemma_multiple <- combine_columns(corpus_analysis_df, corpus_analysis_df, "arg_struc_cxn", "lemma")

write.table(df_cxn_lemma_multiple, file = file.path(corpus_cleaned_fp, "cxn_lemma_multiple.csv"), row.names = FALSE, sep = "\t", col.names = TRUE, quote = FALSE)

df_roleset_cxn_multiple <- combine_columns(corpus_analysis_df, corpus_analysis_df, "arg_struc_cxn", "roleset")

write.table(df_cxn_lemma_multiple, file = file.path(corpus_cleaned_fp, "cxn_roleset_multiple.csv"), row.names = FALSE, sep = "\t", col.names = TRUE, quote = FALSE)

#

df_cxn_roleset_lemma_distinctive <- filter_by_n_most_frequent_arg_struc_cxn(corpus_analysis_df, 2)

df_cxn_lemma_distinctive <- combine_columns(df_cxn_roleset_lemma_distinctive, df_cxn_roleset_lemma_distinctive, "arg_struc_cxn", "lemma")

write.table(df_cxn_lemma_distinctive, file = file.path(corpus_cleaned_fp, "cxn_lemma_distinctive.csv"), row.names = FALSE, sep = "\t", col.names = TRUE, quote = FALSE)

df_cxn_roleset_distinctive <- combine_columns(df_cxn_roleset_lemma_distinctive, df_cxn_roleset_lemma_distinctive, "arg_struc_cxn", "roleset")

write.table(df_cxn_roleset_distinctive, file = file.path(corpus_cleaned_fp, "cxn_roleset_distinctive.csv"), row.names = FALSE, sep = "\t", col.names = TRUE, quote = FALSE)

#

unique_cxn_list <- unique(corpus_analysis_df$arg_struc_cxn)

df_summary_corpus <- corpus_analysis_df %>%
  group_by(lemma) %>%
  summarise(roleset)

#Count the frequency of each roleset in each construction
construction_counts <- corpus_analysis_df %>%
  group_by(lemma, roleset, arg_struc_cxn) %>%
  summarize(count = n())

# Pivot the df
df_summary_corpus <- pivot_wider(construction_counts, names_from = arg_struc_cxn, values_from = count)

df_summary_corpus$total <- rowSums(df_summary_corpus[,3:ncol(df_summary_corpus)], na.rm = TRUE)

cxn_freq_table <- data.frame(sort(freq_list[[1]], decreasing = TRUE, by = "value"))
colnames(cxn_freq_table)[1]<-"arg_struc_cxn"

cxn_freq_df <- data.frame(cxn_freq_table$arg_struc_cxn)

col_order <- c(cxn_freq_df$cxn_freq_table.arg_struc_cxn)

alph_lemma_df <- select(df_summary_corpus, "lemma", "roleset", "total", c(col_order))

write.table(alph_lemma_df, file = file.path(corpus_cleaned_fp, "alph_lemma_roleset_cxn.csv"), row.names = FALSE, sep = "\t", col.names = TRUE, quote = FALSE)

df_summary_corpus <- df_summary_corpus %>%
  arrange(desc(total))

corpus_cleaned_overview <- select(df_summary_corpus, "lemma", "roleset", "total", c(col_order))

write.table(corpus_cleaned_overview, file = file.path(corpus_cleaned_fp, "corpus_cleaned_summary.csv"), row.names = FALSE, sep = "\t", col.names = TRUE, quote = FALSE)
write.table(cxn_freq_table, file = file.path(corpus_cleaned_fp, "cxn_frequency_table.csv"), row.names = FALSE, sep = "\t", col.names = TRUE, quote = FALSE)


