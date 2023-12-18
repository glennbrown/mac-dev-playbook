#!/usr/bin/env -S just --justfile
# ^ A shebang isn't required, but allows a justfile to be executed
#   like a script, with `./justfile test`, for example.

bt := '0'

export RUST_BACKTRACE := bt

log := "warn"

export JUST_LOG := log

# Roles and Collections
# optionally use --force to reinstall all requirements
reqs *FORCE:
    ansible-galaxy install -r requirements.yml {{FORCE}}

# just setup TAGS
# Uses 1PW lookup for become pass
setup *TAGS:
    ansible-playbook main.yml {{TAGS}}

# just askpass TAGS
# Asks for become password
askpass *TAGS:
    ansible-playbook main.yml --ask-become-pass {{TAGS}}
