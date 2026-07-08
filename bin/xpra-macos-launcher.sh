#!/bin/bash

declare d0

echo "Making sure we have a teleport session..."
tsh login --proxy=v6.dev.bloomberg.com
d0=$?
if [ ! $d0 = '0' ];then
    echo "Did you start the BBVPN?"
    exit $d0
fi

# Define the path to the hostname file
declare hostnameFile
hostnameFile="$HOME/.xpra-macos-launcher-hostname"
echo "Hostname file path: $hostnameFile"

declare hostname
# Check if the hostname file exists
if [ ! -f "$hostnameFile" ]; then
    echo "Hostname file does not exist. Prompting for hostname."

    # Prompt the user for the hostname
    read -r -p "Enter the hostname: " hostname
    echo "Hostname entered: $hostname"

    # Save the hostname to the file
    echo "$hostname" > "$hostnameFile"
    echo "Hostname saved to file."
else
    echo "Hostname file exists. Reading hostname from file."

    # Read the hostname from the file
    hostname=$(cat "$hostnameFile")
    echo "Hostname read from file: $hostname"
fi

# Define the path to the hostname file
declare xtermFile
xtermFile="$HOME/.xpra-macos-launcher-xterm-cmd"
echo "Xterm command file path: $xtermFile"

# Check if the xterm file exists
declare resp
declare xterm
if [ ! -f "$xtermFile" ]; then
    echo "Xterm command file does not exist. Prompting for xterm command."

    # Prompt the user for the xterm
    echo "Enter the full path to xterm on the remote host and any options you would like to specify."
    read -r -p "The default is '/opt/bb/bin/xterm -ls': " resp
    xterm="${resp##*( )}"  # Remove leading spaces
    xterm="${xterm%%*( )}" # Remove trailing spaces
    if [ -z "$xterm" ] ; then
        echo "Using default."
    else
        echo "Xterm command entered: $xterm"
    fi

    # Save the xterm to the file
    echo "$xterm" > "$xtermFile"
    echo "Xterm command saved to file."
else
    echo "Xterm command file exists. Reading xterm command from file."

    # Read the xterm from the file
    xterm=$(cat "$xtermFile")
    echo "Xterm command read from file: $xterm"
fi

# Try running xpra id in the remote host. If it fails, we need to attach in
# start mode, if it succeeds, we can attach without starting anything
echo "Checking if Xpra session exists on $hostname..."
"ssh" "$hostname" xpra id
d0=$?
if [ $d0 = '0' ]; then
    echo "Attaching to existing Xpra session on $hostname."
    nohup xpra attach "ssh://$hostname" &
else
    echo "No Xpra session found on $hostname."

    # collect the list of machines and scp to the target host
    echo "Sending list of hosts and xterm config to $hostname..."
    tsh ls | grep -v "Node Name" | grep -v -- "-------------" > "$HOME/.xpra-macos-launcher-tsh-ls-output"
    scp "$HOME/.xpra-macos-launcher-tsh-ls-output" "${hostname}:.xterm-launcher-tsh-ls-output"
    scp "$xtermFile" "${hostname}:.xterm-launcher-xterm-cmd"

    # Execute the first two commands in the foreground
    echo "ssh $hostname loginctl enable-linger"
    ssh "$hostname" loginctl enable-linger
    d0=$?
    if [ ! $d0 = '0' ]; then
        echo "Failed to enable-linger."
        echo "If you see an ssh error above, make sure you follow the documentation to configure your local ssh: https://bburl/xorgapplications#ssh"
        echo "If you see Interactive authentication required, please make sure the remote machine is RHEL8.8+."
        read -r -p "Press Enter to exit" resp
        exit $d0
    fi

    echo "ssh $hostname systemctl --user start xpra"
    ssh "$hostname" systemctl --user start xpra

    # Execute the third command in the background
    echo "Starting Xpra session on $hostname..."
    nohup xpra attach --start="/bb/libexec/xterm-launcher/bin/xterm-launcher" "ssh://$hostname" &
fi

# Exit the script
exit 0
