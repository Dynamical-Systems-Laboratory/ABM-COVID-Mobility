#!/bin/bash

# Shell script for automated simulations of ABM with a 
# variable vaccination rate and variable reopening rates 
# Creates directories for each vaccination and reopening rate, 
# copies all the files and directories from templates to the new one,
# runs sub_rate.py to substitute target vaccination and reopening rates,
# compiles, runs the simulations through MATLAB wrapper
# All this is done in one screen per rate

# This script also opens matlab and adjusts glibc path

# To shut down all screens later
# screen -ls | grep Detached | cut -d. -f1 | awk '{print $1}' | xargs kill

# Run as
# ./make_and_run

# Hardcoded vaccination and reopeoning rates to consider
#declare -a Vrates=(8 16 40 79 158 396 792 1584 3960)

# Batches
#declare -a Vrates=(8 16 40)
#declare -a Vrates=(79 158 396)
declare -a Vrates=(792 1584 3960)
declare -a Rrates=(0.00001 0.00002 0.00005 0.0001 0.0002 0.0005 0.001 0.002 0.005 0.01 0.02 0.05)

for i in "${Vrates[@]}";
do
	for j in "${Rrates[@]}";
	do
	
		echo "Processing vacination rate $i, and reopening rate $j"
		
		# Make the directory and copy all the neccessary files
	    mkdir "dir_$i-$j"
	    cp -r templates/input_data "dir_$i-$j/"
		cp -r templates/output "dir_$i-$j/"
		cp templates/*.* "dir_$i-$j/"
		cd "dir_$i-$j/"
	
		# Pre-process input
		# Substitute the correct value for the vaccination rate
		mv input_data/infection_parameters.txt input_data/temp.txt
	    python3.6 sub_rate.py input_data/temp.txt input_data/infection_parameters.txt "vaccination rate" $i
		# Substitute the correct value for reopeoning rate
		mv input_data/infection_parameters.txt input_data/temp.txt
	    python3.6 sub_rate.py input_data/temp.txt input_data/infection_parameters.txt "reopening rate" $j
	
		# Compile
		python3.6 compilation.py  
		
		# Run (starts and exits screen)
		screen -d -m ./run_matlab.sh
		
		cd ..
	done
done
