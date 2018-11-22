setwd(dirname(rstudioapi::getSourceEditorContext()$path))

require(data.table)
require(Rcpp)



sourceCpp("compare_ASV_test/rcpp_seq_match_test.cpp");test_match(asvs[[pairs[,run][1]]][1:2694,], asvs[[pairs[,run][2]]][1:2694,])
dup_rows <- test_match(asvs[[pairs[,run][1]]][1:2694,], asvs[[pairs[,run][2]]][1:2694,])
test <- test_match(asvs[[pairs[,run][1]]][1:2694,], asvs[[pairs[,run][2]]][1:2694,])
c(dup_rows)
unlist(c(asvs[[pairs[,run][2]]][226,]))
test[2265,]
unlist(c(test[2,1:10]))
unlist(c(test[2350,1:10]))
unlist(c(test[2694,1:10]))
unlist(c(test[4193,1:10]))


### Find which rows are repeated, test to see if they combine abundances correctly

a <- test_match(asvs[[pairs[,run][1]]], asvs[[pairs[,run][2]]])
                