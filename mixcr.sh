#!/bin/bash

##================================================================================##
####################################################################################
##										  ##
## 	Title:	miXCR								  ##	
## 	Author: Aimee L. Hanson							  ##
## 	Date:	23-06-2020							  ##
##										  ##
## 	Extraction of TCR CDR3 regions and V(D)J-C annotation from RNASeq reads	  ##
##	using miXCR							          ##
##	https://github.com/milaboratory/mixcr					  ##
##										  ##							
####################################################################################
##================================================================================##

if [[ ! $1 =~ .(fastq.gz|fastq|fq.gz|fq)$ ]] || [[ ! $2 =~ .(fastq.gz|fastq|fq.gz|fq)$ ]]; then
        echo "Please provide sample .fastq/.fastq.gz files for reads 1 and 2"
        exit 1
else
        echo "Provided files: $1 and $2"
fi

if [[ ! $3 =~ ^D7[0-9]{2}-D5[0-9]{2}$ ]]; then
	echo "Please provide index pair in format D7XX-D5XX"
	exit 1
else
	echo "Index pair: $3"
fi

rundate=`date +"%Y%m%d"`
start_time=`date -u +%s`

## Runid
runid="HHNGWDMXX"

## Working directory within container (for input and output files)
output=/work
mkdir -p ${output}/${rundate}_miXCR

sampleR1=$1
sampleR2=$2
indexpair=$3

#####################################################
## Assmble CDR3 contigs, annotate V(D)J with miXCR ##
#####################################################

printf "Extracting TCR data from sample files\n${sampleR1} and\n${sampleR2}\n"

mixcr analyze shotgun \
${output}/${sampleR1} ${output}/${sampleR2} \
--species HomoSapiens \
--starting-material rna \
--only-productive \
--export "--preset full -vFamily -vGene -dFamily -dGene -jFamily -jGene -cFamily -cGene -vHitScore -dHitScore -jHitScore -cHitScore" \
${output}/${rundate}_miXCR/${rundate}_${runid}_${indexpair}

mixcr exportAlignmentsPretty \
${output}/${rundate}_miXCR/${rundate}_${runid}_${indexpair}.vdjca \
--verbose ${output}/${rundate}_miXCR/${rundate}_${runid}_${indexpair}_verbose.txt

end_time=`date -u +%s`
elapsed=$((end_time-start_time))

echo "Total of $((elapsed/3600)) hours, $(((elapsed/60)%60)) mins to complete"
