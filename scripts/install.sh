#!/bin/zsh

MAGI_SYSPATH=${0:a:h:h}
echo "Installing at $MAGI_SYSPATH"
MAGI_VENV="$MAGI_SYSPATH/venv"
echo "Creating virtual environment at $MAGI_VENV"
python3 -m venv "$MAGI_VENV"
source "$MAGI_VENV/bin/activate"
echo "Installing badwulf to virtual environment..."
python3 -m pip install badwulf
deactivate
echo "To complete installation, add the following to ~/.zshrc:"
echo "==="
echo 'export MAGI_DBPATH="/path/to/Datasets"'
echo 'export MAGI_SYSPATH="/path/to/MagiSys"'
echo 'source "$MAGI_SYSPATH/scripts/activate.sh"'
echo "==="
echo "Done!"
