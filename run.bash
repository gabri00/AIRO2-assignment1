#!/bin/bash

Help()
{
    # Display Help
    echo $'Script to run the planning engine.\n'
    echo $'Syntax: ./run.bash [-g|w|a|h] <domain> <problem>\n'
    echo $'Options:'
    echo $'-g\tUses Greedy Best First Search as search algorithm'
    echo $'-w\tUses WA* as search algorithm'
    echo $'-a\tRun in anytime mode, Incrementally tries to find a lower bound.\n\tDoes not stop until the user decides so!'
    echo $'-h\tPrint this help.\n'
}

if [ $# -gt 1 ] ; then
    results_path="results/$(basename $(dirname $3))"
    filename=$(basename $3)
    filename="${filename%.*}"
fi


case $1 in
    -g) # GBFS
        if [ $# -lt 3 ] ; then
            echo $'Provvide all arguments!\n'
            Help
            exit 1
        fi
        echo $'Running with GBFS\n'
        java -jar ENHSP/enhsp.jar -o $2 -f $3 -d 0.5 -pe > $results_path/$filename-gbfs.txt
        ;;
    -w) # WA*
        if [ $# -lt 3 ] ; then
            echo $'Provvide all arguments\n'
            Help
            exit 1
        fi
        echo $'Running with WA*\n'
        java -jar ENHSP/enhsp.jar -o $2 -f $3 -s WAStar -d 0.5 -pe > $results_path/$filename-wa\*.txt
        ;;
    -a) # Anytime
        if [ $# -lt 3 ] ; then
            echo $'Provvide all arguments\n'
            Help
            exit 1
        fi
        echo $'Satisficing plans\n'
        java -jar ENHSP/enhsp.jar -o $2 -f $3 -anytime -d 0.5 -pe -timeout 10 > $results_path/$filename-sat.txt
        ;;
    -h) # Help
        Help
        ;;
    *) # Unknown option
        echo $'Unknown option\n'
        Help
        ;;
esac