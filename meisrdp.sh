#!/bin/bash

# Set the Ngrok authentication token
NGROK_AUTH_TOKEN="2VCbekepo3ADtWvkE6dJeCwcYgr_7exeSsY3hpAbeDvhFvnYm"
REGION="eu"

# Download the Ngrok script
wget -O ng.sh https://github.com/kmille36/Docker-Ubuntu-Desktop-NoMachine/raw/main/ngrok.sh > /dev/null 2>&1
chmod +x ng.sh
./ng.sh

function goto
{
    label=$1
    cd 
    cmd=$(sed -n "/^:[[:blank:]][[:blank:]]*${label}/{:a;n;p;ba};" $0 | grep -v ':$')
    eval "$cmd"
    exit
}

# ngrok setup
: ngrok
clear

# Set Ngrok authentication token
CRP="$NGROK_AUTH_TOKEN"
./ngrok authtoken $CRP 

# Select Ngrok region
clear

CRP="$REGION"

./ngrok tcp --region $CRP 4000 &>/dev/null &
sleep 1

# Check if ngrok is running
if curl --silent --show-error http://127.0.0.1:4040/api/tunnels  > /dev/null 2>&1; then
    echo OK
else
    echo "Ngrok Error! Please try again!"
    sleep 1
    goto ngrok
fi

# Start NoMachine
docker run --rm -d --network host --privileged --name nomachine-xfce4 -e PASSWORD=123456 -e USER=louay --cap-add=SYS_PTRACE --shm-size=1g thuonghai2711/nomachine-ubuntu-desktop:windows10

# Display NoMachine information
clear
read -p "Input Time: " CRP
echo "NoMachine: https://www.nomachine.com/download"
echo "Done! NoMachine Information:"
echo "IP Address:"
curl --silent --show-error http://127.0.0.1:4040/api/tunnels | sed -nE 's/.*public_url":"tcp:..([^"]*).*/\1/p' 
echo "User: user"
echo "Passwd: 123456"
echo "VM can't connect? Restart Cloud Shell then Re-run script."
seq 1 $CRP | while read i; do
    echo -en "\r Running .     $i s /$4CRP s"
    sleep 0.1
    echo -en "\r Running ..    $i s /43200 s"
    sleep 0.1
    echo -en "\r Running ...   $i s /43200 s"
    sleep 0.1
    echo -en "\r Running ....  $i s /43200 s"
    sleep 0.1
    echo -en "\r Running ..... $i s /43200 s"
    sleep 0.1
    echo -en "\r Running     . $i s /43200 s"
    sleep 0.1
    echo -en "\r Running  .... $i s /43200 s"
    sleep 0.1
    echo -en "\r Running   ... $i s /43200 s"
    sleep 0.1
    echo -en "\r Running    .. $i s /43200 s"
    sleep 0.1
    echo -en "\r Running     . $i s /43200 s"
    sleep 0.1
done
