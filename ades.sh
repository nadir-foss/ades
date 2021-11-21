#!/bin/bash
# Run tests from https://run.codes/

COMMAND=$1
DIR=$2

cd $DIR

mkdir input &>/dev/null || true

mv *.in input &>/dev/null || true

mkdir expect &>/dev/null || true

mv *.out expect &>/dev/null || true
mkdir result &>/dev/null || true

INPUTS=$(ls -1 input | wc -l)

cd ..
for i in $(seq 1 $INPUTS) 
do
	(( $COMMAND ) < $DIR/input/$i.in) > $DIR/result/$i.out
done

RESULTS_FILE=$DIR/results.txt

mkdir $DIR/diffs &>/dev/null || true

echo -n > $RESULTS_FILE

for i in $(seq 1 $INPUTS)
do
	(diff $DIR/expect/$i.out $DIR/result/$i.out | grep -v \ ) > $DIR/diffs/$i.diff
	if [[ $(cat $DIR/diffs/$i.diff | wc -l) != '0' ]]
	then
		echo -e "$(tput setaf 1)$i: ................ [WRONG]" >> $RESULTS_FILE
		cat $DIR/diffs/$i.diff >> $RESULTS_FILE
		echo -e "$(tput sgr0)" >> $RESULTS_FILE
	else
		echo -e "$(tput setaf 2)$i: ................ [CORRECT]$(tput sgr0)" >> $RESULTS_FILE
	fi

done

cat $RESULTS_FILE
