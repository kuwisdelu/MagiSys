#!/bin/zsh

# ./download.zsh [NODE] [PORT] [LOGIN] /src/ /dest/
# $1 NODE must specify Magi node
# $2 PORT must be >=1024
# $3 LOGIN for login.khoury.northeastern.edu
# $4 /src/ path for the source file
# $5 /dest/ path for the target file

# You may need to setup SSH keys on login.khoury.northeastern
# You may need to enable remote login under System Settings

echo "connecting to Khoury servers"
ssh -NL $2:Magi-$1:22 $3@login.khoury.northeastern.edu &
pid=$!
sleep 1
echo "forwarding to Magi-$1 on port $2"
sleep 1
echo "downloading from: '$4'"
echo "downloading to: '$5'"
rsync -aP --rsh="ssh -p $2" viteklab@localhost:$4 $5
kill $pid
echo "closing connection to server"
