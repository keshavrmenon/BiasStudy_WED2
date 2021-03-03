#!/bin/bash

for icat in {0..2}
do
    for mass in 260 270 280 300 350 400 450
    do
	for truth in {0..8}
	do
	hadd higgsCombineDoubleHTag_${icat}_13TeV.Radion${mass}_18_01_2021.t${truth}.mu_inj1.0.MultiDimFit.mH125.final.root higgsCombineDoubleHTag_${icat}_13TeV.Radion${mass}_18_01_2021.t${truth}.mu_inj1.0.*MultiDimFit*.root
	done
    done
done
