
library(e1071)
library(rpart)
library(phyloseq)

source("~/Dropbox/scripts/find_phyloseq_generalists.R")

phylo_obj <- readRDS("nashua.column.raw.otu.taxa.RDS")

possitive <- "Ma"
negative <- "Co"
treatment <- "manure_history"
optimization = FALSE
cost = 1
gamma = 0.1

### NORMALIZE FIRST WITH RELATIVE ABUNDANCE?

# Extract abundance matrix from the phyloseq object
filtered_data <- find_generalists(phylo_obj, 0.001)
manure <- sample_data(subset_samples(phylo_obj, (matrix == "manure")))
abundance_table = as(otu_table(filtered_data), "matrix");if(taxa_are_rows(filtered_data)){abundance_table <- t(abundance_table)}

# create SVM learning sets
abundance_table <- cbind(sample_data(filtered_data)[,treatment], abundance_table)
abundance_table <- subset(abundance_table, (abundance_table[,treatment] %in% c(possitive, negative)))
colnames(abundance_table)[1] <- "classification"

index <- 1:nrow(abundance_table)
testindex <- sample(index, trunc(length(index)/3))
testset <- abundance_table[testindex,]
trainset <- abundance_table[-testindex,]

svm.model <- svm(classification ~ ., data = trainset, cost = 1, gamma = 0.00007)
svm.pred <- predict(svm.model, subset(testset, select=-c(classification)))
table(pred = svm.pred, true = testset[,"classification"])




filtered_data <- find_generalists(phylo_obj, 0.2)
abundance_table = as(otu_table(filtered_data), "matrix");if(taxa_are_rows(filtered_data)){abundance_table <- t(abundance_table)}
abundance_table <- cbind(sample_data(filtered_data)[,treatment], abundance_table)
abundance_table <- subset(abundance_table, (abundance_table[,treatment] %in% c(possitive, negative)))
colnames(abundance_table)[1] <- "classification"

index <- 1:nrow(abundance_table)
testindex <- sample(index, trunc(length(index)/3))
testset <- abundance_table[testindex,]
trainset <- abundance_table[-testindex,]

cost <- c(0.1, 1, 10)
gamma <- c(0.1, 1, 10)

while(length(cost) > 1 | length(gamma) > 1){
  svm_tune <- tune(svm, train.x=subset(trainset, select=-c(classification)), train.y=trainset[,"classification"],
                ranges=list(cost=cost, gamma=gamma)); print(svm_tune)
  best.cost <- svm_tune$best.parameters$cost
  best.gamma <- svm_tune$best.parameters$gamma

  if(length(cost) == 1){cost<-cost}else{if(best.cost == cost[2]){cost <- cost[2]}else{cost <- c(best.cost/10, best.cost, best.cost * 2)}}
  if(length(gamma) == 1){gamma<-gamma}else{if(best.gamma == gamma[2]){gamma <- gamma[2]}else{gamma <- c(best.gamma/10, best.gamma, best.gamma *5)}}
}

filtered_data <- find_generalists(phylo_obj, 0.05)
abundance_table = as(otu_table(filtered_data), "matrix");if(taxa_are_rows(filtered_data)){abundance_table <- t(abundance_table)}
abundance_table <- cbind(sample_data(filtered_data)[,treatment], abundance_table)
abundance_table <- subset(abundance_table, (abundance_table[,treatment] %in% c(possitive, negative)))
colnames(abundance_table)[1] <- "classification"

index <- 1:nrow(abundance_table)
testindex <- sample(index, trunc(length(index)/3))
testset <- abundance_table[testindex,]
trainset <- abundance_table[-testindex,]

svm.model <- svm(classification ~ ., data = trainset, cost = best.cost, gamma = best.gamma)
svm.pred <- predict(svm.model, subset(testset, select=-c(classification)))
table(pred = svm.pred, true = testset[,"classification"])





pkgs <- c('foreach', 'doParallel')
lapply(pkgs, require, character.only = T)
registerDoParallel(cores = 6)

fml <- as.formula(paste("classification ~ ."))
### SPLIT DATA INTO K FOLDS ###
set.seed(1390)
abundance_table$fold <- caret::createFolds(1:nrow(abundance_table), k = 10, list = FALSE)

### PARAMETER LIST ###
cost <- c(10)
gamma <- c(0.000000001, 0.00000001, 0.0000001, 0.000001, 0.00001, 0.0001, 0.001 ,0.01, 0.1, 1)
parms <- expand.grid(cost = cost, gamma = gamma)

### LOOP THROUGH PARAMETER VALUES ###
results <- foreach(i = 1:nrow(parms), .combine = rbind) %do% {
  c <- parms[i, ]$cost
  g <- parms[i, ]$gamma
  ### K-FOLD VALIDATION ###
  out <- foreach(j = 1:max(abundance_table$fold), .combine = rbind, .inorder = FALSE) %dopar% {
    deve <- abundance_table[abundance_table$fold != j, ]
    test <- abundance_table[abundance_table$fold == j, ]
    mdl <- e1071::svm(fml, data = subset(deve, select=-c(fold)), type = "C-classification", kernel = "radial", cost = c, gamma = g, probability = TRUE)
    pred <- predict(mdl, test, decision.values = TRUE, probability = TRUE)
    data.frame(y = test$classification, prob = attributes(pred)$probabilities[, 2])
  }
  ### CALCULATE SVM PERFORMANCE ###
  roc <- pROC::roc(as.factor(out$y), out$prob) 
  data.frame(parms[i, ], roc = roc$auc[1])
}; print(results)











# rpart.model <- rpart(classification ~ ., data = trainset)
# rpart.pred <- predict(rpart.model, subset(testset, select=-c(classification)), type = "class")
# table(pred = rpart.pred, true = testset[,"classification"])

