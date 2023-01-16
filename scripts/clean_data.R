source(file.path(project_dir, "scripts", "utils.R"))

# Use the project root directory as a base for other file paths
corpus_cleaned_fp <- file.path(project_dir, "data", "corpus_cleaned")

lemma_rolesets_df <- detect_rolesets_by_lemma(corpus_analysis_df)

###freq_table <- count_frequency(corpus_analysis_df)

###cxn_for_multiple <- filter_by_n_most_frequent_arg_struc_cxn(corpus_analysis_df, 50)

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