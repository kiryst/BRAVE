#!/bin/bash

# Function to display usage
usage() {
    echo "Usage: $0 --antibody_name=<name> --column=<column_name> --cutoff=<cutoff_value>"
    exit 1
}

# Parse command-line arguments
while [[ "$#" -gt 0 ]]; do
    case $1 in
        --antibody_name=*) name="${1#*=}"; shift ;;
        --column=*) column="${1#*=}"; shift ;;
	--cutoff=*) cutoff="${1#*=}"; shift ;;
        *) usage ;;
    esac
done

# Check if the required variables are set
if [ -z "$name" ] || [ -z "$column" ] || [ -z "$cutoff" ]; then
    usage
fi

# Debugging: Print the parsed arguments
echo "Antibody Name: ${name}"
echo "Column Name: ${column}"
echo "Cutoff Value: ${cutoff}"

#source /data/kiryst/conda/etc/profile.d/conda.sh
#conda activate brave_env
#export TORCH_HOME=/lscratch/$SLURM_JOB_ID

python ../esm/scripts/extract.py esm2_t33_650M_UR50D ./data/${name}_aln.fasta emb_esm2_1280/${name} --repr_layers 0 32 33 --include per_tok
cp ../convert_2_column_csv.py ./emb_esm2_1280/${name}
cd ./emb_esm2_1280/${name}
ls *.pt >list_pt

python convert_2_column_csv.py
cd ../../

R --no-echo --no-restore --no-save --args "${name}" < BRAVE_preprocess.R

R --no-echo --no-restore --no-save --args "${name}" "${column}" "${cutoff}" < BRAVE_train.R


