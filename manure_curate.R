

source("../phyloseq_scripts/merge_ASVs.R")
source("../phyloseq_scripts/find_phyloseq_generalists.R")

nashua <- readRDS("data/nashua.RDS")
pitfoam <- readRDS("data/pitfoam.RDS")

merged_asvs <- merge_asvs(nashua, pitfoam)
sum(taxa_names(merged_asvs$nashua) %in% taxa_names(merged_asvs$pitfoam))
merged_phyloseq <- eval(parse(text=paste0("merge_phyloseq(", paste0("merged_asvs$",names(merged_asvs), collapse = ", "), ")")))


find_generalists(merged_phyloseq, frequency = .1)


