#!/bin/bash

OUTFILE="$1"
LINESKIP=1


if [ $# -lt 2 ]; then
  echo "insufficient arguments!"
  echo "usage: $0 outfile infile1 [infile2 ...]"
  exit 1
fi

# Check that $LINESKIP is a number
if ! [[ $LINESKIP =~ ^[0-9]+$ ]]; then
  echo "LINESKIP is not an integer (now: $LINESKIP), quitting"
  exit 2
fi

if [[ $LINESKIP -lt 0 ]]; then
  echo "LINESKIP is negative (must be >= 0), quitting"
  exit 2
fi

shift

# Header; remove CR from line ends if present
head -n 1 "$1" | sed 's/\r$//' > "$OUTFILE"

# Line from which actual data starts
STARTLINE=$(( 2+${LINESKIP}  ))

echo "Headers read from $1, processing data; input starts at line $STARTLINE"

# Iterate through files
for fname in "$@"; do
  echo "Processing $fname"
  tail -n +${STARTLINE} "$fname" | sed 's/\r$//' >> "$OUTFILE"
done
