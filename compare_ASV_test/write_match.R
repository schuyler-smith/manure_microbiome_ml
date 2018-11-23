setwd(dirname(rstudioapi::getSourceEditorContext()$path))

require(data.table)
require(Rcpp)

in1 <-asvs[[pairs[,run][1]]][1:2694,]
in2 <- asvs[[pairs[,run][2]]][1:2694,]

df1 <- data.frame(a = list(1,0,0,0,2), b = list(1,2,1,0,2), c = list(1,1,0,0,2), d = list(1,0,0,1,2), e = list(1,0,0,0,2))
rownames(df1) <- c("abc", "def", "ghi", "jkl", "mno")
df2 <- data.frame(a = c(1,0,0,0,2), b = c(27,0,1,5,10), c = c(0,1,23,22,9), d = c(1,1,1,1,1), e = c(2,4,6,8,10))
rownames(df2) <- c("abcd", "defg", "ghij", "jklm", "mnop")

sourceCpp("compare_ASV_test/rcpp_seq_match_test.cpp");test2 <- test_match(df1, df2)
table(table(test)[table(test) > 1])

unlist(c(asvs[[pairs[,run][2]]][1:5,]))
unlist(c(test[2,1:10]))
unlist(c(test[2350,1:10]))
unlist(c(test[2694,1:10]))
unlist(c(test[4193,1:10]))


### Find which rows are repeated, test to see if they combine abundances correctly

a <- test_match(asvs[[pairs[,run][1]]], asvs[[pairs[,run][2]]])
                


ifelse(is.na(match(paste0(unlist(c(asvs[[pairs[,run][2]]][70,]))), paste0(df2$pnr, df2$drug))),"No", "Yes")