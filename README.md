# BRAVE 

A Highly Accurate Method for Predicting HIV-1 Antibody Resistance Utilizing Protein Large Language Models


## Installation

BRAVE runs in R code, using python, MAFFT and ESM2 

### Create CoViPaD Environment

```sh
conda create -n BRAVE python=3.10 r-base=4.4.3 gxx_linux-64=11.3.0 numpy=1.24 -c conda-forge
conda activate BRAVE 
conda install pip
pip install torch==1.12.1 torchvision==0.13.1 torchaudio==0.12.1
conda install pandas
conda install -c conda-forge r-pROC r-data.table r-caret r-randomforest r-glmnet r-dplyr
conda install -c conda-forge r-ranger
conda install -c bioconda mafft=7.490
conda install -c conda-forge libxml2 zlib xz
conda install -c conda-forge libstdcxx-ng

export LD_PRELOAD=$CONDA_PREFIX/lib/libstdc++.so.6

git clone https://github.com/facebookresearch/esm.git
cd esm
pip install .
cd ../

Open an R session within the environment:
R
install.packages("BiocManager")
install.packages("RcppArmadillo")
install.packages("Rfast", verbose = TRUE)
BiocManager::install("nestedcv")
BiocManager::install("Biostrings")
BiocManager::install("tidyverse")

Exit the R session:
quit()

### Data Availability
The DATA/ folder has been excluded from this repository due to size constraints.
You can download the training and associated data files from our Zenodo record:

https://zenodo.org/records/15366851

Once downloaded, place the files inside a local DATA/ directory to use with BRAVE.

Run BRAVE in command line

Input arguments: 
1. bNAb,choose one of 33 bNAbs (10-1074, 2F5, 2G12, 35O22, 3BNC117, 4E10, 8ANC195, b12, CH01, DH270.1, DH270.5, DH270.6, HJ16, NIH45-46, PG16, PG9, PGDM1400, PGT121, PGT128, PGT135, PGT145, PGT151, VRC01, VRC03, VRC07, VRC13, VRC26.08, VRC26.25, VRC29.03, VRC34.01, VRC38.01, VRC-CH31, VRC-PG04)

2. HIV-1 Env sequence(s) in FASTA format. 
3. Trained model in Rdata format

Run: 

./do_test.sh --antibody_name=<name> --input=<input_file> --rdata=./DATA/<name>.RData


Results will be saved in ${name}_output.csv. For each sequence in the input test file it will predict either sensitive or resistant and corresponding probabilities.

For example:

./do_test.sh --antibody_name=b12 --input=./fasta/b12_testing.fasta --rdata=./DATA/b12_training.RData

Contact:

tatsiana.bylund@nih.gov

