# Magi run commands
# requires $MAGI_DBPATH and $MAGI_SYSPATH:
# e.g., export MAGI_DBPATH="path/to/Datasets"
# e.g., export MAGI_SYSPATH="path/to/MagiSys"
export PATH="$MAGI_SYSPATH/bin:$PATH"

# Magi aliases
alias R="R --no-save --no-restore"
alias python=python3
alias pydoc="python3 -m pydoc"
alias pip="python3 -m pip"
alias venv="python3 -m venv"

# Magi node environment
if [[ -n $(hostname | fgrep -i "Magi") ]]
then
	export BIOCPARALLEL_WORKER_MAX=8
	export BIOCPARALLEL_WORKER_NUMBER=4
fi
