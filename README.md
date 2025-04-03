# BRAVE 

A Highly Accurate Method for Predicting HIV-1 Antibody Resistance Utilizing Protein Large Language Models


## Installation

BRAVE runs in R code. 
It requires installed 
MAFFT software (https://mafft.cbrc.jp/alignment/software/)
ESM2 https://github.com/facebookresearch/esm/blob/main/README.md, specifically esm-extract esm2_t33_650M_UR50D

### Create CoViPaD Environment

```sh
conda create --name BRAVE
conda activate BRAVE 
conda install -c r r
conda install -c bioconda r-bio3d
conda install -c r r-rcurl
conda install -c r r-jsonlite
conda install -c cidermole jdk8 (Linux) or conda install -c cyclus java-jdk (Mac)
conda install -c bioconda mafft
conda install -c bioconda bioconductor-biostrings
conda install -c r r-data.table
conda install -c r r-foreach
conda install -c r r-doparallel
conda install -c r r-rocr
conda install -c conda-forge r-geosphere
conda install -c conda-forge readline
conda install python
conda install pytorch torchvision torchaudio -c pytorch
conda install pandas

Run BRAVE in command line

Input arguments: 
1. bNAb,choose one of 33 bNAbs (10-1074, 2F5, 2G12, 35O22, 3BNC117, 4E10, 8ANC195, b12, CH01, DH270.1, DH270.5, DH270.6, HJ16, NIH45-46, PG16, PG9, PGDM1400, PGT121, PGT128, PGT135, PGT145, PGT151, VRC01, VRC03, VRC07, VRC13, VRC26.08, VRC26.25, VRC29.03, VRC34.01, VRC38.01, VRC-CH31, VRC-PG04)

2. HIV-1 Env sequence(s) in FASTA format. Please use ${name}_testing.fasta for test sequences in fasta folder

3. Change do_test.sh to add path to MMAFT and esm-extract

Run: 

./do_test.sh --antibody_name=${name}


Results will be saved in ${name}_output.csv. For each sequence in the input test file it will predict either sensitive or resistant and corresponding probabilities.

For example:

./do_test.sh --antibody_name=b12


Contact:

tatsiana.bylund@nih.gov

