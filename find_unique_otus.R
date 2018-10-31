nashua <- readRDS("data/nashua.column.raw.otu.taxa.RDS")
pitfoam <- readRDS("data/pitfom.RDS")

phyloseq_objects <- list(nashua, pitfoam)
columns <- c("matrix", NA)
treatments <- c("manure", NA)

find_unique_otus <- function(..., columns, treatments){
  require(phyloseq)
  source("../phyloseq_scripts/find_phyloseq_generalists.R")
  phyloseq_objects <- list(...)
  p_objects_names <- sapply(substitute(list(...))[-1], deparse)
  
  for(dataset in 1:length(phyloseq_objects)){
    sample_names(phyloseq_objects[[dataset]]) <- paste0(p_objects_names[dataset], "_", sample_names(phyloseq_objects[[dataset]]))
    taxa_names(phyloseq_objects[[dataset]]) <- paste0(p_objects_names[dataset], "_", taxa_names(phyloseq_objects[[dataset]]))
    if(is.na(columns[dataset])){
      sources <- find_generalists(phyloseq_objects[[dataset]])
      if(sum(!(sample_names(phyloseq_objects[[dataset]]) %in% sample_names(sources))) != 0){non_sources <- subset_samples(phyloseq_objects[[dataset]], !(sample_names(phyloseq_objects[[dataset]]) %in% sample_names(sources)))
      } else {non_sources <- NULL}
    } else {
      sources <- find_generalists(phyloseq_objects[[dataset]], treatments = as.character(columns[dataset]), subset = treatments[dataset])
      if(sum(!(sample_names(phyloseq_objects[[dataset]]) %in% sample_names(sources))) != 0){non_sources <- subset_samples(phyloseq_objects[[dataset]], !(sample_names(phyloseq_objects[[dataset]]) %in% sample_names(sources)))
      } else {non_sources <- NULL}
    }
    if(dataset == 1){
      source_otus <- sources
      non_source_otus <- non_sources
    } else {
      if(sum(length(source_otus), length(sources)) > 0){
        source_otus <- merge_phyloseq(source_otus, sources)
      } else {source_otus <- source_otus}
      source_otus <- merge_phyloseq(source_otus, sources)
      if(sum(length(non_source_otus), length(non_sources)) > 0){
        non_source_otus <- merge_phyloseq(non_source_otus, non_sources)
      } else {non_source_otus <- non_source_otus}
    }
  }
  taxa_names(source_otus) %in% taxa_names(non_source_otus)
  source_otus <- subset_taxa(source_otus, (!(taxa_names(source_otus) %in% taxa_names(non_source_otus))))
  source_otus <- tax_glom(source_otus, taxrank = rank_names(source_otus)[length(rank_names(source_otus))])
}

find_unique_otus(nashua, source = "manure")


