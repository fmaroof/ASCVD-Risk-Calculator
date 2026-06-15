#!/bin/bash

echo "==> Preparing module environment..."
module purge
module load anaconda3

# Teach the bash script how to use 'conda activate'
eval "$(conda shell.bash hook)"

echo "==> Creating Conda environment (Python, R, rpy2)..."
conda create -n fhir-r-env python=3.11 r-base rpy2 -c conda-forge -y

echo "==> Activating environment..."
conda activate fhir-r-env

echo "==> Installing Python packages..."
pip install -r requirements.txt

echo "==> Installing R packages..."
Rscript -e 'if (!requireNamespace("PooledCohort", quietly=TRUE)) install.packages("PooledCohort", repos="https://cran.r-project.org")'

echo "==> Setup Complete! <=="