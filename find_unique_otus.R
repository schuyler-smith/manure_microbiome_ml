nashua <- readRDS("data/nashua.column.raw.otu.taxa.RDS")
pitfoam <- readRDS("data/pitfom.RDS")

phyloseq_objects <- list(nashua, pitfoam)
columns <- c("matrix", NA)
treatments <- c("manure", NA)

find_unique_otus <- function(..., sources, treatments){
  require(phyloseq)
  source("~/Dropbox/phyloseq_scripts/find_phyloseq_generalists.R")
  for(dataset in 1:length(phyloseq_objects)){
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
  
  
  print(phyloseq_objects)
}

find_unique_otus(nashua, source = "manure")


manure_genes <- row.names(otu_table(find_generalists(phylo_object, treatments = "Treatment_Group", subset = "Manure-Control", frequency = 0)))
water_genes <- row.names(otu_table(find_generalists(phylo_object, treatments = "Treatment_Group", subset = "Effluent-Control", frequency = 0)))
soil_genes <- row.names(otu_table(find_generalists(phylo_object, treatments = "Treatment_Group", subset = "Soil-Control", frequency = 0)))
unique_manure_genes <- manure_genes[!(manure_genes %in% c(water_genes, soil_genes))]
