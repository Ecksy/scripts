#!/bin/bash

# Enumerate all the things
# Updated 1/19/2017
# https://nmap.org/nsedoc/


communityList=~/Desktop/PWK/wordlists/common-snmp-strings.txt	#SNMP community list
dirbSmall=/usr/share/dirb/wordlists/small.txt #dirb wordlist


#exit if no switch specified
if [ $# -eq 0 ]
then
	echo "No arguments supplied."
	echo "Use -t to specify a single target, or -T to specify a text file containing targets."
	echo "Examples:"
	echo "$0 -t 192.168.95.12"
	echo "$0 -T targets.txt"
	echo "EXITING SCRIPT"
	exit 1;
fi

#process -t and -T options
while getopts ":t:T:" opt; do
	case $opt in
		t) #-t option. handles single IP address argument
			if [[ $OPTARG =~ ^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$ ]]; #IP format regex
			then
				targetFile=$OPTARG #handles both single target and file options
				
				echo "Proper IP format detected ($targetFile), continuing execution"
				singleTarget="TRUE" #for the if statement after getopts
			else
				echo "IP format incorrect. Exiting"
				exit 1;
			fi
			;;
		
		#-T option. handles file input
		T) echo "Checking IP format in file: $OPTARG..." >&2
			#if IP is provided on accident, set it to the targetFile var and break the loop
			if [[ $OPTARG =~ ^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$ ]]; #IP format regex
			then
				targetFile=$OPTARG #set targetFile to arg if regex check passes	
				echo "You provided an IP address instead of a file name."
				echo "The script will scan $targetFile, scrublord."	
				break
			fi

			#check file to verify all addresses pass regex check
			for target in $(cat $OPTARG); do
				if [[ $target =~ ^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$ ]]; #IP format regex
				then
					targetFile=$OPTARG #set targetFile to arg if regex check passes		
				else 
					echo "IP format incorrect in file ($target). Exiting" #exit if an IP address does not pass regex check
					exit 1;
				fi
				useFile='TRUE' #for the if statement after getopts
			done
			;;

		#improper options handling
		\?) echo "Invalid option: -$OPTARG" >&2
			echo "Use -t to specify a single target, or -T to specify a text file containing targets."
			echo "Examples:"
			echo "$0 -t 192.168.95.12"
			echo "$0 -T targets.txt"
			echo "EXITING SCRIPT"
			exit 1 ;;

		#improper options handling
		:) echo "Option -$OPTARG requires an argument." >&2
			echo "Use -t to specify a single target, or -T to specify a text file containing targets."
			echo "Examples:"
			echo "$0 -t 192.168.95.12"
			echo "$0 -T targets.txt"
			echo "EXITING SCRIPT"
			exit 1 ;;
	esac
done


#if user provided a file and all entries pass regex check
if [[ $useFile == 'TRUE' ]];
then
	echo "Proper IP format detected, continuing execution on the following targets:"
	cat $targetFile
elif [[ $singleTarget == 'TRUE' ]];
then
	#fix issue with single target scan not working
	#because the following loops cat a text file for targeting
	#contents of the targetFile var is echo'd to a text file
	#then text file name is assigned to targetFile
	#loops will still run, but only 1 iteration
	echo "Scanning single target: $targetFile"
	echo $targetFile > tempTarget.txt
	targetFile=tempTarget.txt
fi


echo
echo
echo "############### SCANNING TCP WITH UNICORNSCAN ###############"
echo
#run unicornscan on up hosts
# working 
for target in $(cat $targetFile); do
	currentFile=$target-unicorn.txt	#unicornscan file
	nmapFile=$target-nmap		#nmap file

	echo "Running unicorn scan on: $target. Saving results to $currentFile"
	echo "unicornscan $target | tee $currentFile" &
	unicornscan $target | tee $currentFile
	echo

done


echo
echo
echo "############### SCANNING UDP PORTS WITH NMAP ###############"
echo
#scan for udp 69 and 161
# working
for target in $(cat $targetFile); do
	echo "nmap -sU -p 69,161 $target -oA $target-udp"
	nmap -sU -p 69,161 $target -oA $target-udp

done


echo
echo
echo "############### SCANNING TCP PORTS WITH NMAP ###############"
echo
#scan ports discovered from unicornscan, working
for target in $(cat $targetFile); do
	currentFile=$target-unicorn.txt	#unicornscan file
	nmapFile=$target-nmap		#nmap file
	#pull port numbers in same line, comma seperated
	ports=$(cat $currentFile | cut -d "]" -f 1 | cut -d "[" -f 2 | sed 's/ //g' | sed -n -e 'H;${x;s/\n/,/g;s/^,//;p;}')
	echo "ports: $ports"
	nmap -O -A -v -p$ports $target -oA $nmapFile
done



echo
echo
echo "############### SCANNING SNMP HOSTS ###############"
echo
#SNMP enumeration, working
for target in $(cat $targetFile); do
	#loop through targets list, then check against grpable nmap UDP files
	if grep -Fq "161/open" $target-udp.gnmap #fix issue where "open/filtered" stil gets scanned
	then
		echo "scanning $target for community strings"
		onesixtyone -c $communityList $target | tee $target-community.txt
		for string in $(cat $target-community.txt | uniq | cut -d "]" -f 1 | cut -d "[" -f 2 | grep -v Scanning); do
			echo "SNMP found on $target"
			echo "Running snmp-check using community string: $string"
			snmp-check -t $target -c public | tee $target-snmp-check-$string.txt
			snmpwalk -c $string -v1 $target | tee $target-snmpwalk-$string.txt #need to implement -v2c
		done
	fi
