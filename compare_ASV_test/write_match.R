setwd(dirname(rstudioapi::getSourceEditorContext()$path))

require(data.table)
require(Rcpp)



sourceCpp("compare_ASV_test/rcpp_seq_match_test.cpp")
test_match(asvs[[pairs[,run][1]]][1:5,1:5], asvs[[pairs[,run][2]]][1:6,1:5])

asvs[[pairs[,run][1]]][1:5,1:5][,1]
