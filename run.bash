#!/bin/bash

Help()
{
    # Display Help
    echo $'Script to run the planning engine.\n'
    echo $'Syntax: ./run.bash <domain> <problem> [-o|s|n|h]\n'
    echo $'Options:'
    # echo $'-o   Optimal plan.'
    echo $'-s   Satisficing plans.'
    echo $'-n   Simple plan.'
    echo $'-h   Print this Help.\n'
}

results_path="results/$(basename $(dirname $3))"
filename=$(basename $3)
filename="${filename%.*}"

case $1 in
    # -o) # Optimal plan
    #     if [ $# -lt 3 ] ; then
    #         echo $'Provvide all arguments\n'
    #         Help
    #         exit 1
    #     fi
    #     echo $'Optimal plan\n'
    #     java -jar ENHSP/enhsp.jar -o $2 -f $3 -planner opt-blind -pe > $results_path/$filename-opt.txt
    #     ;;
    -s) # Satisficing plans
        if [ $# -lt 3 ] ; then
            echo $'Provvide all arguments\n'
            Help
            exit 1
        fi
        echo $'Satisficing plans\n'
        java -jar ENHSP/enhsp.jar -o $2 -f $3 -anytime --delta_execuction 0.5 -pe > $results_path/$filename-sat.txt
        ;;
    -n) # Simple plan
        if [ $# -lt 3 ] ; then
            echo $'Provvide all arguments\n'
            Help
            exit 1
        fi
        echo $'Simple plan\n'
        java -jar ENHSP/enhsp.jar -o $2 -f $3 --delta_execuction 0.5 -pe > $results_path/$filename.txt
        ;;
    -h) # display Help
        Help
        ;;
    *) # Unknown option
        echo $'Unknown option\n'
        Help
        ;;
esac