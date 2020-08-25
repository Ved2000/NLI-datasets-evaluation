
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


SICK='http://alt.qcri.org/semeval2014/task1/data/uploads'
MNLI='https://www.nyu.edu/projects/bowman/multinli/multinli_0.9.zip'
SNLI='https://nlp.stanford.edu/projects/snli/snli_1.0.zip'


### download MNLI
mkdir $data_path/MNLI
curl -Lo $data_path/MNLI/multinli_0.9.zip $MNLI
unzip $data_path/MNLI/multinli_0.9.zip -d $data_path/MNLI
rm $data_path/MNLI/multinli_0.9.zip
rm -r $data_path/MNLI/__MACOSX

for split in train dev_matched dev_mismatched
do
    fpath=$data_path/MNLI/$split.multinli.txt
    awk '{ if ( $1 != "-" ) { print $0; } }' $data_path/MNLI/multinli_0.9/multinli_0.9_$split.txt | cut -f 1,6,7 | sed '1d' > $fpath
    cut -f1 $fpath > $data_path/MNLI/labels.$split
    cut -f2 $fpath | $PTBTOKENIZER > $data_path/MNLI/s1.$split
    cut -f3 $fpath | $PTBTOKENIZER > $data_path/MNLI/s2.$split
    rm $fpath
done
rm -r $data_path/MNLI/multinli_0.9



### download SNLI
mkdir $data_path/SNLI
curl -Lo $data_path/SNLI/snli_1.0.zip $SNLI
unzip $data_path/SNLI/snli_1.0.zip -d $data_path/SNLI
rm $data_path/SNLI/snli_1.0.zip
rm -r $data_path/SNLI/__MACOSX

for split in train dev test
do
    fpath=$data_path/SNLI/$split.snli.txt
    awk '{ if ( $1 != "-" ) { print $0; } }' $data_path/SNLI/snli_1.0/snli_1.0_$split.txt | cut -f 1,6,7 | sed '1d' > $fpath
    cut -f1 $fpath > $data_path/SNLI/labels.$split
    cut -f2 $fpath | $PTBTOKENIZER > $data_path/SNLI/s1.$split
    cut -f3 $fpath | $PTBTOKENIZER > $data_path/SNLI/s2.$split
    rm $fpath
done
rm -r $data_path/SNLI/snli_1.0

### download SICK
mkdir $data_path/SICK

for split in train trial test_annotated
do
    urlname=$SICK/sick_$split.zip
    curl -Lo $data_path/SICK/sick_$split.zip $urlname
    unzip $data_path/SICK/sick_$split.zip -d $data_path/SICK/
    rm $data_path/SICK/readme.txt
    rm $data_path/SICK/sick_$split.zip
done

for split in train trial test_annotated
do
    fname=$data_path/SICK/SICK_$split.txt
    cut -f1 $fname | sed '1d' > $data_path/SICK/tmp1
    cut -f4,5 $fname | sed '1d' > $data_path/SICK/tmp45
    cut -f2 $fname | sed '1d' | $MTOKENIZER -threads 8 -l en -no-escape > $data_path/SICK/tmp2
    cut -f3 $fname | sed '1d' | $MTOKENIZER -threads 8 -l en -no-escape > $data_path/SICK/tmp3
    head -n 1 $fname > $data_path/SICK/tmp0
    paste $data_path/SICK/tmp1 $data_path/SICK/tmp2 $data_path/SICK/tmp3 $data_path/SICK/tmp45 >> $data_path/SICK/tmp0
    mv $data_path/SICK/tmp0 $fname
    rm $data_path/SICK/tmp*
done




# remove moses folder
rm -rf mosesdecoder
