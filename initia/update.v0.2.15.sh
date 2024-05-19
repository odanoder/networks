#!/bin/bash

cd $HOME/initia
git fetch
git checkout v0.2.15
sudo systemctl stop initia.service
sleep 15
make install
sleep 15
sudo systemctl restart initia.service

echo "initiad version"
echo "sudo journalctl -u initia.service -f -n 100"
