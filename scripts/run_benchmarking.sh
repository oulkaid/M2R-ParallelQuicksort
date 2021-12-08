
OUTPUT_DIRECTORY=data/`hostname`_`date +%F`
mkdir -p $OUTPUT_DIRECTORY
OUTPUT_TXT=$OUTPUT_DIRECTORY/measurements_`date +%R`.txt
OUTPUT_CSV=$OUTPUT_DIRECTORY/measurements_`date +%R`.csv
_100=100

START_SIZE=0
MAX_SIZE=10000000
STEP=500000
REPEAT=20

touch $OUTPUT_TXT
for rep in `seq 1 $REPEAT`; do
    for i in $(eval echo {$START_SIZE..$MAX_SIZE..$STEP} ); do
        echo "Size: $i" >> $OUTPUT_TXT;
        ./src/parallelQuicksort $i >> $OUTPUT_TXT;
	echo -ne "Running $rep/$REPEAT: $((i*_100/MAX_SIZE))%\r" #progress
    done;
    echo -ne "                        \r"
done;
echo "Generating csv file.."

perl scripts/csv_quicksort_extractor2.pl < $OUTPUT_TXT > $OUTPUT_CSV
echo "Output file: $OUTPUT_CSV"
rm $OUTPUT_TXT
