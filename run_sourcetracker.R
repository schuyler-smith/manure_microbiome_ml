library(phyloseq)
library(ggplot2)

possitive <- "Ma"
negative <- "Co"

source <- "manure_history"
treatment <- "matrix"

raw_phylo <- readRDS("nashua.column.raw.otu.taxa.RDS")
phylo_obj <- raw_phylo
colnames(sample_data(phylo_obj))[colnames(sample_data(phylo_obj))==treatment] = "Env"
colnames(sample_data(phylo_obj))[colnames(sample_data(phylo_obj))==source] = "SourceSink"
sample_data(phylo_obj)$SourceSink = as.character(sample_data(phylo_obj)$SourceSink)
sample_data(phylo_obj)$SourceSink[sample_data(phylo_obj)$SourceSink %in% c(possitive, negative)] = "sink"
sample_data(phylo_obj)$SourceSink[sample_data(phylo_obj)$SourceSink != "sink"] = "source"
sample_data(phylo_obj)$SourceSink = as.factor(sample_data(phylo_obj)$SourceSink)

metadata <- cbind(sample = rownames(sample_data(phylo_obj)), sample_data(phylo_obj))
otus <- cbind(otu = rownames(otu_table(phylo_obj)), otu_table(phylo_obj))
otus <- rbind("", colnames(otus), otus)
write.table(metadata, "SourceTtracker/meta_data.txt", sep="\t", quote=FALSE, row.names=FALSE)
write.table(otus, "SourceTtracker/otus.txt", sep="\t", quote=FALSE, row.names=FALSE, col.names=FALSE)


####### Results

load("SourceTtracker/output/results.RData")

SourceTracker_Predictions <- merge(sample_data(raw_phylo), results$proportions, by="row.names", all.x=TRUE)
SourceTracker_Predictions <- SourceTracker_Predictions[SourceTracker_Predictions$manure_history %in% c(possitive, negative),]

p <- ggplot(SourceTracker_Predictions, aes(x = as.factor(Row.names), y = manure, fill = matrix))
p <- p + geom_bar(stat = "identity", width = 0.5)
p <- p + facet_grid(. ~ experiment_day, space = "free", scales = "free")
p <- p + theme_bw()
p <- p + ylab("Proportion or Likelihood of Manure")
p <- p + theme(axis.title.x=element_blank(),
            axis.ticks.x=element_blank())
p <- p + theme(legend.key.size = unit(0.5,"line"))
p <- p + guides(fill=guide_legend(ncol=1))
p

head(SourceTracker_Predictions)



