package DeconSeqConfig;

use strict;

use constant DEBUG => 0;
use constant PRINT_STUFF => 1;
use constant VERSION => '0.4.3';
use constant VERSION_INFO => 'DeconSeq version '.VERSION;

use constant ALPHABET => 'ACGTN';

use constant DB_DIR => '/dataset/QC_session/human_db/';
use constant TMP_DIR => 'tmp/';
use constant OUTPUT_DIR => 'output/';

use constant PROG_NAME => 'bwa64';  # should be either bwa64 or bwaMAC (based on your system architecture)
use constant PROG_DIR => '/usr/local/deconseq-standalone-0.4.3/bwasw_modified_source/';      # should be the location of the PROG_NAME file (use './' if in the same location at the perl script)

use constant DBS => {hsref => {name => 'Human Reference GRCh37',  #database name used for display and used as input for -dbs and -dbs_retain
                               db => 'hs_ref_GRCh37'},            #database name as defined with -p for "bwa index -p ..." (specify multiple database chunks separated with commas without space; e.g. hs_ref_s1,hs_ref_s2,hs_ref_s3)
                     bact => {name => 'Bacterial genomes',
                              db => 'bactDB'},
                     vir => {name => 'Viral genomes',
                             db => 'virDB'}};
use constant DB_DEFAULT => 'hsref';

#######################################################################

use base qw(Exporter);

use vars qw(@EXPORT);

@EXPORT = qw(
             DEBUG
             PRINT_STUFF
             VERSION
             VERSION_INFO
             ALPHABET
             PROG_NAME
             PROG_DIR
             DB_DIR
             TMP_DIR
             OUTPUT_DIR
             DBS
             DB_DEFAULT
             );

1;
