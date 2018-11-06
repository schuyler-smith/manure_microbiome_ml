.cran_packages <- c("data.table", "e1071", "ggplot2", "RColorBrewer", "rpart", "GGally", "intergraph", "sna")
.bioc_packages <- c("igraph","phyloseq","bioDist","dada2")
.inst <- .cran_packages %in% installed.packages()
if(any(!.inst)) {install.packages(.cran_packages[!.inst])};.inst <- .bioc_packages %in% installed.packages()
if(any(!.inst)) {source("http://bioconductor.org/biocLite.R"); biocLite(.bioc_packages[!.inst], ask = F)}
sapply(c(.cran_packages, .bioc_packages), require, character.only = TRUE)
# devtools::install_github("benjjneb/dada2"); library(dada2)

source("create_pan_microbiome.R")
source("../phyloseq_scripts/find_phyloseq_generalists.R")
set.seed(1390)

path <- "~/Desktop/da2_test/unassembled"
fnFs <- sort(list.files(path, pattern="_R1_", full.names = TRUE)); fnRs <- sort(list.files(path, pattern="_R2_", full.names = TRUE))
sample.names <- sapply(strsplit(basename(fnFs), "_"), `[`, 1); number_samples <- length(sample.names)
filtFs <- file.path(path, "filtered", paste0(sample.names, "_F_filt.fastq.gz")); filtRs <- file.path(path, "filtered", paste0(sample.names, "_R_filt.fastq.gz"))
names(filtFs) <- sample.names; names(filtRs) <- sample.names
# out <- filterAndTrim(fwd = fnFs, filt = filtFs, rev = fnRs, filt.rev = filtRs, truncLen=c(240,200), maxLen = 260, truncQ=2, rm.phix=TRUE, compress=TRUE, multithread=TRUE) # On Windows set multithread=FALSE
out <- readRDS("data/out.RDS")
# errF <- learnErrors(filtFs, multithread=TRUE, randomize = TRUE);errR <- learnErrors(filtRs, multithread=TRUE, randomize = TRUE)
errF <- readRDS("data/errF.RDS");errR <- readRDS("data/errR.RDS")
merged_reads <- vector("list", length(sample.names)); names(merged_reads) <- sample.names

for(sample in sample.names) {
  if(sample == sample.names[1]){n = 1}
  derepFs <- derepFastq(filtFs[[sample]], verbose = FALSE); derepRs <- derepFastq(filtRs[[sample]], verbose = FALSE)
  dadaFs <- dada(derepFs, err = errF, multithread = TRUE, verbose = FALSE)
  dadaRs <- dada(derepRs, err = errR, multithread = TRUE, verbose = FALSE)
  merged_reads[[sample]] <- mergePairs(dadaFs, derepFs, dadaRs, derepRs, verbose = FALSE)
  print(paste("Sample",sample,n,"of",number_samples,"(",(round(n/number_samples,4)*100),"%) processed.",format(object.size(merged_reads), units = "GB"), sep = " "));n = n + 1
}

seqtab <- makeSequenceTable(merged_reads)



