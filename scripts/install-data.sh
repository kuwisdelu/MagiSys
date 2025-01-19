#!/bin/zsh

MSI_DBPATH="$MAGI_DBPATH/MSI"
if [[ ! -e "$MSI_DBPATH" ]]
then
	echo "Creating database at $MSI_DBPATH"
	mkdir "$MSI_DBPATH"
fi
echo "Cloning database into $MSI_DBPATH"
git -C "$MSI_DBPATH" clone git@github.com:kuwisdelu/MSIResearch.git
echo "Done!"
