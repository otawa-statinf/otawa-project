#!/usr/bin/env bash

binpath=$1
name=$(basename $1 .out)
entry=$2

[ -z $1 ] && echo "Need .out parameter" && exit 1

if [[ $2 == "-addr" ]]; then
	python3 -c "print(hex(2 * 0x$3))"\
		|| python3 -c "print(hex(2 * $3))"
	exit 0
fi

dis2000 $binpath  > $name.dis
[ -z $2 ] && echo "Select a 0x-prefixed address parameter:"
[ -z $2 ] && echo -ne "\e[0;36m" && grep "main" $name.dis
[ -z $2 ] && echo -e "\e[0;m$0 $1 0x[address]" && exit 1

echo -e "\e[0;94mGenerating $name.$entry.gliss using odisasm... \e[0;m"
	odisasm -b $binpath $entry  > $name.$entry.gliss
	echo -e "\t\t\t\e[0;92m... OK\e[0m"

echo -e "\e[0;94mGenerating $name.$entry.dot using dumpcfg... \e[0;m"
	dumpcfg -Dads $binpath $entry  > $name.$entry.dot 
	dumpcfg -Wads $binpath $entry 
	echo -e "\t\t\t\e[0;92m... OK\e[0m"
echo -e "\e[0;94mGenerating $name-otawa using owcet... \e[0;m"
	owcet -s trivial --stats $binpath $2
	echo -e "\t\t\t\e[0;92m... OK\e[0m"
echo -ne "\e[0;94mRun: obviews.py $1 _x"${2#"0x"}
echo -e "\e[0;m"
