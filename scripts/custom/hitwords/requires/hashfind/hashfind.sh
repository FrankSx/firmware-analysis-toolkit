#!/usr/bin/env bash
set -e
set -u

echo '>>>>>>>>>>>>###to dis/enable options change .sh to suit##<<<<<<<<<<<<<<<<<<'
	listings1=( $(./Requires/hashfind-master/hashfind.py -m 1 -n -i "$1") )
	: "${listings1:=empty}"
	if [[ $listings1 != "empty" ]]; then 
		echo '>>>>>>>>>>>>md5<<<<<<<<<<<<<<<<<<'
		for listing in "${listings1[@]}"; do
		echo "$listing" 
		done
	fi

	listings2=( $(./Requires/hashfind-master/hashfind.py -m 8 -n -i "$1") )
	: "${listings2:=empty}"
	if [[ $listings2 != "empty" ]]; then 
		echo '>>>>>>>>>>>>unixmd5old<<<<<<<<<<<<<<<<<<'
		for listing in "${listings2[@]}"; do
		echo "$listing"
		done
	fi
	
	listings3=( $(./Requires/hashfind-master/hashfind.py -m 9 -n -i "$1") )
	: "${listings3:=empty}"
	if [[ $listings3 != "empty" ]]; then
		echo '>>>>>>>>>>>>sha512crypt<<<<<<<<<<<<<<<<<<'
		for listing in "${listings3[@]}"; do
		echo "$listing" | uniq
		done
	fi

	listings4=( $(./Requires/hashfind-master/hashfind.py -m 12 -n -i "$1") )
	: "${listings4:=empty}"
	if [[ $listings4 != "empty" ]]; then
		echo '>>>>>>>>>>>>sha256<<<<<<<<<<<<<<<<<<'
		for listing in "${listings4[@]}"; do
		echo "$listing" | uniq
		done
	
	fi
	
	listings5=( $(./Requires/hashfind-master/hashfind.py -m 13 -n -i "$1") )
	: "${listings5:=empty}"
	if [[ $listings5 != "empty" ]]; then
		echo '>>>>>>>>>>>>sha384<<<<<<<<<<<<<<<<<<'
		for listing in "${listings5[@]}"; do
		echo "$listing" | uniq
		done
	fi
	
	listings6=( $(./Requires/hashfind-master/hashfind.py -m 14 -n -i "$1") )
	: "${listings6:=empty}"
	if [[ $listings6 != "empty" ]]; then
		echo '>>>>>>>>>>>>sha512<<<<<<<<<<<<<<<<<<'
		for listing in "${listings6[@]}"; do
		echo "$listing" | uniq
		done
	
	fi
	
	listings7=( $(./Requires/hashfind-master/hashfind.py -m 15 -n -i "$1") )
	: "${listings7:=empty}"
	if [[ $listings7 != "empty" ]]; then
		echo '>>>>>>>>>>>>sha1<<<<<<<<<<<<<<<<<<'
		for listing in "${listings7[@]}"; do
		echo "$listing" | uniq
		done
	fi


	listings8=( $(./Requires/hashfind-master/hashfind.py -m 16 -n -i "$1") )
	: "${listings8:=empty}"
	if [[ $listings8 != "empty" ]]; then
		echo '>>>>>>>>>>>>blowfish<<<<<<<<<<<<<<<<<<'
		for listing in "${listings8[@]}"; do
		echo "$listing" | uniq
		done
	fi
	
	
	listings11=( $(./Requires/hashfind-master/hashfind.py -m 20 -n -i "$1") )
	: "${listings11:=empty}"
	if [[ $listings11 != "empty" ]]; then
		echo '>>>>>>>>>>>>sha256unix<<<<<<<<<<<<<<<<<<'
		for listing in "${listings11[@]}"; do
		echo "$listing" | uniq
		done
	fi

	if [[ $listings11 = "empty" && $listings8 = "empty" && $listings7 = "empty" && $listings6 = "empty" && $listings5 = "empty" && $listings4 = "empty" && $listings3 = "empty" && $listings2 = "empty" && $listings1 = "empty" ]]; then
	echo "No Hashes Found"
	exit
	else
		echo "Hashes Found"
	fi 
	
	
	
	
	
	
