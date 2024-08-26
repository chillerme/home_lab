# AIDE

[![ansible-lint.yml](https://github.com/linux-system-roles/template/actions/workflows/ansible-lint.yml/badge.svg)](https://github.com/linux-system-roles/template/actions/workflows/ansible-lint.yml) [![ansible-test.yml](https://github.com/linux-system-roles/template/actions/workflows/ansible-test.yml/badge.svg)](https://github.com/linux-system-roles/template/actions/workflows/ansible-test.yml) [![markdownlint.yml](https://github.com/linux-system-roles/template/actions/workflows/markdownlint.yml/badge.svg)](https://github.com/linux-system-roles/template/actions/workflows/markdownlint.yml) [![shellcheck.yml](https://github.com/linux-system-roles/template/actions/workflows/shellcheck.yml/badge.svg)](https://github.com/linux-system-roles/template/actions/workflows/shellcheck.yml) [![woke.yml](https://github.com/linux-system-roles/template/actions/workflows/woke.yml/badge.svg)](https://github.com/linux-system-roles/template/actions/workflows/woke.yml)

![aide](https://github.com/linux-system-roles/template/workflows/tox/badge.svg)

This is an ansible role that installs and configures the [Advanced Intrusion Detection Environment (AIDE)](https://aide.github.io). For Day 2 tasks it can run integrity checks and update the AIDE database.

_Notice:_ This is a very early stage of a work in progress. Please use with
extreme caution as it might break your system.

## What does this role do for you?

* It ensures that the `aide` package is installed on the remote nodes
* As an optional task it can generate the `/etc/aide.conf` file and template it out to the remote nodes
* It initializes the AIDE database
* The AIDE databases from the remote nodes are stored in a central directory on the controller node
* It runs AIDE integrity checks on the remote nodes
* It updates the AIDE databases and stores them on the controller node

## How does the role do that?

* The role is controlled by using [Ansible Tags](https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_tags.html)
* If you run the playbook without specifying any tag the role will change nothing on your remote nodes
* To execute some supported use cases you need to explicitly specify one or more of the following tags

### Available tags to control and use the role

* __install__ - With this tag the role ensures that the `aide` package is installed on the remote nodes
* __generate_config__ - Generates the file `/etc/aide.conf` using `templates/aide.conf.j2`; the template needs to be adjusted to fit your requirements; if you do not use this tag the default configuration file shipped with the `aide` package will be used
* __init__ - Initializes the AIDE database and fetches it from the remote nodes to store it on the controller node
* __check__ - Runs an integrity check on the remote nodes
* __update__ - Updates the AIDE database and stores it on the controller node

## What does this role not do for you?

* It does not explain how to create a good AIDE configuration that suits your requirements; that task remains for you to accomplish

## Requirements

This role has no special requirements as it uses `ansible.builtin` modules
only.

## Role Variables

### aide_db_fetch_dir

This variable takes a string to specify the directory on the Ansible Control
Node (ACN) where the role will store the AIDE database fetched from the remote
nodes. The default value is `files` which is expected to be a directory in the
same directory as the playbook.

In case you like to store the fetched AIDE database files somewhere else you
need to specify a different path here.

Example of setting the variables:

```yaml
aide_db_fetch_dir: files
```

## Example Playbook

Including an example of how to use your role (for instance, with variables
passed in as parameters) is always nice for users too:

```yaml
# SPDX-License-Identifier: MIT
---
- name: Example aide role invocation
  hosts: targets
  tasks:
    - name: Include role aide
      tags:
        - install
        - generate_config
        - init
        - check
        - update
      vars:
        aide_db_fetch_dir: files
      ansible.builtin.include_role:
        name: aide
```

More examples can be found in the [`examples/`](examples) directory.

## License

MIT.

## Author Information

* Joerg Kastning
