# Cromwell Download and create test script
RUN_SCRIPT="./Run_Cromwell.sh"
WDL_FILE="./myWorkFlow.wdl"


mkdir Cromwell
cd Cromwell
mkdir bin
cd ./bin
wget https://github.com/broadinstitute/cromwell/releases/download/41/cromwell-41.jar
cd ../
touch $WDL_FILE

echo "workflow myWorkflow {
    call myTask
}

task myTask {
    command {
        echo "hello world"
    }
    output {
        String out = read_string(stdout())
    }
}" >> $WDL_FILE

touch $RUN_SCRIPT
echo '#!/bin/bash
# Usage: Run_Cromwell.sh myWorkFlow.wdl
set -e
if [ $# -ne 1 ]; then
    echo $0: usage: Run_Cromwell myWorkFlow
    exit 1
else 
     echo "passed workflow file $1"
fi
FILE1=$1
if test -f "$FILE1"; then
    echo "$FILE1 exist"
else 
    echo "$FILE1 does not exist"
fi

module purge
module load bluebear
module load Java/1.8.0_162

RESULTS_FILE="./results.txt"
# to have both stderr and output displayed on the console and in a file use this:  2>&1 | tee 
touch "$RESULTS_FILE" 


java -jar ./bin/cromwell-41.jar run $FILE1 2>&1 | tee $RESULTS_FILE
echo "written output to $RESULTS_FILE"
' >> $RUN_SCRIPT

chmod +x $RUN_SCRIPT

if test -f "$RUN_SCRIPT"; then
    echo "$RUN_SCRIPT exist"
	if test -f "$WDL_FILE"; then
		echo "$WDL_FILE exist"
	    "$RUN_SCRIPT" "$WDL_FILE"
	else 
		echo "$WDL_FILE does not exist"
	fi
else 
    echo "$RUN_SCRIPT does not exist"
fi


