#!/bin/zsh

# 
# get installation locations
# 

if [[ ! -n "${MAGI_PREFIX}" ]]
then
	echo "error: \$MAGI_PREFIX not set"
	exit
fi

if [[ ! -n "${MAGI_DBPATH}" ]]
then
	echo "error: \$MAGI_DBPATH not set"
	exit
fi

MAGI_REPO="${MAGI_PREFIX}/MagiSys"
MAGI_SHELL="${MAGI_PREFIX}/shellenv.zsh"

if [[ ! -d ${MAGI_REPO} ]]
then
	echo "error: no installation found at ${MAGI_REPO}"
	exit
fi

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

# 
# ask user permission to uninstall Magi system
# 

echo "This script will uninstall:"
echo "${MAGI_REPO}/"
echo "${MAGI_SHELL}"

if [[ $(askYesNo) == "y" ]]
then
	echo
	if [[ -f "${MAGI_SHELL}" ]]
	then
		rm "${MAGI_SHELL}"
		echo "Removed ${MAGI_SHELL}"
	fi
	if [[ -d "${MAGI_REPO}" ]]
	then
		rm -rf "${MAGI_REPO}"
		echo "Removed ${MAGI_REPO}"
	fi
	echo
else
	exit
fi

# ask user permission to uninstall Magi data

echo "This script now uninstall:"
echo "${MAGI_DBPATH}/"

if [[ $(askYesNo) == "y" ]]
then
	echo
	if [[ -d "${MAGI_DBPATH}" ]]
	then
		rm -rf "${MAGI_DBPATH}"
		echo "Removed ${MAGI_DBPATH}"
	fi
	echo
fi

# 
# complete installation
# 

echo "Finished uninstalling"
