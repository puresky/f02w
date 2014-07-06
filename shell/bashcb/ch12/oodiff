#!/usr/bin/env bash
# cookbook filename: oodiff
# oodiff -- diff the CONTENTS of two OpenOffice.org files
# works only on .odt files
#
function usagexit ()
{
    echo "usage: $0 file1 file2"
    echo "where both files must be .odt files"
    exit $1
} >&2
    12
# assure two readable arg filenames which end in .odt
if (( $# != 2 ))
then
    usagexit 1
fi
if [[ $1 != *.odt || $2 != *.odt ]]
then
    usagexit 2
fi
if [[ ! -r $1 || ! -r $2 ]]
then
    usagexit 3
fi
    26
BAS1=$(basename "$1" .odt)
BAS2=$(basename "$2" .odt)
    29
# unzip them someplace private
PRIV1="/tmp/${BAS1}.$$_1"
PRIV2="/tmp/${BAS2}.$$_2"
    33
# make absolute
HERE=$(pwd)
if [[ ${1:0:1} == '/' ]]
then
    FULL1="${1}"
else
    FULL1="${HERE}/${1}"
fi
    42
# make absolute
if [[ ${2:0:1} == '/' ]]
then
    FULL2="${2}"
else
    FULL2="${HERE}/${2}"
fi
    50
# mkdir scratch areas and check for failure
# N.B. must have whitespace around the { and } and
#      must have the trailing ; in the {} lists
mkdir "$PRIV1" || { echo Unable to mkdir $PRIV1 ; exit 4; }
mkdir "$PRIV2" || { echo Unable to mkdir $PRIV2 ; exit 5; }
    56
cd "$PRIV1"
unzip -q "$FULL1"
sed -e 's/>/>\
/g' -e 's/</\
</g' content.xml > contentwnl.xml
    62
cd "$PRIV2"
unzip -q "$FULL2"
sed -e 's/>/>\
/g' -e 's/</\
</g' content.xml > contentwnl.xml
    68
cd $HERE
    70
diff "${PRIV1}/contentwnl.xml" "${PRIV2}/contentwnl.xml"
    72
rm -rf $PRIV1 $PRIV2
