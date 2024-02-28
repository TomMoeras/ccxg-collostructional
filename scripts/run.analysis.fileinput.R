dist.collexemes <- function(precbitsexponent = precbitsexponent) { 
  
  # Suppress warning messages 
  options(warn = -1)
  # Initialize variables
  dists <- 1
  input.dc <- 1
  fye.mpfr <- "no" # change input to "yes" if you want the FYE calculated as well. Warning: this takes a long time!
  file_input <- file.choose()
  # Get the base name of the file (without the file extension)
  file_input_base <- basename(file_input)
  # Create the filepath for the output file 
  file_output <- file.path(project_dir, "results_analysis", "reproduced_analyses", file_input_base)
  file_output <- paste0(gsub("\\..*", "", file_output), "_reproduced_analysis.csv")
  
  # Read the input file as a table
  input.matrix <- read.table(file_input, header = TRUE, sep = "\t", quote = "", comment.char = "")
  
  if (input.dc == 1) { # DCA
    # Transpose the table
    interim <- t(table(input.matrix))
    # Convert the table to a dataframe
    input.matrix <- data.frame(
      as.vector(interim[,1]),
      as.vector(interim[,2]), row.names = rownames(interim))
    # Rename the columns
    colnames(input.matrix) <- colnames(interim)
  } else {
    temp <- colnames(input.matrix)[2:3]
    # Convert the table to a dataframe
    input.matrix <- data.frame(
      as.vector(input.matrix[,2]),
      as.vector(input.matrix[,3]), row.names = input.matrix[,1])
    # Rename the columns
    colnames(input.matrix) <- temp
  }
  
  # Get the name of the first construction
  construction1.name <- colnames(input.matrix)[1]; construction2.name <- colnames(input.matrix)[2]
  
  # computation
  options(warn=-1)
  
  # calculate Pearson's residuals for each word-construction pair
  pearson.residuals <- chisq.test(input.matrix, correct=FALSE)$residuals[,1]
  
  # create a list of 2x2 matrices for each word-construction pair
  all.2.by.2.matrices <- apply(
    input.matrix, 1,
    \(af) { matrix(c(af, colSums(input.matrix)-af), byrow=TRUE, ncol=2) },
    simplify=FALSE)
  
  # if FYE calculation is desired, calculate FYE values for each 2x2 matrix
  if (fye.mpfr=="yes") {
    FYE.values <- lapply(all.2.by.2.matrices,
                         \(af) fisher.test.mpfr(af))
  }
  
  # calculate log-odds ratios for each 2x2 matrix
  glms <- lapply(all.2.by.2.matrices,
                 \(af) glm(rbind(af[1,], af[2,]) ~ c(1:2), family=binomial))
  log.odds.ratios <- -sapply(glms, coefficients)[2,]
  
  # calculate log-likelihood values for each 2x2 matrix
  log.likelihood.values <- sapply(glms, "[[", "null.deviance")
  
  # calculate MI scores for each 2x2 matrix
  mi.scores <- sapply(all.2.by.2.matrices,
                      \(af) log2(af[1,1] / chisq.test(af, correct=FALSE)$exp[1,1]))
  
  # calculate delta p values for each 2x2 matrix
  delta.p.constr.cues.word <- sapply(all.2.by.2.matrices,
                                     \(af) af[1,1]/sum(af[,1]) - af[1,2]/sum(af[,2]))
  delta.p.word.cues.constr <- sapply(all.2.by.2.matrices,
                                     \(af) af[1,1]/sum(af[1,]) - af[2,1]/sum(af[2,]))
  # determine whether each word-construction pair is associated or not
  relations <- sapply(pearson.residuals,
                      \(af) switch(sign(af)+2, construction2.name, "chance", construction1.name))
  
  
  # output
  output.table <- data.frame(WORD=rownames(input.matrix), CONSTRUCTION1=input.matrix[,1], CONSTRUCTION2=input.matrix[,2], row.names=NULL)
  # This line creates a dataframe with three columns: WORD, CONSTRUCTION1 and CONSTRUCTION2. The values in the WORD column are the row names of the input.matrix dataframe. 
  output.table <- data.frame(output.table, PREF=relations, LLR=log.likelihood.values, PRES=pearson.residuals,
                             LOR=log.odds.ratios, MI=mi.scores,
                             DPC2W=delta.p.constr.cues.word, DPW2C=delta.p.word.cues.constr, row.names=NULL)
  # This line adds additional columns to the output.table dataframe: PREFERENCE, LLR, PEARSONRESID, LOGODDSRATIO, MI, DELTAPC2W, and DELTAPW2C.
  assoc <- cbind(log.likelihood.values, pearson.residuals, log.odds.ratios, mi.scores, delta.p.constr.cues.word, delta.p.word.cues.constr)
  
  if (fye.mpfr=="yes") {
    output.table <- data.frame(output.table,
                               # FYE=sapply(FYE.values, formatMpfr, digits=12))
                               FYE=sapply(sapply(FYE.values, \(af) -log10(af)), asNumeric))
    fisher.scores <- sapply(sapply(FYE.values, \(af) -log10(af)), asNumeric)
    assoc <- cbind(log.likelihood.values, pearson.residuals, log.odds.ratios, mi.scores, delta.p.constr.cues.word, delta.p.word.cues.constr, fisher.scores)
  }
  # If fye.mpfr is set to "yes" then this will add FYE column to output.table dataframe.
  
  colnames(output.table)[2:3] <- c(construction1.name, construction2.name)
  # This line changes the column names of CONSTRUCTION1 and CONSTRUCTION2 to the values of construction2.name and construction1.name respectively.
  
  output.table <- output.table[order(output.table$PREF, -output.table$LOR),]
  # This line orders the output.table dataframe by the values in PREFERENCE column in ascending order and LOGODDSRATIO in descending order.
  
  write.table(output.table, file=file.path(file_output), sep="\t", row.names=FALSE, col.names=TRUE, quote=FALSE)
  # This line saves the output.table dataframe to a tab-separated file in file_output path with the row names and column names in the file.
  
  cat("\n\nThe results are in the file called ", basename(file_output), "and can be found in: ", file_output, ".\n")
  
  plot(log2(output.table[,2]+output.table[,3]), output.table$LOR, type="n",
       xlab="Logged co-occurrence frequency", ylab="Association (log odds ratio)")
  grid(); abline(h=0, lty=2); abline(v=0, lty=2)
  text(log2(output.table[,2]+output.table[,3]), output.table$LOR, output.table$WORD, font=1)
  
  assoc.cor <- cor(assoc, method="kendall")
  assoc.cor <- round(assoc.cor, 3)
  write.table(assoc.cor, file=file.path(project_dir, "results_analysis", "reproduced_analyses", str_glue("assoc_cor_{basename(file_output)}.csv")), sep="\t", row.names=TRUE, col.names=NA, quote=FALSE)
  # corrgram(assoc, order = TRUE, lower.panel = panel.shade, upper.panel = panel.pie)
  # corrgram(assoc, order = TRUE, lower.panel = panel.ellipse, upper.panel = panel.pts)
  
}   

dist.collexemes()

dist.collexemes()

