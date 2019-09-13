#!/bin/bash

set -e 
set -x

module purge;
module load bluebear;
module load bear-apps/2018b;
module load Anaconda3/2018.12

echo "Create a new conda environment with all the r-essentials conda packages built from CRAN:"

conda create -y --name r_env r-essentials r-base

echo "Activate the environment:"
module purge;
module load bluebear;
module load bear-apps/2018b;
module load Anaconda3/2018.12

echo " reload bash as .bashrc has changed "
exec bash
conda activate r_env

echo "List the packages in the environment:"

conda list

conda install -c r r-devtools

Rscript Install_Test_SSC.r

echo " Creating Environment file: bio-env.txt"
conda list --explicit > bio-env.txt
echo " remove a package: conda remove -n foo" 
echo " to remove the created env: conda env remove --name r_env" 
