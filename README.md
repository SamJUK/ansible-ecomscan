# Ansible Role - Ecomscan

![https://github.com/samjuk/ansible-ecomscan/workflows/CI/badge.svg](https://github.com/samjuk/ansible-ecomscan/workflows/CI/badge.svg)

An Ansible Role that installs and runs Ecomscan on Linux


## Requirements
None.

## Role Variables

Available variables are listed below, along with default values (see defaults/main.yml):

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
