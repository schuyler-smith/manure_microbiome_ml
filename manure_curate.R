library(phyloseq)

source("~/Dropbox/scripts/find_phyloseq_generalists.R")

nashua <- sample_data(subset_samples(readRDS("nashua.column.raw.otu.taxa.RDS"), (matrix == "manure")))
