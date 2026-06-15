#!/bin/bash

python3 -m venv venv

source venv/bin/activate

# install python packages
pip install -r requirements.txt

# install required R package
Rscript -e 'if (!requireNamespace("PooledCohort", quietly=TRUE)) install.packages("PooledCohort", repos="https://cran.r-project.org")'

