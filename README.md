<img src="https://github.com/glennbrown/mac-dev-playbook/blob/c4797983ad87de6d41dcd2186af4647041a93158/files/Mac-Dev-Playbook-Logo.png" width="250" height="156" alt="Mac Dev Playbook Logo" />

# Mac Development Ansible Playbook

This playbook installs and configures most of the software I use on my Mac for systems administration. Some things in macOS are slightly difficult to automate, so I still have a few manual installation steps, but at least it's all documented here.

## Installation

1. Ensure Apple's command line tools are installed `xcode-select -install`
2. Clone or download this repository to your local drive.
3. [Install Ansible](https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html#installing-and-upgrading-ansible-with-pip):

    1. Run the following command to add system Python3 to your $PATH: `export PATH="$HOME/Library/Python/3.9/bin:/opt/homebrew/bin:$PATH"`
    2. Upgrade pip: `sudo pip3 install --upgrade pip`
    3. Install Ansible: `pip3 install --user ansible`

4. Run `ansible-galaxy install -r requirements.yml` inside this directory to install required Ansible roles.
5. Run `ansible-playbook main.yml --ask-become-pass` to configure the system, entering you MacOS account password when prompted for the 'BECOME' password.

> [!NOTE]
> If some Homebrew commands fail, you might need to agree to Xcode's license or fix some other Brew issue. Run `brew doctor` to see if this is the case.

> [!TIP]
> You can also install ansible other ways documented [here](https://docs.ansible.com/ansible/latest/installation_guide/index.html)
>
>I also have a requirements.txt file that can be used that includes ansible-lint and some other nice adds. `pip3 install --user -r requirements.txt` can be used to install it.

> [!WARNING]
> MacOS as of Sonoma ships with Python 3.9.6, Ansible 9.x and higher has a minimum requirement of Python 3.10 or higher. I plan to test in a VM with the Python.org offical 3.11 package but if you stick to included Python you are limited to Ansible 8.x

### Use with a remote Mac

You can use this playbook to manage other Macs as well; the playbook doesn't even need to be run from a Mac at all! If you want to manage a remote Mac, either another Mac on your network, or a hosted Mac like the ones from [MacStadium](https://www.macstadium.com), you just need to make sure you can connect to it with SSH:

  1. (On the Mac you want to connect to:) Go to System Preferences > Sharing.
  2. Enable 'Remote Login'.

> [!TIP]
> You can also enable remote login on the command line:
>
>     sudo systemsetup -setremotelogin on

Then edit the `hosts.ini` file in this repository and add to the '[all]' group:

```

[all]
glenns-laptop ansible_host=localhost ansible_connection=local
remote-machine ansible_host=[ip address of machine] 

[all:vars]
ansible_user=[mac user name]
ansible_python_interpreter=/usr/bin/python3

```

If you need to supply an SSH password (if you don't use SSH keys), make sure to pass the `--ask-pass` parameter to the `ansible-playbook` command.

### Running a specific set of tagged tasks

You can filter which part of the provisioning process to run by specifying a set of tags using `ansible-playbook`'s `--tags` flag. The tags available are `dotfiles`, `homebrew`, `mas`, `extra-packages` and `osx`.

    ansible-playbook main.yml -K --tags "dotfiles,homebrew"

ou can override any of the defaults configured in `default.config.yml` by creating a `config.yml` file and setting the overrides in that file. For example, you can customize the installed packages and apps with something like:

```yaml

homebrew_installed_packages:
  - cowsay
  - git
  - go

mas_installed_apps:
  - { id: 443987910, name: "1Password" }
  - { id: 498486288, name: "Quick Resizer" }
  - { id: 557168941, name: "Tweetbot" }
  - { id: 497799835, name: "Xcode" }

pipx_packages:
  - name: mkdocs

configure_dock: true
dockitems_remove:
  - Launchpad
  - TV
dockitems_persist:
  - name: "Sublime Text"
    path: "/Applications/Sublime Text.app/"
    pos: 5

```

Any variable can be overridden in `config.yml`; see the supporting roles' documentation for a complete list of available variables.

## Included Applications / Configuration (Default)

Applications (installed with Homebrew Cask):

- [1Password](https://1password.com)
- [balenaEtcher](https://etcher.balena.io)
- [coconutBattery](https://coconut-flavour.com/coconutbattery/)
- [Discord](https://discord.com/)
- [Docker](https://www.docker.com/)
- [Google Chrome](https://www.google.com/chrome/)
- [Handbrake](https://handbrake.fr/)
- [iTerm2](https://iterm2.com/)
- [Jellyfin Media Player](https://jellyfin.org)
- [Logi Options Plus](https://www.logitech.com/en-us/software/logi-options-plus.html)
- [MediaHuman Audio Converter](https://www.mediahuman.com/audio-converter/welcome.html)
- [MediaInfo](https://mediaarea.net/en/MediaInfo)
- [Meld](https://meldmerge.org)
- [MusicBrainz Picard](https://picard.musicbrainz.org)
- [NetSpot](https://www.netspotapp.com)
- [Obsidian](https://obsidian.md)
- [Parsec](https://parsec.app)
- [Plex](https://www.plex.tv)
- [Raspberry Pi Imager](https://www.raspberrypi.com/software/)
- [Spotify](https://www.spotify.com)
- [TimeMachineEditor](https://tclementdev.com/timemachineeditor/)
- [UTM](https://mac.getutm.app)
- [Visual Studio Code](https://code.visualstudio.com)
- [VLC](https://www.videolan.org)
- [Vmware Horizon Client](https://customerconnect.vmware.com/en/downloads/info/slug/desktop_end_user_computing/vmware_horizon_clients/horizon_8)
- [XQuartz](https://www.xquartz.org)
- [Zoom](https://zoom.us)

Fonts (intalled with Homebrew Cask)

- [Nerd Fonts](https://www.nerdfonts.com)
  - Hack
  - MesloLG

Packages (installed with Homebrew)

- bash
- bash-completion@2
- btop
- brew-cask-completion
- coreutils
- ffmpeg
- flac
- gawk
- gnu-tar
- go
- htop
- iperf3
- jq
- just
- lame
- lesspipe
- lz4
- lzo
- nano
- nanorc
- ncurses
- neofetch
- nmap
- perl
- pv
- qemu
- ruby
- screenresolution
- smartmontools
- snappy
- socat
- sshpass
- svt-av1
- tmux
- webp
- wget
- when
- x264
- x265
- xvid
- xz

My [dotfiles](https://github.com/glennbrown/dotfiles) are also installed into the current user's home directory, including the `.macos_defaults` dotfile for configuring things that cannot be automated with [community.general.osx_defaults](https://docs.ansible.com/ansible/latest/collections/community/general/osx_defaults_module.html). You can disable dotfiles management by setting `configure_dotfiles: no` in your configuration.

## Ansible for DevOps

Check out [Ansible for DevOps](https://www.ansiblefordevops.com/), which teaches you how to automate almost anything with Ansible. This book was made by Jeff Geerling and has been indepensible in my ability to learn Ansible.

## Author

This project was inspired by [Jeff Geerling's](https://github.com/geerlingguy/mac-dev-playbook) which was originally inspired by [MWGriffin/ansible-playbooks](https://github.com/MWGriffin/ansible-playbooks)).
