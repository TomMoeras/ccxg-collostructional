source("coll.analysis.r")

dist.collexemes <- function(precbitsexponent = precbitsexponent) { 
  options(warn = -1)
  dists <- 1 # remove menu option
  input.dc <- 1 # remove menu option
  fye.mpfr <- "no" # remove menu option
  input.matrix <- read.table(file.choose(), header = TRUE, sep = "\t", quote = "", comment.char = "")
  if (input.dc == 1) { # DCA
    interim <- t(table(input.matrix))
    input.matrix <- data.frame(
      as.vector(interim[,1]),
      as.vector(interim[,2]), row.names = rownames(interim))
    colnames(input.matrix) <- colnames(interim)
  } else {
    temp <- colnames(input.matrix)[2:3]
    input.matrix <- data.frame(
      as.vector(input.matrix[,2]),
      as.vector(input.matrix[,3]), row.names = input.matrix[,1])
    colnames(input.matrix) <- temp
  }
  construction1.name <- colnames(input.matrix)[1]; construction2.name <- colnames(input.matrix)[2]
  
  # computation
  options(warn=-1)
  pearson.residuals <- chisq.test(input.matrix, correct=FALSE)$residuals[,1]
  
  all.2.by.2.matrices <- apply(
    input.matrix, 1,
    \(af) { matrix(c(af, colSums(input.matrix)-af), byrow=TRUE, ncol=2) },
    simplify=FALSE)
  
  if (fye.mpfr=="yes") {
    FYE.values <- lapply(all.2.by.2.matrices,
                         \(af) fisher.test.mpfr(af))
  }
  glms <- lapply(all.2.by.2.matrices,
                 \(af) glm(rbind(af[1,], af[2,]) ~ c(1:2), family=binomial))
  log.odds.ratios <- -sapply(glms, coefficients)[2,]
  log.likelihood.values <- sapply(glms, "[[", "null.deviance")
  mi.scores <- sapply(all.2.by.2.matrices,
                      \(af) log2(af[1,1] / chisq.test(af, correct=FALSE)$exp[1,1]))
  delta.p.constr.cues.word <- sapply(all.2.by.2.matrices,
                                     \(af) af[1,1]/sum(af[,1]) - af[1,2]/sum(af[,2]))
  delta.p.word.cues.constr <- sapply(all.2.by.2.matrices,
                                     \(af) af[1,1]/sum(af[1,]) - af[2,1]/sum(af[2,]))
  relations <- sapply(pearson.residuals,
                      \(af) switch(sign(af)+2, construction2.name, "chance", construction1.name))
  
  # output
  output.table <- data.frame(WORD=rownames(input.matrix), CONSTRUCTION1=input.matrix[,1], CONSTRUCTION2=input.matrix[,2], row.names=NULL)
  output.table <- data.frame(output.table, PREFERENCE=relations, LLR=log.likelihood.values, PEARSONRESID=pearson.residuals,
                             LOGODDSRATIO=log.odds.ratios, MI=mi.scores,
                             DELTAPC2W=delta.p.constr.cues.word, DELTAPW2C=delta.p.word.cues.constr, row.names=NULL)
  if (fye.mpfr=="yes") {
    output.table <- data.frame(output.table,
                               # FYE=sapply(FYE.values, formatMpfr, digits=12))
                               FYE=sapply(sapply(FYE.values, \(af) -log10(af)), asNumeric))
  }
  colnames(output.table)[2:3] <- c(construction1.name, construction2.name)
  output.table <- output.table[order(output.table$PREFERENCE, -output.table$LOGODDSRATIO),]
  write.table(output.table, file=save.date <- gsub(":", "-", paste0(Sys.time(), ".csv")), sep="\t", row.names=FALSE, col.names=TRUE, quote=FALSE)
  cat("\n\nThe results are in the file called ", save.date, ".\n")
  
  plot(log2(output.table[,2]+output.table[,3]), output.table$LOGODDSRATIO, type="n",
       xlab="Logged co-occurrence frequency", ylab="Association (log odds ratio)")
  grid(); abline(h=0, lty=2); abline(v=0, lty=2)
  text(log2(output.table[,2]+output.table[,3]), output.table$LOGODDSRATIO, output.table$WORD, font=3)
}

dist.collexemes()