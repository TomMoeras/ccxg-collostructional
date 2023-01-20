# Function to extract utterances from data frame that have a specific roleset
get_utterances_by_roleset <- function(data_frame, roleset) {
  # Use sapply to check if any of the roles in the roles column of the data frame have the input roleset
  # and select the corresponding utterance
  utterances <- data_frame[sapply(data_frame$roles, function(x) any(x$roleset == roleset)), c("utterance", "argument_structure_construction")]
  # remove NAs from the resulting utterances dataframe
  selected_rows <- utterances[!is.na(utterances)]
  return(selected_rows)
}

# Function to extract utterances from data frame that have a specific argument structure construction
get_utterances_by_arg_struc_cxn <- function(data_frame, arg_struc_cxn) {
  # Use sapply to check if any of the rows in the arg_struct column of the data frame have the input arg_struc_cxn
  # and select the corresponding utterance, roles and arg_struct
  utterances <- data_frame[sapply(data_frame$argument_structure_construction, function(x) any(x == arg_struc_cxn)), c("utterance", "roles", "argument_structure_construction")]
  selected_rows <- utterances[!is.na(utterances)]
  return(selected_rows)
}


# Function that deletes a column from a dataframe
remove_column <- function(data_frame, column_name) {
  data_frame[, column_name] <- NULL
  return(data_frame)
}

count_frequency <- function(data_frame) {
  arg_struc_cxn_table <- table(data_frame$arg_struc_cxn)
  roleset_table <- table(data_frame$roleset)
  lemma_table <- table(data_frame$lemma)
  return(list(arg_struc_cxn_table, roleset_table, lemma_table))
}

filter_by_n_most_frequent_arg_struc_cxn <- function(data_frame, n) {
  # Get the counts of the arg_struc_cxn
  arg_struc_cxn_counts <- table(data_frame$arg_struc_cxn)
  
  # Sort the counts in descending order
  arg_struc_cxn_counts <- sort(arg_struc_cxn_counts, decreasing = TRUE)
  
  # Get the n most frequent arg_struc_cxn
  top_n_arg_struc_cxn <- names(arg_struc_cxn_counts)[1:n]
  
  # Filter the dataframe to only include the rows with the top n arg_struc_cxn
  filtered_data_frame <- data_frame[data_frame$arg_struc_cxn %in% top_n_arg_struc_cxn,]
  
  return(filtered_data_frame)
}

detect_rolesets_by_lemma <- function(corpus_df) {
  lemma_rolesets_list <- lapply(unique(corpus_df$lemma), function(lemma) {
    lemma_rows <- corpus_df[corpus_df$lemma == lemma, ]
    lemma_rolesets <- unique(unlist(lemma_rows$roles))
    return(list(lemma = lemma, rolesets = lemma_rolesets))
  })
  lemma_rolesets_df <- do.call(rbind, lemma_rolesets_list)
  return(lemma_rolesets_df)
}

combine_columns <- function(df1, df2, col1, col2) {
  # Extract the specified columns from each dataframe
  col1_data <- df1[,col1]
  col2_data <- df2[,col2]
  
  # Create a new dataframe with the combined columns
  combined_df <- data.frame(col1 = col1_data, col2 = col2_data)
  
  colnames(combined_df) <- c(col1, col2)
  
  # Return the new dataframe
  return(combined_df)
}








