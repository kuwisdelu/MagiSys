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
