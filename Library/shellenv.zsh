# Magi system environment
# -----------------------
# This file gets copied to "${MAGI_PREFIX}/shellenv.zsh" 
# which then determines ${MAGI_PREFIX} whenever sourced
# 
# Environment variables:
# ${MAGI_PREFIX} sets the Magi install location  (*)
# ${MAGI_DBPATH} sets the Magi data location  (*)
# ${MAGI_DBNAME} sets the default data collection  (*)
# ${MAGI_USER} sets the Magi cluster username (++)
# ${MAGI_LOGIN} sets the Khoury login server username (++)
# (*) These are automatically set below if not detected
# (++) These should be customized manually
# -----------------------

if [[ -z "${MAGI_PREFIX}" ]]
then
	export MAGI_PREFIX=${0:a:h}
fi

if [[ -z "${MAGI_DBPATH}" ]]
then
	export MAGI_DBPATH="${MAGI_PREFIX}/Datasets"
fi

if [[ -z "${MAGI_DBNAME}" ]]
then
	export MAGI_DBNAME="MSI"
fi

magi() {
	if [[ ! -n ${MAGI_PYTHON_BIN} ]]
	then
		MAGI_PYTHON_BIN="${MAGI_PREFIX}/MagiSys/venv/bin/python3"
	fi
	eval "${MAGI_PYTHON_BIN}" "${MAGI_PREFIX}/MagiSys/Library/magi.py" "$@"
}

magidb() {
	if [[ ! -n ${MAGI_PYTHON_BIN} ]]
	then
		MAGI_PYTHON_BIN="${MAGI_PREFIX}/MagiSys/venv/bin/python3"
	fi
	eval "${MAGI_PYTHON_BIN}" "${MAGI_PREFIX}/MagiSys/Library/magidb.py" "$@"
}

magisys() {
	if [[ $1 = "update" ]]
	then
		MAGI_REPO="${MAGI_PREFIX}/MagiSys"
		if [[ ! -d "${MAGI_REPO}" ]]
		then
			echo "error: no installation found at ${MAGI_REPO}"
			exit
		fi
		echo "Updating Magi system repository ${MAGI_REPO}"
		git -C "${MAGI_REPO}" pull origin main --quiet
		zsh "${MAGI_REPO}/install/install.zsh"
	
	elif [[ $1 = "uninstall" ]]
	then
		zsh "${MAGI_PREFIX}/MagiSys/install/uninstall.zsh"
	
	elif [[ $1 = "init" ]]
	then
		zsh "${MAGI_PREFIX}/MagiSys/scripts/init.zsh"
	
	elif [[ -n $1 ]]
	then
		echo "magisys: command not recognized: '$1'"
	
	else
		echo "usage: magisys COMMAND ..."
		echo
		echo "Manage the Magi system environment"
		echo
		echo "SYSTEM COMMANDS:"
		echo "  update       Update the system"
		echo "  uninstall    Remove the system"
		echo
		echo "NODE COMMANDS:"
		echo "  init         Initialize user's home"
		echo
	fi
}
