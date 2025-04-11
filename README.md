# BRAVE 

A Highly Accurate Method for Predicting HIV-1 Antibody Resistance Utilizing Protein Large Language Models


## Installation

BRAVE runs in R code, using python, MAFFT and ESM2 

### Create CoViPaD Environment

```sh
conda create --name BRAVE python=3.9 r-base=4.2
conda activate BRAVE 
conda install pip
pip install torch==1.12.1 torchvision==0.13.1 torchaudio==0.12.1
conda install pandas
conda install -c conda-forge r-tidyverse r-pROC r-data.table r-caret r-randomforest r-glmnet r-dplyr
conda install -c bioconda mafft

git clone https://github.com/facebookresearch/esm.git
cd esm
pip install .

Open an R session within the environment:
R
install.packages("BiocManager")
BiocManager::install("nestedcv")
BiocManager::install("Biostrings")

Exit the R session:
quit()

cd ../

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

