#!/bin/zsh

# 
# get installation locations
# 

if [[ -z "${MAGI_PREFIX}" ]]
then
	if [[ -d "/Volumes/MagiSys" ]]
	then
		export MAGI_PREFIX="/Volumes/MagiSys"
	else
		export MAGI_PREFIX=~/.MagiSys
	fi
fi

if [[ -z "${MAGI_DBPATH}" ]]
then
	export MAGI_DBPATH="${MAGI_PREFIX}/Datasets"
fi

MAGI_REPO="${MAGI_PREFIX}/MagiSys"
MAGI_SHELL="${MAGI_PREFIX}/shellenv.zsh"

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
	if [[ ! -d "${MAGI_DBPATH}/$1" ]]
	then
		if [[ -f "${MAGI_DBPATH}/$1" ]]
		then
			echo "${MAGI_DBPATH}/$1 will be overwritten"
			if [[ $(askYesNo) == "n" ]]
			then
				return
			fi
			rm "${MAGI_DBPATH}/$1"
		fi
		mkdir -p "${MAGI_DBPATH}/$1"
	fi
	MANIFEST_FILE="${MAGI_DBPATH}/$1/manifest.toml"
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

# 
# check if already installed
# 

if [[ -d "${MAGI_REPO}/.git" ]]
then
	IS_FRESH_INSTALL=0
else
	IS_FRESH_INSTALL=1
fi

# 
# fresh install
# 

if [[ $IS_FRESH_INSTALL = 1 ]]
then

	# 
	# ask user permission to install
	# 

	echo "This script will install:"
	echo "${MAGI_PREFIX}/"
	echo "${MAGI_DBPATH}/"
	echo "${MAGI_REPO}/"
	echo "${MAGI_SHELL}"
	if [[ -d "${MAGI_DBPATH}" ]]
	then
		echo "Existing data in ${MAGI_DBPATH}/ will be preserved"
	fi

	if [[ $(askYesNo) == "n" ]]
	then
		exit
	else
		echo
	fi

	# 
	# install Magi prefix
	# 

	if [[ ! -d "${MAGI_PREFIX}" ]]
	then
		echo "Creating ${MAGI_PREFIX}"
		if [[ -f "${MAGI_PREFIX}" ]]
		then
			echo "file ${MAGI_PREFIX} will be overwritten"
			if [[ $(askYesNo) == "n" ]]
			then
				exit
			fi
			rm "${MAGI_PREFIX}"
		fi
		mkdir -p "${MAGI_PREFIX}"
	fi

	# 
	# install Magi system repository
	# 

	echo "Cloning Magi system repository ${MAGI_REPO}"
	git -C "${MAGI_PREFIX}" clone https://github.com/kuwisdelu/MagiSys.git --quiet

	# 
	# install Magi data directory
	# 

	echo "Creating Magi data directory"

	if [[ ! -d "${MAGI_DBPATH}" ]]
	then
		if [[ -f "${MAGI_DBPATH}" ]]
		then
			echo "file ${MAGI_DBPATH} will be overwritten"
			if [[ $(askYesNo) == "n" ]]
			then
				exit
			fi
			rm "${MAGI_DBPATH}"
		fi
		mkdir -p "${MAGI_DBPATH}"
	fi

# 
# upgrade install
# 

else

	echo "Detected existing installation at ${MAGI_PREFIX}"
	echo "Updating Magi system repository ${MAGI_REPO}"
	git -C "${MAGI_REPO}" pull origin main --quiet

fi

# 
# install badwulf
# 

MAGI_PYTHON_ENV="${MAGI_REPO}/venv"
MAGI_PYTHON_BIN="${MAGI_PYTHON_ENV}/bin/python3"

if [[ ! -d "${MAGI_PYTHON_ENV}" ]]
then
	echo "Creating virtual environment at ${MAGI_PYTHON_ENV}"
	eval /usr/bin/env python3 -m venv "${MAGI_PYTHON_ENV}"
fi

echo "Installing badwulf in virtual environment"
eval "${MAGI_PYTHON_BIN}" -m pip install pip --upgrade --quiet
eval "${MAGI_PYTHON_BIN}" -m pip install badwulf  --upgrade --quiet

# 
# install shell environment
# 

if [[ -e "${MAGI_SHELL}" ]]
then
	echo "Removing old shell environment ${MAGI_SHELL}"
fi
cp -vf "${MAGI_PREFIX}/MagiSys/Library/shellenv.zsh" "${MAGI_SHELL}"
echo "Installed shell environment ${MAGI_SHELL}"

# 
# install Magi data manifests
# 

echo "Installing research data manifests to ${MAGI_DBPATH}"

MAGI_DBHEAD=https://raw.githubusercontent.com/kuwisdelu/MSIResearch/HEAD
curl -fsSL "${MAGI_DBHEAD}/README.md" > "${MAGI_DBPATH}/README.md"

installDataManifest MSI "${MAGI_DBHEAD}/manifest.toml"

# 
# complete installation
# 

if [[ $IS_FRESH_INSTALL = 1 ]]
then
	MAGI_INIT=""
	MAGI_INIT="${MAGI_INIT}\n# >>> Magi initialization <<<"
	MAGI_INIT="${MAGI_INIT}\nsource '${MAGI_SHELL}'"
	MAGI_INIT="${MAGI_INIT}\n# <<< Magi initialization <<<"

	echo
	echo "Finished moving files into place"
	echo "To use the installation, the following will be appended to your ~/.zshrc:"
	echo ${MAGI_INIT}
	echo

	if [[ $(askYesNo) == "y" ]]
	then
		echo ${MAGI_INIT} >> ~/.zshrc
	fi

	echo "Finished installing"
	echo "You may need to restart your shell for changes to take effect"
else
	echo "Finished updating"
	echo "You may need to restart your shell for changes to take effect"
fi
