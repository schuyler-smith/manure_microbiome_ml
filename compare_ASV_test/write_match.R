setwd(dirname(rstudioapi::getSourceEditorContext()$path))

require(phyloseq);require(Rcpp)
phyloseq_objects <- list(readRDS("~/Dropbox/manure_ml/compare_ASV_test/pitfoam.RDS"), readRDS("~/Dropbox/manure_ml/compare_ASV_test/nashua.RDS"))
p_objects_names <- c("pitfoam", "nashua")
names(phyloseq_objects) <- p_objects_names

asvs <- lapply(phyloseq_objects, otu_table)
read_size_order <- order(unlist(lapply(lapply(asvs, FUN = function(x){rownames(x)[1]}), FUN = function(seq){mean(length(strsplit(seq, "")[[1]]))})))
asvs <- asvs[read_size_order]

pairs <- combn(names(asvs), m = 2); run=1

df1 <- asvs[[pairs[,run][1]]][1:12,1:10]
df2 <- asvs[[pairs[,run][2]]][1:12,1:10]

rownames(df1) <- c("abc", "def", "ghi", "jkl", "mno", "pqr","abc", "def", "ghi", "jkl", "mno", "pqr")
rownames(df2) <- c("abcd", "defg", "ghij", "abcm", "abcp", "pqrs","aabcd", "adefg", "aghij", "aabcm", "aabcp", "apqrs")
df1[1,] <- rep(1,10);df1[2,] <- rep(2,10);df1[3,] <- rep(3,10);df1[4,] <- rep(4,10);df1[5,] <- rep(5,10);df1[6,] <- rep(6,10)
df1[7,] <- rep(1,10);df1[8,] <- rep(2,10);df1[9,] <- rep(3,10);df1[10,] <- rep(4,10);df1[11,] <- rep(5,10);df1[12,] <- rep(6,10)
df2[1,] <- rep(1,10);df2[2,] <- rep(2,10);df2[3,] <- rep(3,10);df2[4,] <- rep(4,10);df2[5,] <- rep(5,10);df2[6,] <- rep(6,10)
df2[7,] <- rep(1,10);df2[8,] <- rep(2,10);df2[9,] <- rep(3,10);df2[10,] <- rep(4,10);df2[11,] <- rep(5,10);df2[12,] <- rep(6,10)

Sys.setenv("OMP_NUM_THREADS"="4")
Sys.setenv("PKG_CXXFLAGS"=" -fopenmp")


sourceCpp("compare_ASV_test/rcpp_seq_match_test.cpp");  test_match(df1, df2)

test <- test_match(df1, df2)
table(table(rownames(test))[table(rownames(test)) > 0])


