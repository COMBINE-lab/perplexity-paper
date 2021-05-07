library(TxDb.Hsapiens.UCSC.hg19.knownGene)
library(readr)
# library("tximport")
# library("tximportData")
# library("DESeq2")
library("argparser")
library("tximeta")
library("fishpond")

# hg19_tx2gene <- function() {
#   txidir <- system.file("extdata", package = "tximportData")
#   tx2gene <- read_csv(file.path(txidir, "tx2gene.gencode.v27.csv"))
#   return(tx2gene)
# }

swish_from_files <- function(A_files, B_files, A_cond, B_cond) {
  conditions <- rep(c(A_cond, B_cond), times = c(length(A_files), length(B_files)))
  files <-  c(A_files, B_files)
#   txi <- tximport(files, type = "salmon", txOut = TRUE)
  coldata <- data.frame(names=files, files=files, condition=conditions)
  print(coldata)
  se <- tximeta(coldata)
  print(se)
  #print(assayNames(se))
  se$condition <- factor(se$condition, c("A", "B"))
  #print(rowRanges(se))
  y <- scaleInfReps(se)
  print(y)
  y <- labelKeep(y)
  set.seed(1)
  y <- swish(y, x='condition')
  print(y)
  return(y)
#   dds <- DESeqDataSetFromTximport(txi, colData = coldata, design = ~ condition)
#   dds <- DESeq(dds)
#   return(dds)
}

main <- function() {
  p <- arg_parser("DESeq")
  p <- add_argument(p, "--A_files", nargs=Inf, type="character", help = "A files")
  p <- add_argument(p, "--B_files", nargs=Inf, type="character", help = "B files")
  p <- add_argument(p, "--A_cond", type="character", help = "A cond name")
  p <- add_argument(p, "--B_cond", type="character", help = "B cond name")
  p <- add_argument(p, '--output', help = "results output")
  args <- parse_args(p)
  
  y <- swish_from_files(args$A_files, args$B_files, args$A_cond, args$B_cond)
  
  res <-mcols(y)
  print(t)
#   res <- results(dds)
#   res <- res[order(res$padj), ]
#   res <- res[!is.na(res$padj), ]
#   res <- res[res$padj < 0.9, ]
  
#   cat(summary(res))
  
  write.table(res, file=args$output, quote=FALSE, sep='\t')
}

main()
