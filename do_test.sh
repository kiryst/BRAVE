#!/bin/bash

# Function to display usage
usage() {
    echo "Usage: $0 --antibody_name=<name>"
    exit 1
}

# Parse command-line arguments
while [[ "$#" -gt 0 ]]; do
    case $1 in
        --antibody_name=*) name="${1#*=}"; shift ;;
        *) usage ;;
    esac
done

# Check if the name variable is set
if [ -z "$name" ]; then
    usage
fi

##name="b12"
echo "${name}"
## align to reference aligment

mafft --quiet --add ./fasta/${name}_testing.fasta ./fasta/${name}_aln.fasta > ./fasta/${name}_test_aligned2Reference.fasta

## save just the test antibody aligned 
R --no-echo --no-restore --no-save --args "./fasta/${name}_test_aligned2Reference.fasta" "./fasta/${name}_testing.fasta" "./fasta/${name}_test_aln.fasta" < save_test_aln.R

mkdir ${name}
cp ./fasta/${name}_test_aln.fasta ./${name}

cd ./${name}
## if running on a cluster, dist quota exceeded , try
## export TORCH_HOME=/lscratch/$SLURM_JOB_ID

python ../esm/scripts/extract.py esm2_t33_650M_UR50D ${name}_test_aln.fasta emb_esm2_1280 --repr_layers 0 32 33 --include per_tok

cp ../convert_2_column_csv.py ./emb_esm2_1280
cd ./emb_esm2_1280
ls *.pt >list_pt


python convert_2_column_csv.py

cd ../../

R --no-echo --no-restore --no-save --args "./fasta/${name}_testing.fasta" "${name}/emb_esm2_1280/" "${name}_output.csv" "./DATA/${name}.RData" < make_rda_test.R


rm -r ${name}

