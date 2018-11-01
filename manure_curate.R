.cran_packages <- c("data.table", "e1071", "ggplot2", "RColorBrewer", "rpart", "GGally", "intergraph", "sna")
.bioc_packages <- c("igraph","phyloseq","bioDist","dada2")
.inst <- .cran_packages %in% installed.packages()
if(any(!.inst)) {install.packages(.cran_packages[!.inst])};.inst <- .bioc_packages %in% installed.packages()
if(any(!.inst)) {source("http://bioconductor.org/biocLite.R"); biocLite(.bioc_packages[!.inst], ask = F)}
sapply(c(.cran_packages, .bioc_packages), require, character.only = TRUE)

source("create_pan_microbiome.R")
source("../phyloseq_scripts/find_phyloseq_generalists.R")

nashua <- readRDS("data/nashua.column.raw.otu.taxa.RDS")
pitfoam <- readRDS("data/pitfom.RDS")

panmb <- create_panmicrobiome(nashua, pitfoam, columns = c("matrix", NA), treatments = c("manure", NA))
panmb <- readRDS("data/panmb.RDS")


find_generalists(nashua, frequency = 1, treatments = "matrix", subset = "manure")
find_generalists(pitfoam, frequency = 1)
find_generalists(panmb, frequency = .99, drop_samples = TRUE)


