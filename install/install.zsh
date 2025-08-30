#!/bin/zsh

# 
# get installation locations
# 

if [[ ! -n "$MAGI_PREFIX" ]]
then
	export MAGI_PREFIX=~/.MagiSys
fi

if [[ ! -n "$MAGI_DBPATH" ]]
then
	export MAGI_DBPATH="$MAGI_PREFIX/Datasets"
fi

if [[ ! -n "$MAGI_DBNAME" ]]
then
	export MAGI_DBNAME="MSI"
fi

MAGI_SYSPATH="$MAGI_PREFIX/MagiSys"
MAGI_SYSENV="$MAGI_PREFIX/MagiEnv.zsh"

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
		rm "$1"
	fi
	cat "$MAGI_PREFIX/MagiSys/Library/MagiEnv.zsh" > $1
	echo "export MAGI_PREFIX='$MAGI_PREFIX'" >> $1
	echo "export MAGI_DBPATH='$MAGI_DBPATH'" >> $1
	echo "export MAGI_DBNAME='$MAGI_DBNAME'" >> $1
}

# 
# ask user permission to install
# 

echo "This script will install:"
echo "$MAGI_PREFIX"
echo "$MAGI_SYSENV"
echo "$MAGI_SYSPATH"
echo "$MAGI_DBPATH"

if [[ $(askYesNo) == "n" ]]
then
	exit
else
	echo
fi

# 
# install Magi prefix
# 

if [[ ! -d "$MAGI_PREFIX" ]]
then
	echo "Creating $MAGI_PREFIX"
	if [[ -f "$MAGI_PREFIX" ]]
	then
		echo "$MAGI_PREFIX will be overwritten"
		if [[ $(askYesNo) == "n" ]]
		then
			exit
		fi
		rm -rf "$MAGI_PREFIX"
	fi
	mkdir -p "$MAGI_PREFIX"
fi

# 
# install Magi system repository
# 

echo "Installing Magi system"

if [[ -e "$MAGI_SYSPATH" ]]
then
	echo "$MAGI_SYSPATH will be overwritten"
	if [[ $(askYesNo) == "n" ]]
	then
		exit
	fi
	rm -rf "$MAGI_SYSPATH"
fi

echo "Creating Magi system repository $MAGI_SYSPATH"
git -C "$MAGI_PREFIX" clone git@github.com:kuwisdelu/MagiSys.git --quiet

MAGI_VENV="$MAGI_SYSPATH/venv"
MAGI_PYTHON="$MAGI_VENV/bin/python3"

echo "Creating virtual environment at $MAGI_VENV"
eval /usr/bin/env python3 -m venv "$MAGI_VENV"

echo "Installing badwulf in virtual environment"
eval "$MAGI_PYTHON" -m pip install pip --upgrade --quiet
eval "$MAGI_PYTHON" -m pip install badwulf  --upgrade --quiet

# 
# install Magi research data
# 

echo "Installing Magi research data manifests"

if [[ ! -d "$MAGI_DBPATH" ]]
then
	if [[ -f "$MAGI_DBPATH" ]]
	then
		echo "$MAGI_DBPATH will be overwritten"
		if [[ $(askYesNo) == "n" ]]
		then
			exit
		fi
		rm -rf "$MAGI_DBPATH"
	fi
	mkdir -p "$MAGI_DBPATH"
fi

echo "Downloading data manifests to $MAGI_DBPATH"
installDataManifest MSI https://raw.githubusercontent.com/kuwisdelu/MSIResearch/HEAD/manifest.toml

# 
# complete installation
# 

installMagiEnv $MAGI_SYSENV

MAGI_INIT=""
MAGI_INIT="$MAGI_INIT\n# >>> Magi initialization <<<"
MAGI_INIT="$MAGI_INIT\nsource '$MAGI_SYSENV'"
MAGI_INIT="$MAGI_INIT\n# <<< Magi initialization <<<"

echo
echo "Finished moving files into place"
echo "To complete installation, the following will be appended to your ~/.zshrc:"
echo $MAGI_INIT
echo

if [[ $(askYesNo) == "y" ]]
then
	echo $MAGI_INIT >> ~/.zshrc
fi

echo "Done"
echo "You may need to restart your shell for changes to take effect"
