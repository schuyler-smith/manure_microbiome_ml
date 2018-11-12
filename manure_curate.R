.req_packages <- c("data.table", "ggplot2", "igraph", "phyloseq", "bioDist", "dada2")
sapply(.req_packages, require, character.only = TRUE)

source("create_pan_microbiome.R")
source("../phyloseq_scripts/find_phyloseq_generalists.R")

nashua <- readRDS("data/nashua.RDS")
pitfoam <- readRDS("data/pitfom.RDS")

panmb <- create_panmicrobiome(nashua, pitfoam, columns = c("matrix", NA), treatments = c("manure", NA))
panmb <- readRDS("data/panmb.RDS")


find_generalists(nashua, frequency = 1, treatments = "matrix", subset = "manure")
find_generalists(pitfoam, frequency = 1)
find_generalists(panmb, frequency = .99, drop_samples = TRUE)


