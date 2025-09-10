#!/bin/zsh

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

echo "Initializing home directory for $USER"
echo "This command should only be run on a Magi node"

if [[ $(askYesNo) == "y" ]]
then
	echo "Updating conda configuration"
	cp -vf "$MAGI_PREFIX/MagiSys/etc/condarc" ~/.condarc

	echo "Checking for network directories"
	HOME_IS_MOUNTED=0

	if [[ -d "$MAGI_DBPATH" ]]
	then
		echo "Detected '$MAGI_DBPATH'"
	fi

	if [[ -d "$MAGI_PREFIX/Users/$USER/Modules" ]]
	then
		echo "Detected '$MAGI_PREFIX/Users/$USER/Modules'"
		HOME_IS_MOUNTED=1
	fi

	if [[ -d "$MAGI_PREFIX/Users/$USER/Projects" ]]
	then
		echo "Detected '$MAGI_PREFIX/Users/$USER/Projects'"
		HOME_IS_MOUNTED=1
	fi

	if [[ -d "$MAGI_PREFIX/Users/$USER/Scratch" ]]
	then
		echo "Detected '$MAGI_PREFIX/Users/$USER/Scratch'"
		HOME_IS_MOUNTED=1
	fi

	echo "Creating symbolic links in $HOME"
	ln -vsfF "$MAGI_DBPATH" ~/Datasets
	ln -vsfF "$MAGI_PREFIX/Users/$USER/Modules" ~/Modules
	ln -vsfF "$MAGI_PREFIX/Users/$USER/Projects" ~/Projects
	ln -vsfF "$MAGI_PREFIX/Users/$USER/Scratch" ~/Scratch

	if [[ $HOME_IS_MOUNTED = 0 ]]
	then
		echo "Mounting '$MAGI_PREFIX/Users/$USER'"
		mount -vt smbfs //$USER@Magi-01.local/$USER "$MAGI_PREFIX/Users/$USER"
	else
		echo "Filesystem is already mounted"
	fi

	echo "Done"
fi
