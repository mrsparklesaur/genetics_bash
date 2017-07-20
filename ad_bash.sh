#!/bin/bash

#This script runs multiple iterations of the program admixture
#with a one or more values of K.
#run as ad_bash.sh prefix
#where "prefix" is the prefix of the .bed file
#The script will ask you what values of K to run for and how many iterations of each.
#You can optionally get it to print the cross-validation error values from each run.

echo -e "what is the minimum value of K that you want to run?"
read kmin

echo -e "what is the maximum value of K that you want to run?"
read kmax

#create folders for each K-value
for i in $(eval echo "{$kmin..$kmax}")
do
	echo "test $i"
	mkdir $1K$i
done

#run admixture

echo -e "how many iterations do you want to run for each value of K?"
read nIt

for k in $(eval echo "{$kmin..$kmax}")
do
	for j in $(eval echo "{1..$nIt}")
	do
		./admixture --cv $1.bed -s time $k | tee $1log$k.$j.out
		mv $1.$k.Q $1.$k.Q.run$j.txt
		mv $1.$k.P $1.$k.P.run$j.txt
	done
	mv $1.*Q* $1$k
	mv $1.*P* $1$k
done

#extract cv error
echo "do you want to look at the cross-validation error? (y/n)"
read answer
if [[ $answer == "y" ]]; then
	grep -h CV $1*.out
fi
