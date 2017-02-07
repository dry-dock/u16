#!/bin/bash -e 
export TF_INSTALL_LOCATION=/opt
export TF_VERSION=0.8.5
export PK_INSTALL_LOCATION=/opt
export PK_VERSION=0.12.2
export PK_FILENAME=packer_"$PK_VERSION"_linux_amd64.zip
locale-gen en_US en_US.UTF-8 && dpkg-reconfigure locales

cd /u16

echo "================= Adding some global settings ==================="
mv gbl_env.sh /etc/profile.d/
mkdir -p $HOME/.ssh/
mv config $HOME/.ssh/
mv 90forceyes /etc/apt/apt.conf.d/

echo "================= Updating package lists ==================="
apt-get update

echo "================= Installing basic packages ==================="
apt-get install -y \
  sudo\
  vim\
  build-essential \
  curl \
  gcc \
  make \
  netcat \
  openssl \
  software-properties-common \
  wget \
  nano \
  unzip \
  libxslt-dev \
  libxml2-dev

echo "================= Installing Python packages ==================="
apt-get install -y \
  python-pip \
  python-software-properties \
  python-dev

pip install virtualenv

echo "================= Adding Terraform 0.8.5 ==================="
pushd $TF_INSTALL_LOCATION
echo "Fetching terraform"
echo "-----------------------------------"

rm -rf $TF_INSTALL_LOCATION/terraform
mkdir -p $TF_INSTALL_LOCATION/terraform

wget -q https://releases.hashicorp.com/terraform/$TF_VERSION/terraform_"$TF_VERSION"_linux_amd64.zip
apt-get install unzip
unzip -o terraform_"$TF_VERSION"_linux_amd64.zip -d $TF_INSTALL_LOCATION/terraform
echo "export PATH=$PATH:$TF_INSTALL_LOCATION/terraform" >> ~/.bashrc
echo "Installed terraform successfully"
echo "-----------------------------------"
popd  

echo "================= Adding Packer 0.12.2 ==================="
pushd $PK_INSTALL_LOCATION
echo "Fetching packer"
echo "-----------------------------------"

rm -rf $PK_INSTALL_LOCATION/packer
mkdir -p $PK_INSTALL_LOCATION/packer

wget -q https://releases.hashicorp.com/packer/$PK_VERSION/"$PK_FILENAME"
unzip -o $PK_FILENAME -d $PK_INSTALL_LOCATION/packer
echo "export PATH=$PATH:$PK_INSTALL_LOCATION/packer" >> ~/.bashrc
echo "Installed packer successfully"
echo "-----------------------------------"
popd

echo "================= Adding JQ 1.5.1 ==================="
apt-get install jq


echo "================= Installing Git ==================="
add-apt-repository ppa:git-core/ppa -y
apt-get update
apt-get install -y git

echo "================= Installing Node 7.x ==================="
. /u16/node/install.sh

echo "================= Installing Java 1.8.0 ==================="
. /u16/java/install.sh

echo "================= Installing Ruby 2.3.3  ==================="
. /u16/ruby/install.sh

echo "================= Adding gcloud ============"
CLOUD_SDK_REPO="cloud-sdk-$(lsb_release -c -s)"
echo "deb http://packages.cloud.google.com/apt $CLOUD_SDK_REPO main" | tee /etc/apt/sources.list.d/google-cloud-sdk.list
curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -
sudo apt-get update && sudo apt-get install google-cloud-sdk

echo "================= Adding awscli 1.11.44 ============"
sudo pip install 'awscli==1.11.44'

echo "================= Adding awsebcli 3.9.0 ============"
sudo pip install 'awsebcli==3.9.0'

echo "================= Adding jfrog-cli 1.7.0 ==================="
wget -v https://api.bintray.com/content/jfrog/jfrog-cli-go/1.7.0/jfrog-cli-linux-amd64/jfrog?bt_package=jfrog-cli-linux-amd64 -O jfrog
sudo chmod +x jfrog
mv jfrog /usr/bin/jfrog
echo "================= Cleaning package lists ==================="
apt-get clean
apt-get autoclean
apt-get autoremove
