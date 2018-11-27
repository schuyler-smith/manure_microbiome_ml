.req_packages <- c("data.table", "ggplot2", "igraph", "phyloseq", "bioDist", "dada2")
sapply(.req_packages, require, character.only = TRUE)

source("../phyloseq_scripts/merge_ASVs.R")
source("../phyloseq_scripts/find_phyloseq_generalists.R")

nashua <- readRDS("data/nashua.RDS")
pitfoam <- readRDS("data/pitfoam.RDS")

merged_asvs <- merge_asvs(nashua, pitfoam)
sum(taxa_names(merged_asvs$nashua) %in% taxa_names(merged_asvs$pitfoam))


find_generalists(nashua, frequency = 1, treatments = "matrix", subset = "manure")
find_generalists(pitfoam, frequency = 1)
find_generalists(panmb, frequency = .99, drop_samples = TRUE)


