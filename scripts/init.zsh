#!/bin/zsh

echo "Initializing home directory for $USER"

echo "Updating $HOME/.condarc"
cp -vf "$MAGI_PREFIX/MagiSys/etc/condarc" ~/.condarc

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
