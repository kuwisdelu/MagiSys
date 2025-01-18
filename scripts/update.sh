#!/bin/zsh

MAGI_SYSPATH=${0:a:h:h}
echo "Updating at $MAGI_SYSPATH"
MAGI_VENV="$MAGI_SYSPATH/venv"
if [[ ! -d $MAGI_VENV ]]
then
	echo "No Python executable found for MagiSys"
	exit 1
fi
source "$MAGI_VENV/bin/activate"
echo "Updating badwulf in virtual environment..."
python3 -m pip install badwulf --upgrade
deactivate
echo "Pulling updates for MagiSys..."
git -C "$MAGI_SYSPATH" pull origin main
echo "Pulling updates for MSI/MSIResearch..."
git -C "$MAGI_DBPATH/MSI/MSIResearch" pull origin main
echo "Done!"
