#!/usr/bash

perl $JudeBotPath/perl/scripts/fetch_data.pl
echo "Fetch phrase-of-today at : $(date)" >> ${OPENSHIFT_PERL_LOG_DIR}/jude_job.log

