
# Developer environment
export CONDA_AUTO_ACTIVATE_BASE=false
alias R="R --no-save"
alias python=python3
alias pydoc="python3 -m pydoc"
alias pip="python3 -m pip"
alias ipython="python3 -m IPython"

# Magi environment
export MAGI_DBPATH="/Volumes/Magi/Datasets"
export MAGI_SYSPATH="/Volumes/Magi/MagiSys"
export PATH="$MAGI_SYSPATH/bin:$PATH"

# Bioconductor environment
export BIOCPARALLEL_WORKER_MAX=8
export BIOCPARALLEL_WORKER_NUMBER=4
