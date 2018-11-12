#!/bin/bash

usage(){
cat << EOF

USAGE: sh R_setup.sh -l [R-library_directory] [project_folder]

REQUIRED:
  [project_folder]
  	you must specify where your demultiplexed 16S sequencing reads are.

OPTIONS:
   -l   specify a directory for your R-library, if this has not been 
   		set previously and you do not specify with this flag then the 
   		default will be /mnt/research/germs/R/library.

EOF
}
while getopts ":hl" OPTION; do
     case $OPTION in
         h)
            usage
            exit 1
            ;;
         l)
			if [ -z ${R_LIBS_USER+x} ]
            	then R_LIBS_USER=$2;
        		else echo "R-library is already set, do you wish to create a new libary in $2?\\n";
					read -p " [y/N] " ans;
					case "$ans" in
						[yY][eE][sS]|[yY]) 
					 		R_LIBS_USER=$2;
							;;
						*)
							:
					 		;;
					esac
	        fi
	        DATA_DIR=$3;
	        echo "export R_LIBS_USER=$R_LIBS_USER" >> ~/.bashrc
            ;;
         :)
			echo "Option -$OPTARG requires an argument." >&2
      		exit 1
			;;
         ?) echo "Invalid option: -$OPTARG\\nUse \"sh $0 -h\" to see usage and list of legal arguments." >&2
            exit 1
            ;;
     esac
done

if [ -z ${DATA_DIR+x} ]; then DATA_DIR=$1; fi
if [ -z ${R_LIBS_USER+x} ]
	then echo "ERROR: R-library is not set and -l argument is missing. \\nR-library will be automatically set to /mnt/research/germs/R/library ?";
		read -p " [y/N] " ans;
		case "$ans" in
			[yY][eE][sS]|[yY]) 
		 		R_LIBS_USER=/mnt/research/germs/R/library;
		        echo "export R_LIBS_USER=$R_LIBS_USER" >> ~/.bashrc
				;;
			*)
				usage
            	exit 1
		 		;;
		esac
fi

source ~/.bashrc
if [ -e $R_LIBS_USER ] ;
	then : ;
	else mkdir -p $R_LIBS_USER ;
fi

if [ -z "$DATA_DIR" ]
then
     cat << EOF


ERROR: Missing [project_folder].

EOF
	usage
    exit 1
fi

module load R-Core

Rscript --vanilla /mnt/research/germs/Schuyler/scripts/R_setup.R $R_LIBS_USER

