# Firmware Analysis Toolkit 



**Note:** 
+ This Script will help with firmwares that produce errors in fat or firmadyne 
although i have a slightly customised firmadyne, which i will also fork.
Still A work in Progress and will update as much as i can.
but basicaly my scripts act as wrappers for firmadyne in the same way fat does execpt my scripts allow a debug route which allows the user to see the error types so that they can get their fimware running.
*** Checks for 
+ Kernel line up issues
+ cp
+ mknod errors
+ mkdir errors
+ fs errors
+ nvram errors
+ conf errors 
+ rcS Hits
+ smd errors ( may require debugging ) ## Still to be implemented
+ ssk errors ( may require debugging ) ## Still to be implemented

+ As of now, it is simply a script to automate **[Firmadyne](https://github.com/firmadyne/firmadyne)** which is a tool used for firmware emulation. In case of any issues with the actual emulation, please post your issues in the [firmadyne issues](https://github.com/firmadyne/firmadyne/issues).  

(( This Will Be Fixed in future Versions ))
+ In case you are on **Kali** and are **facing issues with emulation**, it is recommended to use the AttifyOS Pre-Release VM downloadable from [here](http://tinyurl.com/attifyos), or alternatively you could do the above mentioned.  (( This Will Be Fixed in future Versions ))

---

Firmware Analysis Toolkit is build on top of the following existing tools and projects : 

1. [Firmadyne](https://github.com/firmadyne/firmadyne)
2. [Binwalk](https://github.com/devttys0/binwalk) 
3. [Firmware-Mod-Kit](https://github.com/mirror/firmware-mod-kit)
4. [MITMproxy](https://mitmproxy.org/) 
5. [Firmwalker](https://github.com/craigz28/firmwalker) 
6. [Hitwords](https://github.com/FrankSx/Hitwords)-----|
7. [Hashfind](https://github.com/rurapenthe/hashfind)--|

## Setup instructions 

it is recommended to install the tools in the /root/tools folder, and individual tools in there. 

### Install Binwalk 

```
git clone https://github.com/devttys0/binwalk.git
cd binwalk
sudo ./deps.sh
sudo python ./setup.py install
sudo apt-get install python-lzma  :: (for Python 2.x) 
sudo -H pip install git+https://github.com/ahupp/python-magic
```

Note: Alternatively, you could also do a `sudo apt-get install binwalk`


### Setting up firmadyne 

`sudo apt-get install busybox-static fakeroot git kpartx netcat-openbsd nmap python-psycopg2 python3-psycopg2 snmp uml-utilities util-linux vlan qemu-system-arm qemu-system-mips qemu-system-x86 qemu-utils`

`git clone --recursive https://github.com/firmadyne/firmadyne.git`

`cd ./firmadyne; ./download.sh`

Edit `firmadyne.config` and make the `FIRMWARE_DIR` point to the current location of Firmadyne folder. 

### Setting up FAT

```
git clone https://github.com/attify/firmware-analysis-toolkit
mv firmware-analysis-toolkit/fat.py .
mv firmware-analysis-toolkit/reset.sh .
chmod +x fat.py 
chmod +x reset.sh
vi fat.py
```
Here, edit the [line number 25](https://github.com/FrankSx/firmware-analysis-toolkit/blob/master/fat.sh#L9) which is `firmadyne_path = '/root/tools/firmadyne'` to the correct path in your system.

### Setting up Firmware-mod-Kit 
## This May have been fixed in FMK's lastest revisions ###
## As The New FMK Runs on The Latest Binwalk ###
```
sudo apt-get install git build-essential zlib1g-dev liblzma-dev python-magic
git clone https://github.com/brianpow/firmware-mod-kit.git
```

Find the location of binwalk using `which binwalk` . Modify the file `shared-ng.inc` to change the value of variable `BINWALK` to the value of `/usr/local/bin/binwalk` (if that is where your binwalk is installed). . 

## This May 

### Setting up MITMProxy 

`pip install mitmproxy` 
or 
`apt-get install mitmproxy` 


### Setting up Hitwords

cd ./firmadyne/scripts
mkdir custom
`git clone https://github.com/FrankSx/Hitwords.git'
cd hitwords
chmod +x ./hitwords

### Setting up Hashfind

From the scripts folder :./firmadyne/scripts/
cd custom/hitwords/requires
`git clone https://github.com/rurapenthe/hashfind.git`
cp hashfind2.sh ./hashfind/
chmod +x ./hashfind/hashfind2.sh & chmod +x ./hashfind/hashfind.py


### Setting up Firmwalker 

`git clone https://github.com/craigz28/firmwalker.git` 

That is all the setup needed in order to run FAT. 


## Running FAT 

Once all the above steps have been done, go ahead and run 

`fat.sh 

+ It will ask you to enter the absolute path of the firmware. Here enter the firmware path including the file name. 

+ The script will then ask you to enter the brand name. Enter the brand which the firmware belongs to. This is for pure database storage and categorisational purposes. 

+ it will then ask for extraction options to proceed with:
 Make a Extraction Option Selection from Following:
   -pk    No Parallel/Kernel (Only Gets File System)(Default)
   -fk    No File/Kernel     (Only Gets Parallel)
   -np    No Parallel        (Gets Both FS And Kernel) 
   -nf    No File System     (Gets Both Parallel And Kernel)
   -nk    No Kernel          (Gets Both Parallel And Kernel)"

+ It will ask for password a couple of times, enter `firmadyne` in all the steps (except for your system password, obviously!)

+ this step will run the firmware and try and find a network interface . if it does not it will ask if you would like to continue down the debug path . 

+IF network interface has been found then It will Be Run, Press any key to exit

+ if the network was not found debugrun.sh will be run it will return to the 
fat script when complete to try and get a network again <<< this isnt working yet >>>>>
debugrun.sh will check for errors in the serial log and print them to the terminal,
you can select if you would like to print out what was found searching for the list
found in hitwords/hitword/blerror

+To View The Config List if Avail?
+To View The nvram realated files if Avail?
+To View The rcS & profile file if Avail?
+To See What kernel is avail on the sys and what was requested?
