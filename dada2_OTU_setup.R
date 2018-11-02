.cran_packages <- c("data.table", "e1071", "ggplot2", "RColorBrewer", "rpart", "GGally", "intergraph", "sna")
.bioc_packages <- c("igraph","phyloseq","bioDist","dada2")
.inst <- .cran_packages %in% installed.packages()
if(any(!.inst)) {install.packages(.cran_packages[!.inst])};.inst <- .bioc_packages %in% installed.packages()
if(any(!.inst)) {source("http://bioconductor.org/biocLite.R"); biocLite(.bioc_packages[!.inst], ask = F)}
sapply(c(.cran_packages, .bioc_packages), require, character.only = TRUE)

source("create_pan_microbiome.R")
source("../phyloseq_scripts/find_phyloseq_generalists.R")

path <- "~/HPCC_Transfer/"
list.files(path)

# fnFs <- sort(list.files(path, pattern="_R1_001.fastq", full.names = TRUE))
# fnRs <- sort(list.files(path, pattern="_R2_001.fastq", full.names = TRUE))

fnFs <- sort(list.files(path, pattern="_L001", full.names = TRUE))

sample.names <- sapply(strsplit(basename(fnFs), "_"), `[`, 1)

plotQualityProfile(fnFs[1:2])



