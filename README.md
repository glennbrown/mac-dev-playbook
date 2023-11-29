<img src="https://raw.githubusercontent.com/geerlingguy/mac-dev-playbook/master/files/Mac-Dev-Playbook-Logo.png" width="250" height="156" alt="Mac Dev Playbook Logo" />

# Mac Development Ansible Playbook

This playbook installs and configures most of the software I use on my Mac for systems administration. Some things in macOS are slightly difficult to automate, so I still have a few manual installation steps, but at least it's all documented here.

## Installation

    1. Ensure Apple's command line tools are installed

        xcode-select -install

    2. [Install Ansible](https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html#installing-and-upgrading-ansible-with-pipx)

        - [ ]Run the following command to add system Python 3 and .local binary to your $PATH: `export PATH="$HOME/.local/bin:$HOME/Library/Python/3.9/bin:/opt/homebrew/bin:$PATH"`
        - [ ]Upgrade pip: `sudo pip3 install --upgrade pip`
        - [ ]Install pipx: `pip3 install pipx`
        - [ ]Install Ansible: `pipx install --include-deps ansible`
        - [ ]Install extra dependencies `pipx install --include-deps ansible argcomplete ansible-lint`

    3. Clone or download this repository to your local drive.
    4. Install required ansible roles

        ansible-galaxy install -r requirements.yml

    5. Execute this playbook to configure the system, entering you MacOS account password when prompted for the 'BECOME' password.

        ansible-playbook main.yml --ask-become-pass

> Note: If some Homebrew commands fail, you might need to agree to Xcode's license or fix some other Brew issue. Run `brew doctor` to see if this is the case. You can also install other ways documented [here](https://docs.ansible.com/ansible/latest/installation_guide/index.html)