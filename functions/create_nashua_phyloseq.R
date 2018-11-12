otu <- readRDS("data/nash_seq_table.RDS")
tax <- readRDS("data/nash_tax_table.RDS")
sampled <- sample_data(readRDS("data/nashua.column.raw.otu.taxa.RDS"))
snames <- unlist(lapply(strsplit(as.character(sampled$origin_id), split = "_"), `[[`, 1))

nashua <- phyloseq(otu_table(otu, taxa_are_rows = TRUE), tax_table(tax), sample_data(sampled))
