#!/bin/bash
#PBS -N mixcr
#PBS -l walltime=10:00:00
#PBS -l select=2:ncpus=6:mem=15g
#PBS -j oe
#PBS -o /home/hansona/TCRgdProject/Containers/RunFiles/20200626-runmixcr-^array_index^.log
#PBS -M aimee.hanson@qut.edu.au
#PBS -m e
#PBS -J 1-32

source /etc/profile.d/modules.sh

module load atg/singularity/3.1.1

cd /home/hansona/TCRgdProject/Containers/mixcr

## Local sample files (pre-processed)
fastq=/home/hansona/TCRgdProject/ReadProcessing/MergedFastq/20200603_PreProcessed
indexlist=${fastq}/../IndexPairs.txt

index=`sed -n "$PBS_ARRAY_INDEX p" ${indexlist}`

i7=`cut -d " " -f1 <<< ${index}`
i5=`cut -d " " -f2 <<< ${index}`
pair="${i7}-${i5}"

sampleR1=`ls ${fastq}/*.fq | grep "${pair}_R1_good.fq" | xargs basename`
sampleR2=`ls ${fastq}/*.fq | grep "${pair}_R2_good.fq" | xargs basename`

singularity exec -B /home/hansona/TCRgdProject/ReadProcessing/MergedFastq/20200603_PreProcessed:/work docker://milaboratory/mixcr:latest /bin/bash mixcr.sh ${sampleR1} ${sampleR2} ${pair}
