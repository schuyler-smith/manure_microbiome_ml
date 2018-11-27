merge_asvs <- function(...){
  options(warn=1)
  require(phyloseq);require(Rcpp);require(RcppParallel)
  sourceCpp("~/Dropbox/phyloseq_scripts/rcpp_seq_match.cpp")
  
  phyloseq_objects <- list(...)
  p_objects_names <- sapply(substitute(list(...))[-1], deparse)
  names(phyloseq_objects) <- p_objects_names

  asvs <- lapply(phyloseq_objects, otu_table)
  read_size_order <- order(unlist(lapply(lapply(asvs, FUN = function(x){rownames(x)[1]}), FUN = function(seq){mean(length(strsplit(seq, "")[[1]]))})))
  asvs <- asvs[read_size_order]

  pairs <- combn(names(asvs), m = 2)
  for(run in 1:dim(pairs)[2]){
    # Sys.setenv("OMP_NUM_THREADS"="8")
    # Sys.setenv("PKG_CXXFLAGS"=" -fopenmp")
    asvs[[pairs[,run][2]]] <- match_sequences(asvs[[pairs[,run][1]]], asvs[[pairs[,run][2]]])
  }
  all_taxa <- eval(parse(text=paste0("rbind(", paste0("tax_table(",p_objects_names,")", collapse = ", "), ")")))
  for(name in names(asvs)){
    phyloseq_objects[[name]] <- phyloseq(otu_table(asvs[[name]], taxa_are_rows = TRUE), 
                            tax_table(all_taxa[rownames(all_taxa) %in% rownames(asvs[[name]]),]), 
                            sample_data(sample_data(phyloseq_objects[[name]])))
  }
  return(phyloseq_objects)
}

  
  
  
  
  
  
  
  
  
  
  
  