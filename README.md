# AIRO2 - assignment 1

First assignment of the Artificial Intelligence for Robotics 2 course - UniGE.

*Reference professor*: Mauro Vallati

*Language*: PDDL+
*Planning engine*: [ENHSP](https://sites.google.com/view/enhsp/) (version 20)

### Collaborators

| Name                  | ID       |
| --------------------- |:--------:|
| Gabriele Nicchiarelli | S4822677 |
| Ludovica Danovaro     | S4811864 |
| Andrea Bolla          | S4482930 |

### Execution

To execute planning run the script:
```bash
./run.bash [-g|w|a|h] <domain> <problem>
```

*Note*: you may have to give execution permissions to the script: `sudo chmod +x run.bash`

The allowed option to launch the script are:
- `-g`  Uses Greedy Best First Search as search algorithm
- `-w`  Uses wA* as search algorithm
- `-a`  Runs in anytime mode, incrementally tries to find a lower bound.
- `-h`  Prints the help for the script.

### Dependencies

The only dependency needed is Java (15 possibly, otherwise also 17 and 18 should work):
```bash
sudo apt install openjdk-17-jdk
```

*Note*: if you choose to install Java 15, you'll have to install it manually.

### Troubleshoot

If you encounter problems executing the `run.bash` script, just execute the planner by coping and pasting one of the following commands:

```bash
java -jar ENHSP/enhsp.jar -o <domain> -f <problem> -d 0.5 -pe           # GBFS
java -jar ENHSP/enhsp.jar -o <domain> -f <problem> -d 0.5 -pe -s WAStar # wA*
java -jar ENHSP/enhsp.jar -o <domain> -f <problem> -d 0.5 -pe -anytime  # Anytime
```