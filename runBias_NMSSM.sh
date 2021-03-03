#!/bin/bash
#source /cvmfs/cms.cern.ch/cmsset_default.sh

sig=$1
massY=$2
icat=$3
masses="260, 270, 280, 300, 320, 350, 400, 450"

truth=$4
date="27_12_2020"
datacard_folder="/afs/cern.ch/work/k/kmenon/CMSSW_10_2_13/src/BiasStudy_WED2"
seed0=$5
seed1=$6
for massX in $(echo ${masses} | sed "s/,/ /g")
do
    check=$((${massX}-${massY}-125))
    echo ${check}
    if [ "${check}" -lt 0 ]; then
	continue
    fi
    datacard=cms_HHbbgg_datacard_${sig}_X${massX}_Y${massY}_${date}_2016_2017_2018
    NGEN=500
    mu_inj=1.0
    echo $mu_inj
    #rMin=-10
    #rMax=$((2*$mu_inj+6))

    CAT=DoubleHTag_${icat}_13TeV
    cd /afs/cern.ch/work/k/kmenon/CMSSW_10_2_13/src
    eval `scramv1 runtime -sh`
    cd $datacard_folder
    
    pdfidx=pdfindex_$CAT
    SETUP=${CAT}.${sig}_X${massX}_Y${massY}_${date}.t$truth.mu_inj$mu_inj.GENSEED${seed0}
    GENERATE=higgsCombine${SETUP}.GenerateOnly.mH125.${seed0}.root
    TOYS=higgsCombineTest.GenerateOnly.${SETUP}.${seed0}.root
    echo $SETUP
    
    GENERATING1="combine ${datacard}_${CAT}.root -M GenerateOnly -m 125 --setParameters $pdfidx=$truth --expectSignal $mu_inj -t $NGEN --saveToys -n ${SETUP} --freezeParameters $pdfidx,allConstrainedNuisances -s ${seed0} --toysFrequentist"
    echo $GENERATING1
    eval $GENERATING1

    mv $GENERATE $TOYS
    echo "generated " $TOYS
    MLFITTING1="combineTool.py ${datacard}_${CAT}.root -M MultiDimFit --algo singles -m 125 --expectSignal $mu_inj --toysFile $TOYS --cminDefaultMinimizerStrategy 0 -n ${SETUP}_envelop -t $NGEN --saveFitResult --saveSpecifiedIndex $pdfidx -P r --setParameterRanges r=-5,5 --freezeParameters allConstrainedNuisances -s ${seed1} --job-mode condor --task-name condor-${SETUP} --sub-opts='+JobFlavour="workday"' --job-dir $datacard_folder"
    echo ${MLFITTING1}
    combineTool.py ${datacard}_${CAT}.root -M MultiDimFit --algo singles -m 125 --expectSignal $mu_inj --toysFile $TOYS --cminDefaultMinimizerStrategy 0 -n ${SETUP}_envelop -t $NGEN --saveFitResult --saveSpecifiedIndex $pdfidx -P r --setParameterRanges r=-5,5 --freezeParameters allConstrainedNuisances -s ${seed1} --job-mode condor --task-name condor-${SETUP} --sub-opts='+JobFlavour="longlunch"' --job-dir $datacard_folder
    #rm -f $TOYS
    echo "fitted $pdfidx toy with envelop"
done
