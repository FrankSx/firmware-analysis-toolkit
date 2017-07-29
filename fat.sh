#!/usr/bin/env bash

set -e
set -u

function usage { 
	echo "  -go 			Main function
		-test 			start from mk imgage
		-del 			deletes a IID from "





 }
if [[ $# -gt 5 || $# -lt 1 ]]; then
    usage
fi


# Put this script in the firmadyne path downloadable from
# https://github.com/firmadyne/firmadyne

##Franks Version Of Fat 
#Configurations - change this according to your system
firmadyne_path="/home/oit/tools/fat"
binwalk_path="/usr/local/bin/binwalk"
mitm_path="/usr/bin/mitmdump"
dFILE=./tmp/debugOUT.txt # Debugging and testing purposes
#D1="/ce_inic_image.tar.gz" #debugging stuff
#D2="Wanmp"  #debugging stuff
###########NOTE ------------------->DONE Untested
function fchk {	# Remove previous file if it exists, is a file and doesn't point somewhere
	
	if [[ -e "$dFILE" && ! -h "$dFILE" && -f "$dFILE" ]]; then
		echo " Always Backup Your Logs "
    		rm -f $dFILE
	fi
}
###########NOTE ------------------->DONE Untested
function deleter { # Used To Remove Old Files *needs Work to Drop Data Base Thru Sql ((anyone??))
    
     echo  "Which ID to delete"
     read  id_del
    ./scripts/delete.sh "$id_del"
    
    }
###########NOTE ------------------->DONE Untested
### debug log was here
###########NOTE ------------------->DONE Untested
####
if [ $1 == "-del"  ] ; then
        deleter
    fi
###########NOTE ------------------->DONE Tested Worked
####
function msg {
     echo "$1" | tee -a $dFILE
}
###########NOTE ------------------->DONE Tested Worked
####
function welcome {
	fchk
	msg "
	Welcome to the Firmware Analysis Toolkit - v0.1
	Offensive IoT Exploitation Training  - http://offensiveiotexploitation.com
	By Attify - https://attify.com  | @attifyme
	"
}

###########NOTE ------------------->DONE Tested Worked  
### 
    function getInfo { # ask for File/Dir & Name/brand Then Get Extract Options
    
    msg "Enter the name or absolute path of the firmware you want to analyse : "
    read firm_name
    msg " Enter the name/brand of the firmware "
    read firm_brand
    ###put a if no variable condition here
    msg " Make a Extraction Option Selection from Following:
   -pk    No Parallel/Kernel (Only Gets File System)(Default)
   -fk    No File/Kernel     (Only Gets Parallel)
   -np    No Parallel        (Gets Both FS And Kernel) 
   -nf    No File System     (Gets Both Parallel And Kernel)
   -nk    No Kernel          (Gets Both Parallel And Kernel)"
	msg " Enter Your Selection " 
    read ext_opt
    #ext_opt="-pk"
    if  [ $ext_opt = "-pk"  ] ; then
	
       #ext_GO="-b $D2 -sql 127.0.0.1 -np -nk $D1 images " #debugging shortcut
	ext_GO=" -b $firm_brand -sql 127.0.0.1 -np -nk $firm_name images "
    fi
    
   if [ $ext_opt = "-fk"  ] ; then
       ext_GO= -b $firm_brand -sql 127.0.0.1 -nf -nk $firm_name images
    fi
    
    if [ $ext_opt = "-np"  ] ; then
       ext_GO= -b $firm_brand -sql 127.0.0.1 -np $firm_name images
    fi
    
    if [ $ext_opt = "-nf"  ] ; then
       ext_GO= -b $firm_brand -sql 127.0.0.1 -nf $firm_name images
    fi
    
    if [ $ext_opt = "-nk"  ] ; then
       ext_GO= -b $firm_brand -sql 127.0.0.1 -nk $firm_name images
    fi
    
 }
     
	
    
    
###########NOTE ------------------->DONE Tested Worked
##'/home/oit/tools/fat/sources/extractor/extractor.py' -b 3864B -sql 127.0.0.1 -np -nk /home/oit/Firms/3864A.zip images
## does this even need to be used?
# Remove previous file if it exists, is a file and doesnt point somewhere
################################################################


    
     
    
function extractor {
	msg "Now going to extract the firmware. Hold on.."
	msg "$ext_GO"
   
	./sources/extractor/extractor.py $ext_GO | tee -a $dFILE 
	
	
  	
   	 IID=$(grep Database $dFILE | cut -d " " -f 5)
			: "${IID:=empty}"
                        if [ $IID = "empty" ] ; then 
                         msg "error extracting or finding the db number
                             read the debug log "
                            exit
			else
			msg " Your Image Has Been Tagged Number $IID and extracted as a tar file to the images folder"
                        fi
        
			
}

###########NOTE -------------------> DONE Tested Worked
## need a check for unknown
function get_arch {
                            msg "Getting image type"
                            ARCH=$(./scripts/getArch.sh ./images/$IID.tar.gz | cut -d " " -f 2)
                            : "${ARCH:=empty}"
                        if [ $ARCH == "empty" ] ; then
                                msg "The Image Arch Type Was not Returned"
                                exit
                        else    
				 msg "$ARCH"
		
                        fi
                            
}


###########NOTE ------------------->DONE Tested Worked
function tar2db {
	msg "Putting information into database"
    
   #./scripts/tar2db.py -i $IID -f ./images/$IID.tar.gz
		msg "have you run this file into the database before? Y/N "
		
		read QW
		if  [ $QW = "N" ]; then
		msg "Tar2DB" 
		./scripts/tar2db.py -i $IID -f ./images/$IID.tar.gz
		else 
		msg "Skipping Tar2Db"
	fi
}
###########NOTE ------------------->DONE Tested Worked 
# needs A single USE Clause that reads stuff before attempting to continue needs error checking refer to make image file for possible errors
function MKimage {
		msg "Creating Image"
            msg "Executing command"
		
 mk0=$( sudo ./scripts/makeImage.sh $IID)
                            : "${mk0:=empty}"
	        	if [ $mk0 == "empty" ] ; then
                                msg "The Image Was not Created correctly"
                                exit
                        else    
				frun
                        fi
		
}
#NOTE -------Here Should BE a dig and find Nv Ram ANd libs stuff in order to emulate better quicker without as much input from the user----
## but we can just be offered as a extra command or if the network fails to infer or find a console 

###########NOTE ------------------->Not DONE Untested
function frun {

	if [ $quickr == "yes" ] ; then
	fchk
	msg "Enter the Image tag number Eg 16"
	read IID
	get_arch
	fi

	msg "Running firmware ${IID}: terminating after 60 secs..."
	echo "Please Wait
			"
 timeout --preserve-status --signal SIGINT 60 ./scripts/run.${ARCH}.sh "$IID"
sleep 1
	msg "Firmware Correctly Emulated To This Point
							"
	msg "Hopefully Inferring network...	
						"
netnumber=$(./scripts/makeNetwork.py -i "$IID" -q -o -a "$ARCH" -S "./scratch/")
 : "${netnumber:=empty}"

	msg "$netnumber"
	checka=$(grep "Interfaces:" $dFILE)
	if [[ $checka == "Interfaces: "[]"" ]] ; then
		msg "Cant Get A Interface!"
		echo "Continue Or Quit?
			Continuing will debug the logs and search the firmware
            for reasons why network was not found or started (see Notes)"
            echo "C/Q"
		 read CQ
	else
		CQ=0
	fi
            if [ $CQ == "C" ]; then
                echo "After This Is Done Use -test to Start at this point again
                hopefully it will have found the issue if not it could possibly
                be run again to find any new issues coming from the emulation"
                ./scripts/debugrun.sh  $ARCH $IID -debug
		echo " We are back "
		fi	
		
}
function main {
	welcome
	getInfo
    extractor
    get_arch
    tar2db
    MKimage
}
 if [ $1 == "-go" ]; then
    main
fi
 if [ $1 == "-test" ]; then
	quickr="yes"
    frun
fi


##/home/oit/tools/fat/WNAP320 Firmware Version 2.0.3.ziptua
