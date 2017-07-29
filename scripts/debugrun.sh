#!/usr/bin/env bash
# ./scripts/debugrun.sh $ARCH $IID
set -u
ARCH=$1
IID=$2
dFILE=./tmp/debugOUT.txt # Debugging and testing purposes
tmp1=./tmp/tmp1
scratch="./scratch"
images="./images/"
hitwords="./scripts/custom/hitwords/hitwords"
logfile=$scratch/$IID/qemu.initial.serial.log 

###########NOTE ----message function--------------->DONE Tested Worked
####
function msg {
     echo "$1" | tee -a $dFILE
}
function fchk {	# Remove previous file if it exists, is a file and doesn't point somewhere
	
	if [[ -e "$tmp1" && ! -h "$tmp1" && -f "$tmp1" ]]; then
		echo " Always Backup Your Logs "
    		rm -f $tmp1
	fi
}
function getArray {
    array=() # Create array
    while IFS= read -r line
    do
        array+=("$line")
    done < "$1"
}

function prepimgsearch {    
   sudo ./scripts/mount.sh $IID >/dev/null 2>&1
   }
function killimgsearch {    
   sudo ./scripts/umount.sh $IID >/dev/null 2>&1
   }

function welcome {
	msg "
			Welcome to the Firmware Analysis Toolkit 
					- v1.0 - 
			Firmware file system modification tool
				(Attify)- v0.1
    				(FrankSX)- v1.0
						"
 }

function Finder {
		fchk
		msg " "
		msg "	***Reading the Serial log file for known errors***"
		getArray "./scripts/custom/hitwords/hitword/blerror"
		patterns=("${array[@]}")  
		: "${patterns:=empty}"
		for pattern in "${patterns[@]}"; do
    			msg "		############## $pattern"
		patternout=$(grep "$pattern" $logfile)
		: "${patternout:=empty}"
		if [[ $patternout != "empty" ]]; then
				msg "Matches Found For: $pattern"
				echo "$pattern" | uniq | tee -a $tmp1 >/dev/null 2>&1
		fi
		if [[ $patternout = "empty" ]]; then
			msg " "
    			msg "No Matches For $pattern"	
		fi 
    done
	msg " are you ready to continue "
	read ct0
	msg " "
        msg "Errors Found :"
	nvram0="0"
        rcs="0"
	fserr="0"
        conf="0"
	liberr="0"
        
        getArray "./tmp/tmp1"
		patterns=("${array[@]}")  
		: "${patterns:=empty}"
		for pattern in "${patterns[@]}"; do

	if [[ $pattern = "/lib/modules/" ]]; then
		liberr="1"
            msg " module errors found maybe because of fs requiring modules from a early or later kernel  "
            msg '
		#this may require obtaining the original kernel and placing its modules in the correct place,
		# along side firmadynes, ( really hacky ) but works sort of :)
		#
		# '
            msg "		############## Hits Found ###############"
            patternout=$(grep "$pattern" $logfile)
            msg "$patternout"
        fi	




    if [[ $pattern = "nrvam" ]]; then
		nvram0="1"
            msg " nvram errors found may need to build a custom nvram lib "
            msg '
#this many be done on the fly via searching calls to nvram lib ,
 #finding apps in the bin that call the ram set and do set/get or seeing what is requested in the logs
#to just wait on calls means that functions requiring the whole set
 #will have be to built in order to better emulate the original '
            msg "		############## Hits Found ###############"
            patternout=$(grep "$pattern" $logfile)
            msg "$patternout"
        fi
    if [[ $pattern = "mkdir" ]]; then
            msg "  "
	    msg "		############## $pattern ############### "
msg "
# Couldn't Create A Directory Made At Runtime,
 # May be a permissions error or a file system issue
# "
        msg "		############## 	       ############### "
        msg " "
        msg "		############## Hits Found ###############"
        patternout=$(grep "$pattern" $logfile)
            msg "$patternout"
        fi
    if [[ $pattern = "mknod" ]]; then
        msg " "
        msg "		############## $pattern ############### "
        msg "		#	      mknod errors "
        msg "
                #if this occurs with ext errors
                #the file sys will need to be re imaged as a ext3 or another var
                #"
		msg "		############## 	       ############### "
        msg " "
        msg "		############## Hits Found ###############"
            patternout=$(grep "$pattern" $logfile)
        msg "$patternout"
        fi
    if [[ $pattern = "starting" ]]; then
	msg " "
	msg "		############## $pattern ############### "
            msg " this shows the starting pid  "
	msg "		############## 	       ############### "

            msg " "
             msg "		############## Hits Found ###############"
            patternout=$(grep "$pattern" $logfile)
            msg "$patternout"
        fi
    if [[ $pattern = "rcS" ]]; then
		rcs="1"
		msg " "
		msg "		############## $pattern ############### "
		msg " 		#if the rcS has loaded this is most likely where"
 		msg "		#the issues will lay with most systems at least to boot"
		msg "		############## 	       ############### "
      
        msg " "
        msg "		############## Hits Found ###############"
        patternout=$(grep "$pattern" $logfile)
        msg "$patternout"
        fi
    if [[ $pattern = "failed" ]]; then
		msg " "
		msg "		############## $pattern ############### "
            msg " Some Thing Failed "
		msg "		############## 	       ############### "
           
        msg " "
        msg "		############## Hits Found ###############"
        patternout=$(grep "$pattern" $logfile)
        msg "$patternout"
        fi
     if [[ $pattern = "fs errors" ]]; then
		msg " "
		fserr="1"
		msg "		############## $pattern ############### "
            msg " fs errors found "
           msg "
                #if this occurs with ext errors
                #the file sys will need to be re imaged as a ext3 or another var
                #"
		msg "		############## 	       ############### "
        msg " "
        msg "		############## Hits Found ############# "
            patternout=$(grep "$pattern" $logfile)
            msg "$patternout"
        fi
            if [[ $pattern = "conf" ]]; then
            conf="1"
            msg " "
            msg "		############## $pattern ############### "
            msg " conf errors "
            msg " config errors will need to be sorted by hand "
            msg "		############## 	       ############### "
                msg " "
                 msg "		############## Hits Found ###############"
                patternout=$(grep "$pattern" $logfile)
                msg "$patternout"
            fi
    done
}   

