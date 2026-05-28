# Ansible Role - Ecomscan

![https://github.com/samjuk/ansible-ecomscan/workflows/CI/badge.svg](https://github.com/samjuk/ansible-ecomscan/workflows/CI/badge.svg)

An Ansible Role that installs and runs Ecomscan on Linux


## Requirements
None.

## Local Linting And Molecule Tests

The CI pipeline uses Poetry, `ansible-lint`, and Molecule with Docker. The same commands can be run locally.

### Prerequisites

- Python 3
- Poetry
- Docker (running)
- `yq` (only required for `./_local_test.sh`)

### Install dependencies

```bash
poetry install --no-interaction
```

### Run linting

```bash
poetry run ansible-lint defaults tasks meta molecule
```

### Run Molecule tests (single distro)

By default the Molecule scenario uses `ubuntu:latest`. To mirror CI more closely, set distro values explicitly:

```bash
MOLECULE_DISTRO=ubuntu MOLECULE_DISTRO_VER=22.04 poetry run molecule test
```

You can swap these values for other CI targets, for example:

```bash
MOLECULE_DISTRO=debian MOLECULE_DISTRO_VER=12.6 poetry run molecule test
MOLECULE_DISTRO=rockylinux MOLECULE_DISTRO_VER=9.3 poetry run molecule test
MOLECULE_DISTRO=fedora MOLECULE_DISTRO_VER=39 poetry run molecule test
```

### Run full local matrix

To run all distro combinations defined in CI:

```bash
./_local_test.sh
```

## Role Variables

Available variables are listed below, along with default values (see defaults/main.yml):

```yaml
ecomscan_run: true
```
Boolean to set if ecomscan should execute during the playbook execution. 

```yaml
ecomscan_cron: false
```
Boolean to set if ecomscan should be run by cron (@Note: This requires a paid license and a CRON schedule to be installed on your system)

```yaml
ecomscan_cron_expr: "0 */4 * * *"
```
Cron expresion to define how frequently to run the schedule scans

```yaml
ecomscan_binary_download: true
```
Boolean to set if we should try and download the latest copy of Ecomscan

```yaml
ecomscan_binary_source: 'https://ecomscan.com/downloads/linux-amd64/ecomscan'
```
The source url of the ecomscan binary, can be changed if use a different mirror.

```yaml
ecomscan_binary_path: ~/bin/ecomscan
```
File location of where to store the downloaded binary

```yaml
ecomscan_key: trial
```
Ecomscan license key to use for the scan

```yaml
ecomscan_report_email: root@localhost.local
```
Comma seperated list of email addresses to send the Ecomscan email report to

```yaml
ecomscan_slack_webhook: ""
```
Optional Slack webhook URL. If set, the role adds `--slack=<webhook_url>` to the ecomscan command alongside either `--report` or `--monitor`.

```yaml
ecomscan_project_root: /var/www/vhosts/magento2/htdocs/
```
The absolute file path to the Magento installation you want to scan

```yaml
ecomscan_minimum_confidence: 50
```
The minimum confidence value that Ecomscan uses to determine if a file is clean

```yaml
ecomscan_maximum_filesize: 20000000
```
The maximum file size in bytes to scan, anything larger will be skipped.

```yaml
ecomscan_deep: false
```
Boolean toggle to decide if Ecomscan should perform a deep or regular scan


```yaml
ecomscan_assert_no_malware: false
```
Boolean toggle to decide if we should assert that no malware is present. Is this is set to true, the playbook will exit with code `2`.


```yaml
ecomscan_assert_no_vulnerabilities: false
```
Boolean toggle to decide if we should assert that no vulnerabilities is present. Is this is set to true, the playbook will exit with code `2`


## Example Playbook
An example playbook usage
```yaml
# ~/ecomscan/playbooks/scan.yml
- name: Ecomscan
  hosts: all
  roles:
    - { role: ecomscan, tags: ecomscan }
```

```yaml
# ~/ecomscan/hosts/all.yml
magento2:
  hosts:
    client1-prod:
      ansible_host: 0.0.0.0
      ansible_user: ansible
      ecomscan_key: K2T11V4
      ecomscan_report_email: me@me.com,info@client1.info
      ecomscan_project_root: /var/www/vhosts/staging.client1.info/htdocs/current/

    client2-stg:
      ansible_host: 0.0.0.0
      ansible_port: 711
      ansible_user: client2_mage_stg
      ecomscan_key: T3STK3Y
      ecomscan_report_email: me@me.com
      ecomscan_project_root: /var/www/vhosts/staging.client2.com/htdocs/release/

    client2-prod:
      ansible_host: 0.0.0.0
      ansible_port: 711
      ansible_user: client2_mage_prod
      ecomscan_report_email: me@me.com,info@client2.com
      ecomscan_project_root: /var/www/vhosts/prod.client2.com/htdocs/release/
```
