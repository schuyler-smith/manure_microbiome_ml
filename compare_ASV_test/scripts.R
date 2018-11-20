# (...){
  options(warn=1)
  require(phyloseq);require(Rcpp)
  sourceCpp("compare_ASV_test/rcpp_seq_match.cpp")
  
  phyloseq_objects <- list(...)
  p_objects_names <- sapply(substitute(list(...))[-1], deparse)

  phyloseq_objects <- list(readRDS("~/Dropbox/manure_ml/compare_ASV_test/pitfoam.RDS"), readRDS("~/Dropbox/manure_ml/compare_ASV_test/nashua.RDS"))
  p_objects_names <- c("pitfoam", "nashua")
  names(phyloseq_objects) <- p_objects_names

  asvs <- lapply(phyloseq_objects, otu_table)
  read_size_order <- order(unlist(lapply(lapply(asvs, FUN = function(x){rownames(x)[1]}), FUN = function(seq){mean(length(strsplit(seq, "")[[1]]))})))
  asvs <- asvs[read_size_order]
  
  pairs <- combn(names(asvs), m = 2)
  

  
  
  for(run in 1:dim(pairs)[2]){
    # asvs[[pairs[,run][2]]] <- match_seqs(asvs[[pairs[,run][1]]], asvs[[pairs[,run][2]]])
    test <- match_seqs(asvs[[pairs[,run][1]]], asvs[[pairs[,run][2]]])
    table(table(test)[table(test) > 1])
    table(table(test)[table(test) > 43])
    test[1:10]
    a <- which(test == "TACGGAGGATCCGAGCGTTATCCGGATTTATTGGGTTTAAAGGGTGCGCAGGCGGAATATTAAGTCGGCGGTGAAAGTTTGCAGCTTAACTGTAAAATTGCCGTTGATACTGGTATTCTTGAGTGTATATGAAGTAGGCGGAATTTGTAGTGTAGCGGTGAAATGCATAGATATTACAAGGAACTCCGATTGCGAAGGCAGCTTACTAAATTACAACTGACGCTTAGGCACGAAGGCGTGGGTATCAAACAGG")
    tax_table(phyloseq_objects$pitfoam)[a]
    # match_seqs(asvs[[pairs[,run][1]]][1:20], asvs[[pairs[,run][2]]][1:20])
  }
  
  for(name in names(asvs)){
    taxa_names(phyloseq_objects[[name]]) <- asvs[[name]]
  }
