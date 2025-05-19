## Training Details

### Computational Resources
- **Memory**: 150 GB
- **Local Scratch Space**: 50 GB
- **Cluster**: Biowulf high-performance computing cluster
- **CPU Cores**: 2 cores

### Please install all dependencies from the main GitHub page

### Generate training Data
- **Input**:
  1. bNAb,choose one of 33 bNAbs (10-1074, 2F5, 2G12, 35O22, 3BNC117, 4E10, 8ANC195, b12, CH01, DH270.1, DH270.5, DH270.6, HJ16, NIH45-46, PG16, PG9, PGDM1400, PGT121, PGT128, PGT135, PGT145, PGT151, VRC01, VRC03, VRC07, VRC13, VRC26.08, VRC26.25, VRC29.03, VRC34.01, VRC38.01, VRC-CH31, VRC-PG04)
  2. Training sequences in FASTA alignment file format in data folder: data/{bNAb}_aln.fasta
  3. The training process requires data split into 5-folds in CSV format. The files should follow this naming convention: bNAb_fold{1-5}_testing.csv, bNAb_fold{1-5}_training.csv
  Each CSV file must contain the following fields:
virus_id: Unique identifier for each virus.
ic50: IC50 value (a measure of sensitivity or resistance).

- **Output**:
  - Embedding files in the `data/emb_esm2_1280/` directory.
  - Final results saved as `/data/bNab.RData` file

### Command Used
The script was executed with the following command:
```bash


./do_train_BRAVE.sh --antibody_name=<name> --column=<ic50|ic80> --cutoff=<sensitivity cutoff>

For example:

./do_train_BRAVE.sh --antibody_name=DH270.1 --column=ic50 --cutoff=50.0


Contact:

tatsiana.bylund@nih.gov
