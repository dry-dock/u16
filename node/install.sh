#!/bin/bash -e

echo "================= Installing NVM ==================="
curl -sS https://raw.githubusercontent.com/creationix/nvm/v0.33.0/install.sh | bash

# Set NVM_DIR so the installations go to the right place
export NVM_DIR="/root/.nvm"

# add source of nvm to .bashrc - allows user to use nvm as a command
echo "source ~/.nvm/nvm.sh" >> /etc/drydock/.env

echo "================= Installing nodejs 8.11.0 ================="
curl -sSL https://deb.nodesource.com/setup_8.x | sudo -E bash -
sudo apt-get install -y nodejs=8.11.0*

echo "================= Installing latest yarn ==================="
sudo apt-key adv --fetch-keys http://dl.yarnpkg.com/debian/pubkey.gpg
echo "deb http://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list
sudo apt-get update
sudo apt-get install -y yarn=1.5.1-1