function options2 {
	msg " "
	msg "Going To Mount The Fs Now "
	prepimgsearch
	msg " Do you Want to View The Config List if Avail? ? Y/N "
	read yn0
	msg " Do you Want to View The nvram realated files if Avail? ? Y/N "
	read yn1
	msg " Do you Want to View The rcS & profile file if Avail? ? Y/N "
	read yn2
	msg " Do you Want to See What kernel is avail on the sys? Y/N "
	read yn3
	
	if [[ $conf = "1" && $yn0 = "Y" ]] ; then
	msg "		############## config file locations ############### "
      sudo $hitwords -conf $scratch/$IID/image/
	msg " are you ready to continue "
	read ct0
	msg " "
	fi
    if [[ $nvram0 = "1" && $yn1 = "Y" ]] ; then
	msg "		############## nvram related hits in file system ############### "
      sudo $hitwords -qdm nvram $scratch/$IID/image/
	msg " are you ready to continue "
	read ct0
	msg " "
	fi
    if [[ $rcs = "1" && $yn2 = "Y" ]] ; then
       rcs0=( $( find $scratch/$IID/image/ -name rcS  ) )
	pro0=( $( find $scratch/$IID/image/ -name profile  ) )
	msg "		############## rcS file ############### "
       cat $rcs0
	msg " are you ready to continue "
	read ct0
	msg " "
	msg "		############## Profile file ############### "
       cat $pro0
       
	fi
	if [[ $liberr = "1" && $yn3 = "Y" ]] ; then
	kern=( $(ls  $scratch/$IID/image/lib/modules/ ) )
	kernerr=$(grep "/lib/modules/" $logfile )
	msg "		############## Kernel type On Fs ############### "
	msg " $kern "
	msg "		############## Requested Kernel type On Boot ############### "
     	msg " $kernerr "
	msg " are you ready to continue "
	read ct0
	msg " "
	fi
	msg " Unmounting fs now "
	killimgsearch
}

if [ $3 = "-debug" ]; then
	welcome
	Finder
	options2
fi
