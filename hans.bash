# All rights reserved.
#
# This source code is licensed under the license found in the
# LICENSE file in the root directory of this source tree.
#

#
# Download and tokenize data with MOSES tokenizer
#

data_path=.
preprocess_exec=./tokenizer.sed

# Get MOSES
echo 'Cloning Moses github repository (for tokenization scripts)...'
git clone https://github.com/moses-smt/mosesdecoder.git
SCRIPTS=mosesdecoder/scripts
MTOKENIZER=$SCRIPTS/tokenizer/tokenizer.perl
LOWER=$SCRIPTS/tokenizer/lowercase.perl

if [ ! -d "$SCRIPTS" ]; then
    echo "Please set SCRIPTS variable correctly to point to Moses scripts."
    exit
fi

PTBTOKENIZER="sed -f tokenizer.sed"

mkdir $data_path




for split in Hans
do
    fpath=$data_path/MNLI/$split.txt
    awk '{ if ( $1 != "-" ) { print $0; } }' $data_path/MNLI/$split.txt | cut -f 1,6,7 | sed '1d' > $fpath
    cut -f1 $fpath > $data_path/MNLI/labels.$split
    cut -f2 $fpath | $PTBTOKENIZER > $data_path/MNLI/s1.$split
    cut -f3 $fpath | $PTBTOKENIZER > $data_path/MNLI/s2.$split
    rm $fpath
done
rm -r $data_path/MNLI/multinli_0.9







# remove moses folder
