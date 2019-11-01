#!/bin/bash
perl TDgene.pl query.pep query.gff3
perl find.cluster.pl TD_gene.result
perl find.longest.pl Tendem.repeat.cluster
