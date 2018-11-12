library(dada2);library(data.table)
set.seed(1390)
CORES = 15
path <- "~/Projects/unassembled"

fnFs <- sort(list.files(path, pattern="_R1_", full.names = TRUE)); fnRs <- sort(list.files(path, pattern="_R2_", full.names = TRUE))
sample.names <- sapply(strsplit(basename(fnFs), "_"), `[`, 1); number_samples <- length(sample.names)
filtFs <- file.path(path, "../filtered", paste0(sample.names, "_F_filt.fastq.gz")); filtRs <- file.path(path, "../filtered", paste0(sample.names, "_R_filt.fastq.gz"))
names(filtFs) <- sample.names; names(filtRs) <- sample.names

out <- filterAndTrim(fwd = fnFs, filt = filtFs, rev = fnRs, filt.rev = filtRs, truncLen=c(240,200), maxLen = 260, truncQ=2, rm.phix=TRUE, compress=TRUE, multithread=CORES) # On Windows set multithread=FALSE
derepFs <- derepFastq(filtFs, verbose=FALSE);names(derepFs) <- sample.names
derepRs <- derepFastq(filtRs, verbose=FALSE);names(derepRs) <- sample.names

errF <- learnErrors(filtFs, multithread=CORES, randomize = TRUE); saveRDS(errF, paste0(path,"/../errF.RDS"))
errR <- learnErrors(filtRs, multithread=CORES, randomize = TRUE); saveRDS(errR, paste0(path,"/../errR.RDS"))

dadaFs <- dada(derepFs, err=errF, multithread=CORES); saveRDS(dadaFs, paste0(path,"/../dadaFs.RDS"))
dadaRs <- dada(derepRs, err=errR, multithread=CORES); saveRDS(dadaRs, paste0(path,"/../dadaRs.RDS"))
merged_reads <- mergePairs(dadaFs, derepFs, dadaRs, derepRs, verbose=FALSE); saveRDS(dadaRs, paste0(path,"/../dadaRs.RDS"))

seqtab <- makeSequenceTable(merged_reads)
seqtab <- removeBimeraDenovo(seqtab, method="consensus", multithread = CORES)

tax <- assignTaxonomy(seqtab, "/mnt/research/germs/databases/greengene/current_Bacteria_unaligned.fa", multithread = CORES)

# format(object.size(merged_reads), units = "GB")

