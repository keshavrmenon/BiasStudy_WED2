#!/bin/bash
s0=1000
s1=123456
mass=$1
set -x
for icat in {0..2}
do
for pdfidx in {0..8}
do
for iter in {0..3}
do
        echo "source runBias_.sh Radion $mass $icat $pdfidx $(($s0+$iter)) $(($s1+$iter))"
	sh runBias_NMSSM.sh NMSSM $mass $icat $pdfidx $(($s0+$iter)) $(($s1+$iter))
done
done
done
set +x
