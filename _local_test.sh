#!/usr/bin/env sh

set -e

VERSIONS=$(yq '.jobs.molecule.strategy.matrix.distro | map(.image + ":" + .version)' .github/workflows/ci.yml -o shell | awk -F= '{print $2}' | tr -d "'")
while IFS= read -r VER; do
  export MOLECULE_DISTRO=$(echo "$VER" | awk -F: '{print $1}')
  export MOLECULE_DISTRO_VER=$(echo "$VER" | awk -F: '{print $2}')
  molecule test
done <<< "$VERSIONS"
