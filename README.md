# Run At Me

Scripts created for increasing productivity & help the devs.

## Scripts

### Check Sudo

The script checks whether the device has `sudo` command or not. If the command exists, it checks shell has `sudo` permission.
Outputs:

- `Zero(0)` means have `sudo` commands, but it does not have `sudo` powers/permissions on that terminal.
- `One(1)` means have `sudo` commands, but it has `sudo` powers/permissions on that terminal.
- `Minus One(-1)` means have no `sudo` commands.

#### How to use

```bash
sh check-sudo.sh
OR
bash check-sudo.sh
```

### Create SH Binary

This script creates *binary files* of a given `bash` script to be run on **Unix/Linux** based machines.

#### Before run anything

- Be sure to have this awesome tool called `shc`. You can access [here](https://github.com/neurobin/shc).
  - For ubuntu or debian based OS:

    ```bash
    sudo add-apt-repository ppa:neurobin/ppa
    sudo apt-get update
    sudo apt-get install shc
    ```

  - For MacOS:

    ```bash
    brew install shc
    ```

- After that, you are good to go.

#### How to use

```bash
sh create-sh-binary.sh -f create-sh-binary.sh
OR
sh create-sh-binary.sh -f create-sh-binary.sh -o my-binary
#Yes, can convert itself. :D
```

And then move your `my-binary` file to the `usr/local/bin/` folder to run in your terminal. Just type

```bash
my-binary example-1 example-2
```

### Remote Tunneling

The Script helps to tunneling using SocketXp for remote development or connecting to IoT devices.

### Before run anything

- You need to create an account on [SocketXp](https://www.socketxp.com).
- Also, you need to follow to the steps to create an **Authentication Token** and connect to remote devices.
  - You can follow it [here](https://www.socketxp.com/iot/how-to-remote-access-iot-ssh-over-the-internet/).

- After that, you are good to go.

#### How to use

```bash
# You could pass your sudo password with the "echo"
echo 'sudoPassword' | sh remote-tunneling.sh -a your-auth-token -d device-id-to-connect -o local-port-to-opened -p host-port -u username for ssh

# If you already permitted to your terminal just run

sh remote-tunneling.sh -a your-auth-token -d device-id-to-connect -o local-port-to-opened -p host-port -u username-for-ssh
```

- Alternatively, you could create a binary file using [Create SH Binary](README.md#create-sh-binary) to use it.

```bash
remote-tunneling -a your-auth-token -d device-id-to-connect -o local-port-to-opened -p host-port -u username-for-ssh
```