##echo '>>>>>>>>>>>>mysqlold<<<<<<<<<<<<<<<<<<'
##echo '>>>>>>>###not scanning###<<<<<<<<<<<<<<<<<<'
#listings#=( $(./Requires/hashfind-master/hashfind.py -m 2 -n -i "$1"
##echo '>>>>>>>>>>>>joomla<<<<<<<<<<<<<<<<<<'
##listings#=( $(./Requires/hashfind-master/hashfind.py -m 3 -n -i "$1"
##echo '>>>>>>>>>>>>md5<<<<<<<<<<<<<<<<<<'
##listings#=( $(./Requires/hashfind-master/hashfind.py -m 4 -n -i "$1"
##echo '>>>>>>>>>>>>md5<<<<<<<<<<<<<<<<<<'
##listings#=( $(./Requires/hashfind-master/hashfind.py -m 5 -n -i "$1"
##echo '>>>>>>>>>>>>md5<<<<<<<<<<<<<<<<<<'
##listings#=( $(./Requires/hashfind-master/hashfind.py -m 6 -n -i "$1"
##echo '>>>>>>>>>>>>md5<<<<<<<<<<<<<<<<<<'
##listings#=( $(./Requires/hashfind-master/hashfind.py -m 7 -n -i "$1"
#listings#=( $(./Requires/hashfind-master/hashfind.py -m 21 -n -i "$1"
#listings#=( $(./Requires/hashfind-master/hashfind.py -m 22 -n -i "$1"
#listings#=( $(./Requires/hashfind-master/hashfind.py -m 23 -n -i "$1"
#listings#=( $(./Requires/hashfind-master/hashfind.py -m 24 -n -i "$1"
#listings#=( $(./Requires/hashfind-master/hashfind.py -m 25 -n -i "$1"
#listings#=( $(./Requires/hashfind-master/hashfind.py -m 26 -n -i "$1"
#listings#=( $(./Requires/hashfind-master/hashfind.py -m 27 -n -i "$1"
#listings#=( $(./Requires/hashfind-master/hashfind.py -m 28 -n -i "$1"
#listings#=( $(./Requires/hashfind-master/hashfind.py -m 29 -n -i "$1"
#listings#=( $(./Requires/hashfind-master/hashfind.py -m 30 -n -i "$1"
#listings#=( $(./Requires/hashfind-master/hashfind.py -m 31 -n -i "$1"
#listings#=( $(./Requires/hashfind-master/hashfind.py -m 32 -n -i "$1"

#1: md5,
            ## 2: mysqlold,
             ##3: joomla,
             ##4: vbulletin,
            ## 5: phpbb3,
            ## 6: wordpressmd5,
             ##7: drupal,
 #            8: unixmd5old,
 #            9: sha512crypt,
 #            10: email,
             ##11: rcc,
 #            12: sha256,
 #            13: sha384,
 #            14: sha512,
 #            15: sha1,
 #            16: blowfish,
#	         17: des,
#	         18: md5apr,
#	         19: md5sun,
#	         20: sha256unix,
	         ##21: aixmd5,
			## 22: aixssha256,
			## 23: aixssha512,
			 ##24: aixssha1,
			## 25: osx,
			 ##26: hmacsha1,
			# 27: sybase,
			 ##28: cisco8,
			 ##29: cisco9,
			# 30: djangosha256,
			## 31: nsldap,
			# 32: djangosha1,
			# 33: mssql2005,
			# 34: mssql2000,
			## 35: ldapssha512,
			# 36: phps,
			# 37: mediawiki}
