# Magi system environment
# -----------------------
# This file's contents will get copied to $MAGI_PREFIX/activate.zsh
# Environment variables:
# $MAGI_PREFIX sets the Magi system location (*)
# $MAGI_DBPATH sets the Magi data location  (*)
# $MAGI_DBNAME sets the default data collection  (*)
# $MAGI_USER sets the Magi cluster username (++)
# $MAGI_LOGIN sets the Khoury login server username (++)
# (*) These are installed to $MAGI_PREFIX/activate.zsh
# (++) These should be customized in ~/.zshrc

magi() {
	if [[ ! -n $MAGI_PYTHON ]]
	then
		MAGI_PYTHON="$MAGI_PREFIX/MagiSys/venv/bin/python3"
	fi
	eval "$MAGI_PYTHON" "$MAGI_PREFIX/MagiSys/Library/magi.py" "$@"
}

magidb() {
	if [[ ! -n $MAGI_PYTHON ]]
	then
		MAGI_PYTHON="$MAGI_PREFIX/MagiSys/venv/bin/python3"
	fi
	eval "$MAGI_PYTHON" "$MAGI_PREFIX/MagiSys/Library/magidb.py" "$@"
}

magisys() {
	if [[ $1 = "update" ]]
	then
		eval "$MAGI_PREFIX/MagiSys/install/update.zsh"
	elif [[ $1 = "reinstall" ]]
	then
		eval "$MAGI_PREFIX/MagiSys/install/install.zsh"
	elif [[ $1 = "uninstall" ]]
	then
		eval "$MAGI_PREFIX/MagiSys/install/uninstall.zsh"
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
		echo "  reinstall    Reinstall the system"
		echo "  uninstall    Remove the system"
		echo
		echo "USER COMMANDS:"
		echo "  init         Initialize user's home"
	fi
}
