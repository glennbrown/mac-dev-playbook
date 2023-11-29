<img src="https://github.com/glennbrown/mac-dev-playbook/blob/c4797983ad87de6d41dcd2186af4647041a93158/files/Mac-Dev-Playbook-Logo.png" width="250" height="156" alt="Mac Dev Playbook Logo" />

# Mac Development Ansible Playbook

This playbook installs and configures most of the software I use on my Mac for systems administration. Some things in macOS are slightly difficult to automate, so I still have a few manual installation steps, but at least it's all documented here.

## Installation

1. Ensure Apple's command line tools are installed `xcode-select -install`
2. [Install Ansible](https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html#installing-and-upgrading-ansible-with-pipx)
        
    1. Run the following command to add system Python 3 and .local binary to your $PATH: `export PATH="$HOME/.local/bin:$HOME/Library/Python/3.9/bin:/opt/homebrew/bin:$PATH"`
    2. Upgrade pip: `sudo pip3 install --upgrade pip`
    3. Install pipx: `pip3 install pipx`
    4. Install Ansible: `pipx install --include-deps ansible`
    5. Install extra dependencies `pipx install --include-deps ansible argcomplete ansible-lint`

3. Clone or download this repository to your local drive.
4. Run `ansible-galaxy install -r requirements.yml` inside this directory to install requiredAnsible roles.
5. Run `ansible-playbook main.yml --ask-become-pass` to configure the system, entering you MacOS account password when prompted for the 'BECOME' password.

> Note: If some Homebrew commands fail, you might need to agree to Xcode's license or fix some other Brew issue. Run `brew doctor` to see if this is the case. You can also install other ways documented [here](https://docs.ansible.com/ansible/latest/installation_guide/index.html)

### Use with a remote Mac

You can use this playbook to manage other Macs as well; the playbook doesn't even need to be run from a Mac at all! If you want to manage a remote Mac, either another Mac on your network, or a hosted Mac like the ones from [MacStadium](https://www.macstadium.com), you just need to make sure you can connect to it with SSH:

  1. (On the Mac you want to connect to:) Go to System Preferences > Sharing.
  2. Enable 'Remote Login'.

> You can also enable remote login on the command line:
>
>     sudo systemsetup -setremotelogin on

Then edit the `hosts.ini` file in this repository and add to the '[macs]' group:

```
[macs]
glenns-laptop ansible_host=localhost ansible_connection=local
remote-machine ansible_host=[ip address of machine] 

[all:vars]
ansible_user=[mac user name]
ansible_python_interpreter=/usr/bin/python3
```

If you need to supply an SSH password (if you don't use SSH keys), make sure to pass the `--ask-pass` parameter to the `ansible-playbook` command.