#! /bin/bash

# This script is used to create a remote tunnel to a rpi server
# It is used to connect to the rpi server from a remote location
# with SocketXp

# The script is called from the command line with the following parameters

# 1 = the authentication token to be used for SocketXp
# 2 = the port number to use for the tunnel
# 3 = the user name to use for the ssh connection
# 4 = the ip address of the rpi server
# 5 = the device id to use connect with

# Example 
# sudo -S socketxp connect tcp://$username:$ip --iot-slave --peer-device-id $deviceId --peer-device-port $portNumber --authtoken $authToken

function checkSudo {
    prompt=$(sudo -nv 2>&1)

    if [ $? -eq 0 ]; then
      # exit code of sudo-command is 0
      # "has_sudo__pass_set"
      echo 1
    elif echo $prompt | grep -q '^sudo:'; then
      # "has_sudo__needs_pass"
      echo 0
    else
      # "no_sudo"
      echo -1
    fi
}

function helper {
    echo '''
    Usage: remote-tunnelling [OPTIONS]

    -h or --help: show this help message and exit
    -a or --auth: the authentication token to be used for SocketXp
    -d or --device-id: the device id to use connect with
    -o or --host: the ip or host address of the rpi server
    -p or --port: the port number to use for the tunnel
    -u or --user: the user name to use for the ssh connection

    Example 
    remote-tunnelling.sh -a your-auth-token -d your-device-id -o your-host-address -p your-open-server-port -u your-user-name-to-connect-with
    '''
}

if [[ $@ == *"-h"* || $@ == *"--help"* ]]
then
    helper
else
    GOOD_TO_GO=false
    if [[ $@ == *"--auth "* || $@ == *"--device-id "* || $@ == *"--host "* || $@ == *"--port "* || $@ == *"--user "* ]]
    then
        GOOD_TO_GO=true
    fi

    if [[ $@ == *"-a "* || $@ == *"-d "* || $@ == *"-o "* || $@ == *"-p "* || $@ == *"-u "* ]]
    then
        GOOD_TO_GO=true
    fi

    isPipePassed=false
    if [[ -p /dev/stdin ]]
    then
        password=$(cat -)
        isPipePassed=true
    fi

    if [ $GOOD_TO_GO == false ]
    then
        echo "Invalid arguments"
        helper
        exit 1
    fi

    # split arguments into an array with spaces as delimiter
    IFS=' ' read -r -a args <<< "$@"

    if [ "${#args[@]}" != "10" ]
    then
        echo "Not enough arguments"
        helper
        exit 1
    fi

    # for loop with index and value of each argument
    for i in "${!args[@]}"
    do
        if [ "${args[$i]}" == "-a" ] || [ "${args[$i]}" == "--auth" ]
        then
            authToken=${args[$i+1]}
        fi
        if [ "${args[$i]}" == "-d" ] || [ "${args[$i]}" == "--device-id" ]
        then
            deviceId=${args[$i+1]}
        fi
        if [ "${args[$i]}" == "-o" ] || [ "${args[$i]}" == "--host" ]
        then
            host=${args[$i+1]}
        fi
        if [ "${args[$i]}" == "-p" ] || [ "${args[$i]}" == "--port" ]
        then
            portNumber=${args[$i+1]}
        fi
        if [ "${args[$i]}" == "-u" ] || [ "${args[$i]}" == "--user" ]
        then
            username=${args[$i+1]}
        fi
    done
    
    if [ ! -z "$check1" ]
    then
        isSudo=$(check-sudo)
    elif [ ! -z "$check2" ]
    then
        isSudo=$(sh check-sudo.sh)
    else
        isSudo=$(checkSudo)
    fi

    if [[ $isSudo == 0 && $isPipePassed ]]
    then
        echo "You need to run this script with sudo"
        echo "Use this script as -> echo 'your password' | remote-tunnelling"
        exit 1
    fi
    if [[ $isSudo == -1 ]]
    then
        echo "You need to install sudo"
        exit 1
    fi

    echo "Tunnel opened, you can now connect to the rpi server with SocketXp"
    if  [[ $isPipePassed ]]
    then 
        echo $password | sudo -S socketxp connect tcp://$username:$host --iot-slave --peer-device-id $deviceId --peer-device-port $portNumber --authtoken $authToken
    else
        sudo socketxp connect tcp://$username:$host --iot-slave --peer-device-id $deviceId --peer-device-port $portNumber --authtoken $authToken 
    fi
fi
