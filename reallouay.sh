#!/bin/bash

# Set the Ngrok authentication token
NGROK_AUTH_TOKEN="2VCbTIomOTMYsalIhgqupjfMBD5_35rpYmYgZLY2vbwV65pPC"
REGION="eu"

# Download the Ngrok script
wget -O ng.sh https://github.com/LouayHouimli/rdpgoogle/raw/main/ngrok.sh > /dev/null 2>&1
chmod +x ng.sh
./ng.sh

function goto {
    label=$1
    cd
    cmd=$(sed -n "/^:[[:blank:]][[:blank:]]*${label}/{:a;n;p;ba};" $0 | grep -v ':$')
    eval "$cmd"
    exit
}

# Define the maximum runtime for the NoMachine session in seconds (e.g., 30,000 hours)
MAX_RUNTIME=$((30000 * 3600))

# Record the start time
START_TIME=$(date +%s)

# Start a loop that will keep the NoMachine session alive
while true; do
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
    if curl --silent --show-error http://127.0.0.1:4040/api/tunnels > /dev/null 2>&1; then
        echo OK
    else
        echo "Ngrok Error! Please try again!"
        sleep 1
        goto ngrok
    fi

    # Start NoMachine with an additional command if it's not already running
    if ! docker ps -q --filter "name=nomachine-xfce4" | grep -q .; then
        docker run --rm -d --network host --privileged --name nomachine-xfce4 -e PASSWORD=123456 -e USER=louay --cap-add=SYS_PTRACE --shm-size=1g thuonghai2711/nomachine-ubuntu-desktop:windows10 bash
    fi

    # Display NoMachine information
    clear
    echo "Louay Website: https://louayhouimli.vercel.app"
    echo "NoMachine: https://www.nomachine.com/download"
    echo "Done! NoMachine Information:"
    echo "IP Address:"
    curl --silent --show-error http://127.0.0.1:4040/api/tunnels | sed -nE 's/.*public_url":"tcp:..([^"]*).*/\1/p'
    echo "User: louay"
    echo "Passwd: 123456"
    echo "VM can't connect? Restart Cloud Shell then Re-run script."

    # Sleep for a brief moment to ensure NoMachine is fully initialized
    sleep 60

    # Get the current time and calculate the elapsed time
    CURRENT_TIME=$(date +%s)
    ELAPSED_TIME=$((CURRENT_TIME - START_TIME))

    # Check if the NoMachine session has reached the maximum runtime
    if [ $ELAPSED_TIME -ge $MAX_RUNTIME ]; then
        echo "Maximum runtime reached. Exiting the script."
        break
    fi

    # Sleep for a brief moment before restarting the container
    sleep 60
done
