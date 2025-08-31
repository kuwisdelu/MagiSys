#!/bin/zsh

# 
# get installation locations
# 

if [[ ! -n "$MAGI_PREFIX" ]]
then
	echo "error: \$MAGI_PREFIX not set"
	exit
fi

if [[ ! -n "$MAGI_DBPATH" ]]
then
	echo "error: \$MAGI_DBPATH not set"
	exit
fi

MAGI_SYSPATH="$MAGI_PREFIX/MagiSys"
MAGI_SYSENV="$MAGI_PREFIX/activate.zsh"

# 
# setup utility functions
# 

askYesNo() {
	while true; do
		if [[ -n $1 ]]
		then
			read "REPLY?$1 (y/n): "
		else
			read "REPLY?Do you want to continue? (y/n): "
		fi
		if [[ $REPLY = "y" ]] || [[ $REPLY = "Y" ]]
		then
			echo y
			return 0
		elif [[ $REPLY = "n" ]] || [[ $REPLY = "N" ]]
		then
			echo n
			return 1
		else
			echo "Please enter 'y' or 'n'."
		fi
	done
}

installDataManifest() {
	if [[ ! -d "$MAGI_DBPATH/$1" ]]
	then
		if [[ -f "$MAGI_DBPATH/$1" ]]
		then
			echo "$MAGI_DBPATH/$1 will be overwritten"
			if [[ $(askYesNo) == "n" ]]
			then
				return
			fi
			rm "$MAGI_DBPATH/$1"
		fi
		mkdir -p "$MAGI_DBPATH/$1"
	fi
	MANIFEST_FILE="$MAGI_DBPATH/$1/manifest.toml"
	if [[ -e "$MANIFEST_FILE" ]]
	then
		rm "$MANIFEST_FILE"
	fi
	echo "Downloading $1 data manifest from $2"
	if curl -fsSL $2 -o "$MANIFEST_FILE"
	then
		echo "Installed $1 data manifest to $MANIFEST_FILE"
	else
		echo "error: failed to install $MANIFEST_FILE"
		return 1
	fi
}

installMagiEnv() {
	if [[ -e "$1" ]]
	then
		echo "Removing old environment $1"
	fi
	cat "$MAGI_PREFIX/MagiSys/Library/activate.zsh" > $1
	echo "" >> $1
	echo "export MAGI_PREFIX='$MAGI_PREFIX'" >> $1
	echo "export MAGI_DBPATH='$MAGI_DBPATH'" >> $1
	echo "export MAGI_DBNAME='$MAGI_DBNAME'" >> $1
	echo "Installed environment $1"
}

# 
# update Magi system repository
# 

echo "Updating Magi system"

if [[ ! -d "$MAGI_SYSPATH" ]]
then
	echo "error: no installation found at $MAGI_SYSPATH"
	exit
fi

echo "Updating Magi system repository $MAGI_SYSPATH"

git -C "$MAGI_SYSPATH" pull origin main --quiet

MAGI_VENV="$MAGI_SYSPATH/venv"
MAGI_PYTHON="$MAGI_VENV/bin/python3"

if [[ ! -d "$MAGI_VENV" ]]
then
	echo "No virtual environment detected at $MAGI_VENV"
	echo "Creating virtual environment at $MAGI_VENV"
	eval /usr/bin/env python3 -m venv "$MAGI_VENV"
fi

echo "Updating badwulf in virtual environment"
eval "$MAGI_PYTHON" -m pip install pip --upgrade --quiet
eval "$MAGI_PYTHON" -m pip install badwulf --upgrade --quiet

installMagiEnv $MAGI_SYSENV

# 
# install Magi data
# 

echo "Updating Magi data manifests"

if [[ ! -d "$MAGI_DBPATH" ]]
then
	echo "error: no installation found at $MAGI_DBPATH"
	exit
fi

echo "Downloading data manifests to $MAGI_DBPATH"

MAGI_DBREPO=https://raw.githubusercontent.com/kuwisdelu/MSIResearch/HEAD
curl -fsSL "$MAGI_DBREPO/README.md" > "$MAGI_DBPATH/README.md"
installDataManifest MSI "$MAGI_DBREPO/manifest.toml"

# 
# complete update
# 

echo "Finished updating"
echo "You may need to restart your shell for changes to take effect"
