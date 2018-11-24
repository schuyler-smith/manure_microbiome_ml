setwd(dirname(rstudioapi::getSourceEditorContext()$path))

require(data.table)
require(Rcpp)

df1 <- asvs[[pairs[,run][1]]][1:6,1:10]
df2 <- asvs[[pairs[,run][2]]][1:6,1:10]

rownames(df1) <- c("abc", "def", "ghi", "jkl", "mno", "pqr")
rownames(df2) <- c("abcd", "defg", "ghij", "abcm", "abcp", "pqrs")
df1[1,] <- rep(1,10);df1[2,] <- rep(2,10);df1[3,] <- rep(3,10);df1[4,] <- rep(4,10);df1[5,] <- rep(5,10);df1[6,] <- rep(6,10)
df2[1,] <- rep(1,10);df2[2,] <- rep(2,10);df2[3,] <- rep(3,10);df2[4,] <- rep(4,10);df2[5,] <- rep(5,10);df2[6,] <- rep(6,10)

Sys.setenv("OMP_NUM_THREADS"="4")
Sys.setenv("PKG_CXXFLAGS"=" -fopenmp")
sourceCpp("compare_ASV_test/rcpp_seq_match_test.cpp");  test_match(df1, df2)
test <- test_match(df1, df2)
table(table(rownames(test))[table(rownames(test)) > 0])


