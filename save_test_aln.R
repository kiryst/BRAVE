library(Biostrings)
library(dplyr)

args <- commandArgs(trailingOnly=TRUE)

args[1]   # input 

args[2]   # path  test fasta files

args[3] # output save file

sequences <- readAAStringSet(args[1])
# Read test FASTA file and extract sequence names (virus IDs)
test_sequences <- readAAStringSet(args[2])
virus_ids <- names(test_sequences)  # Extract headers as virus IDs
filtered_sequences <- sequences[names(sequences) %in% virus_ids]
writeXStringSet(filtered_sequences,args[3])

