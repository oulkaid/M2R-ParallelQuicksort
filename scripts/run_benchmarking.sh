
OUTPUT_DIRECTORY=data/`hostname`_`date +%F`
mkdir -p $OUTPUT_DIRECTORY
OUTPUT_TXT=$OUTPUT_DIRECTORY/measurements_`date +%R`.txt
OUTPUT_CSV=$OUTPUT_DIRECTORY/measurements_`date +%R`.csv
c100=100

START_SIZE=0
MAX_SIZE=100000
STEP=10000

touch $OUTPUT_TXT
for i in $(eval echo {$START_SIZE..$MAX_SIZE..$STEP} ); do
    for rep in `seq 1 5`; do
        echo "Size: $i" >> $OUTPUT_TXT;
        ./src/parallelQuicksort $i >> $OUTPUT_TXT;
    done ;
    echo -ne "Progress: $((i * c100 / MAX_SIZE))%\r"
done
echo -ne "Progress: 100% --> generating csv file\n"

perl scripts/csv_quicksort_extractor2.pl < $OUTPUT_TXT > $OUTPUT_CSV
echo "Output: $OUTPUT_CSV"
rm $OUTPUT_TXT
