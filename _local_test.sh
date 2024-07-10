#!/usr/bin/env sh

set -e

VERSIONS=(
  "ubuntu:22.04"
  "debian:12.6"
  "rockylinux:9.3"
  "fedora:39"
)

for VER in "${VERSIONS[@]}"; do
  MOLECULE_DISTRO=$(echo "$VER" | awk -F: '{print $1}') \
  MOLECULE_DISTRO_VER=$(echo "$VER" | awk -F: '{print $2}') \
  molecule test
done


