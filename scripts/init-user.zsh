#!/bin/zsh

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
# setup user's home directory
# 

MAGI_HEAD="Magi-01"

echo "Initializing home directory for ${USER}"
echo "This command should only be run on a Magi node"

if [[ $(askYesNo) == "y" ]]
then
	echo "Updating zshenv"
	cp -vf "${MAGI_PREFIX}/MagiSys/etc/env" "${HOME}/.zshenv"

	echo "Updating zprofile"
	cp -vf "${MAGI_PREFIX}/MagiSys/etc/profile" "${HOME}/.zprofile"

	echo "Checking for network directories"

	MAGI_USER_HOME="${MAGI_PREFIX}/Users/${USER}"
	NEEDS_MOUNTING=false

	if [[ -d "${MAGI_DBPATH}" ]]
	then
		echo "Detected '${MAGI_DBPATH}'"
	fi

	if [[ -d "${MAGI_USER_HOME}/Modules" ]]
	then
		echo "Detected '${MAGI_USER_HOME}/Modules'"
	else
		NEEDS_MOUNTING=true
	fi

	if [[ -d "${MAGI_USER_HOME}/Projects" ]]
	then
		echo "Detected '${MAGI_USER_HOME}/Projects'"
	else
		NEEDS_MOUNTING=true
	fi

	if [[ -d "${MAGI_USER_HOME}/Scratch" ]]
	then
		echo "Detected '${MAGI_USER_HOME}/Scratch'"
	else
		NEEDS_MOUNTING=true
	fi

	echo "Creating symbolic links in ${HOME}"
	ln -vsfF "${MAGI_DBPATH}" "${HOME}/Datasets"
	ln -vsfF "${MAGI_USER_HOME}/Modules" "${HOME}/Modules"
	ln -vsfF "${MAGI_USER_HOME}/Projects" "${HOME}/Projects"
	ln -vsfF "${MAGI_USER_HOME}/Scratch" "${HOME}/Scratch"

	if [[ ${NEEDS_MOUNTING} = true ]]
	then
		echo "Mounting '${MAGI_USER_HOME}'"
		mount -vt smbfs //${USER}@${MAGI_HEAD}.local/${USER} "${MAGI_USER_HOME}"
	else
		echo "Filesystem is available"
	fi

	echo "Done"
fi
