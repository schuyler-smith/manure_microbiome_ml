create_panmicrobiome <- function(..., columns, treatments, agglomerate = TRUE, frequency = 0){
  options(warn=1)
  require(phyloseq)
  source("../phyloseq_scripts/find_phyloseq_generalists.R")
  phyloseq_objects <- list(...)
  p_objects_names <- sapply(substitute(list(...))[-1], deparse)
  
  for(dataset in 1:length(phyloseq_objects)){ 
    phy.obj <- phyloseq_objects[[dataset]]
    phy.name <- p_objects_names[dataset]
    sample_names(phy.obj) <- paste0(phy.name, "_", sample_names(phy.obj))
    taxa_names(phy.obj) <- paste0(phy.name, "_", taxa_names(phy.obj))
    
    if(is.na(columns[dataset])){
      sources <- find_generalists(phy.obj)
    } else { sources <- find_generalists(phy.obj, treatments = columns[dataset], subset = treatments[dataset]) }
    
    # num_non_source <- !(sample_names(phy.obj) %in% sample_names(sources))
    # if(sum(num_non_source) == 0){ 
    #   non_sources <- NULL
    # } else {non_sources <- prune_samples(num_non_source, phy.obj)}
    
    if(dataset == 1){
      source_otus <- sources
      # non_source_otus <- non_sources
    } else {
      if(sum(length(source_otus), length(sources)) > 0){
        source_otus <- merge_phyloseq(source_otus, sources)
      }
      # if(sum(length(non_source_otus), length(non_sources)) > 0){
      #   non_source_otus <- merge_phyloseq(non_source_otus, non_sources)
      # }
    }
  }
  if(agglomerate != FALSE){
    warning("WARNING: agglomerate is set as TRUE. This operation combines practically identical OTUS, which I recommend doing for OTUs from datasets called independently, however this may take a few moments.")
    source_otus <- tax_glom(source_otus, taxrank = rank_names(source_otus)[length(rank_names(source_otus))])}
  source_otus <- find_generalists(source_otus, frequency = frequency, drop_samples = TRUE)
  return(source_otus)
}


