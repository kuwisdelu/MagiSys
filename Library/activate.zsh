# Magi system environment
# 
# $MAGI_PREFIX sets the Magi system location
# $MAGI_DBPATH sets the Magi data location
# $MAGI_DBNAME sets the default data collection
# $MAGI_USER sets the Magi cluster username
# $MAGI_LOGIN sets the Khoury login server username

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

magisys_install() {
	eval "$MAGI_PREFIX/MagiSys/install/install.zsh"
}

magisys_uninstall() {
	eval "$MAGI_PREFIX/MagiSys/install/uninstall.zsh"
}

magisys_update() {
	eval "$MAGI_PREFIX/MagiSys/install/update.zsh"
}
