#!/usr/bin/bash
set -e

# enable podman
shopt -s expand_aliases
source ~/.bashrc

docker build . -t qbittorrentvpn:latest

cd test

rm -rf tmp
mkdir -p tmp

export TEST_CONFIG=$(readlink -f $(mktemp -d --tmpdir=tmp))
export TEST_DOWNLOADS=$(readlink -f $(mktemp -d --tmpdir=tmp))

mkdir $TEST_CONFIG/openvpn
cp *.ovpn $TEST_CONFIG/openvpn/

docker compose -f compose.yaml up