done


echo
echo
echo "############### SCANNING FTP ANONYMOUS LOGIN ###############"
echo
#FTP anon login check, working
for target in $(cat $targetFile); do
	if grep -Fq "21/open" $target-nmap.gnmap
	then
		nmap -sV -sC --script ftp-anon -p21 $target -oG $target-FTP-anon
	fi
done

echo
echo
echo "############### SCANNING SMB/SAMBA HOSTS ###############"
echo
#SMB/Samba scanning, working
for target in $(cat $targetFile); do
	#check for SMB or Samba
	if grep -Fq "445/open/tcp//microsoft-ds" $target-nmap.gnmap
	then
		echo "Scanning SMB service.."
		enum4linux -U -M -S -P -G -o $target
		echo
		echo
		nmap -vv -Pn -sC -sS -T 4 --script smb-vuln-conficker.nse,smb-vuln-cve2009-3103.nse,smb-vuln-ms06-025.nse,smb-vuln-ms07-029.nse,smb-vuln-ms08-067.nse,smb-vuln-ms10-054.nse,smb-vuln-ms10-061.nse,smb-vuln-regsvc-dos.nse -p 445 -oN 10.11.1.5-smb $target -oA $target-NSE-SMB

	elif grep -Fq "445/open/tcp//netbios-ssn//Samba" $target-nmap.gnmap
	then
		echo "Scanning Samba service.."
		enum4linux -U -M -S -P -G -o $target
		echo
		echo
		nmap -vv -Pn -sC -sS -T 4 --script smb-vuln-conficker.nse,smb-vuln-cve2009-3103.nse,smb-vuln-ms06-025.nse,smb-vuln-ms07-029.nse,smb-vuln-ms08-067.nse,smb-vuln-ms10-054.nse,smb-vuln-ms10-061.nse,smb-vuln-regsvc-dos.nse -p 445 -oN 10.11.1.5-smb $target -oA $target-NSE-SMB
	fi
	
done


s

echo
echo
echo "############### SCANNING HTTP/HTTPS HOSTS WITH NIKTO ###############"
echo
#HTTP/HTTPS scans
for target in $(cat $targetFile); do
	#assign port numbers to var for HTTPS
	httpsPorts=$(cat $target-unicorn.txt | grep https | cut -d "[" -f 2 | cut -d "]" -f 1 | sed 's/ //g');

	for port in $(echo $httpsPorts);do
		echo "Executing nikto scan on  $target:$port"
		nikto -host https://$target:$port/ -output $target-nikto-$port.html
	done

	#assign port numbers to var for HTTP
	httpPorts=$(cat $target-unicorn.txt | grep http | grep -v https | cut -d "[" -f 2 | cut -d "]" -f 1 | sed 's/ //g');
	for port in $(echo $httpPorts);do
		echo "Executing nikto scan on  $target:$port"
		nikto -host http://$target:$port/ -output $target-nikto-$port.html
	done	
done


echo
echo
echo "############### NON-RECURSIVE HTTP/HTTPS FUZZING WITH DIRB ###############"
echo
for target in $(cat $targetFile); do
	#assign port numbers to var for HTTPS
	httpsPorts=$(cat $target-unicorn.txt | grep https | cut -d "[" -f 2 | cut -d "]" -f 1 | sed 's/ //g');
	
	#HTTP scan
	for port in $(echo $httpsPorts);do
		echo "scanning $target:$port with dirb..."
		dirb https://$target:$port/ $dirbSmall -r -o $target-dirb-$port.txt
	done

	#assign port numbers to var for HTTP
	httpPorts=$(cat $target-unicorn.txt | grep http | grep -v https | cut -d "[" -f 2 | cut -d "]" -f 1 | sed 's/ //g');
	
	#HTTP scan
	for port in $(echo $httpPorts);do
		echo "scanning $target:$port with dirb..."
		dirb http://$target:$port/ $dirbSmall -r -o $target-dirb-$port.txt
	done
done


echo
echo
echo "############### Heartbleed Scan (auxiliary/scanner/ssl/openssl_heartbleed) ###############"
echo
for target in $(cat $targetFile); do
	#assign port numbers to var for HTTPS
	httpsPorts=$(cat $target-unicorn.txt | grep https | cut -d "[" -f 2 | cut -d "]" -f 1 | sed 's/ //g');

		#scan based on port number
		#msfconsole one-liner, exit msfconsole when done
		for port in $(echo $httpsPorts);do
			msfconsole -x "sleep 3;\
			use auxiliary/scanner/ssl/openssl_heartbleed;\
			set RHOSTS 10.11.1.8;\
			set VERBOSE true;\
			set RPORT $port;\
			run;\
			exit -y;" | tee $target-heartbleed-$port.txt
		done
done



echo
echo
echo "############### SCRIPT COMPLETE. CHECK OUTPUT FILES ###############"\
