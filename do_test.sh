#!/bin/bash

# Function to display usage
usage() {
    echo "Usage: $0 --antibody_name=<name> --input=<input_file> --rdata=<rdata_file>"
    exit 1
}

# Parse command-line arguments
while [[ "$#" -gt 0 ]]; do
    case $1 in
        --antibody_name=*) name="${1#*=}"; shift ;;
        --input=*) input_file="${1#*=}"; shift ;;
        --rdata=*) rdata_file="${1#*=}"; shift ;;
        *) usage ;;
    esac
done

# Check if both name and input_file variables are set
if [ -z "$name" ] || [ -z "$input_file" ] || [ -z "$rdata_file" ]; then
    usage
fi

# Debugging: Print the parsed arguments
echo "Antibody Name: ${name}"
echo "Input File: ${input_file}"
echo "RData File: ${rdata_file}"
## align to reference aligment
conda activate BRAVE
export LD_PRELOAD=$CONDA_PREFIX/lib/libstdc++.so.6

mafft --quiet --addfull "${input_file}" --keeplength ./fasta/${name}_aln.fasta > ./fasta/${name}_test_aligned2Reference.fasta

## save just the test antibody aligned 
R --no-echo --no-restore --no-save --args "./fasta/${name}_test_aligned2Reference.fasta" "${input_file}" "./fasta/${name}_test_aln.fasta" < save_test_aln.R

mkdir ${name}
cp ./fasta/${name}_test_aln.fasta ./${name}

cd ./${name}
## if running on a cluster, disk quota exceeded , try
# export TORCH_HOME=/lscratch/$SLURM_JOB_ID

python ../esm/scripts/extract.py esm2_t33_650M_UR50D ${name}_test_aln.fasta emb_esm2_1280 --repr_layers 0 32 33 --include per_tok

cp ../convert_2_column_csv.py ./emb_esm2_1280
cd ./emb_esm2_1280
ls *.pt >list_pt


python convert_2_column_csv.py

cd ../../

R --no-echo --no-restore --no-save --args "${input_file}" "${name}/emb_esm2_1280/" "${name}_output.csv" "${rdata_file}" < make_rda_test.R


##rm -r ${name}
