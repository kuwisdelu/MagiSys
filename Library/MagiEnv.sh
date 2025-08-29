# Magi system environment

magi() {
	if [ ! -n $MAGI_PYTHON ]
	then
		MAGI_PYTHON="$MAGI_PREFIX/MagiSys/venv/bin/python3"
	fi
	eval "$MAGI_PYTHON" "$MAGI_PREFIX/MagiSys/Library/magi.py" "$@"
}

magidb() {
	if [ ! -n $MAGI_PYTHON ]
	then
		MAGI_PYTHON="$MAGI_PREFIX/MagiSys/venv/bin/python3"
	fi
	eval "$MAGI_PYTHON" "$MAGI_PREFIX/MagiSys/Library/magidb.py" "$@"
}
