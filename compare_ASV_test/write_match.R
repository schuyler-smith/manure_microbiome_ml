setwd(dirname(rstudioapi::getSourceEditorContext()$path))

require(data.table)
require(Rcpp)



sourceCpp("rcpp_match.cpp")

match_seqs(asvs$nashua, asvs$pitfoam)
