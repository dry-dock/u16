#!/bin/bash -e

export DEBIAN_FRONTEND=noninteractive

echo "================ Installing locales ======================="
apt-get clean && apt-get update
apt-get install locales=2.23-0ubuntu9

dpkg-divert --local --rename --add /sbin/initctl
locale-gen en_US en_US.UTF-8
dpkg-reconfigure locales

echo "HOME=$HOME"
cd /u16

echo "================= Updating package lists ==================="
apt-get update

echo "================= Adding some global settings ==================="
mv gbl_env.sh /etc/profile.d/
mkdir -p "$HOME/.ssh/"
mv config "$HOME/.ssh/"
mv 90forceyes /etc/apt/apt.conf.d/
touch "$HOME/.ssh/known_hosts"

echo "================= Installing basic packages ==================="
apt-get install -y \
  build-essential=12.1ubuntu2 \
  curl=7.47.0-1ubuntu2.2 \
  gcc=4:5.3.1-1ubuntu1 \
  gettext=0.19.7-2ubuntu3 \
  htop=2.0.1-1ubuntu1 \
  libxml2-dev=2.9.3+dfsg1-1ubuntu0.2 \
  libxslt1-dev=1.1.28-2.1ubuntu0.1 \
  make=4.1-6 \
  nano=2.5.3-2ubuntu2 \
  openssh-client=1:7.2p2-4ubuntu2.1 \
  openssl=1.0.2g-1ubuntu4.6 \
  software-properties-common=0.96.20.7 \
  sudo=1.8.16-0ubuntu1.4  \
  texinfo=6.1.0.dfsg.1-5 \
  unzip=6.0-20ubuntu1 \
  wget=1.17.1-1ubuntu1.1 \
  rsync=3.1.1-3ubuntu1 \
  psmisc=22.21-2.1build1

echo "================= Installing Python packages ==================="
apt-get install -y \
  python-pip=8.1.1-2ubuntu0.4 \
  python-software-properties=0.96.20.7 \
  python-dev=2.7.11-1

pip install virtualenv

echo "================= Installing Git ==================="
add-apt-repository ppa:git-core/ppa -y
apt-get update
apt-get install -y git=1:2.13.0-0ppa1~ubuntu16.04.1

echo "================= Installing Git LFS ==================="
curl -sS https://packagecloud.io/install/repositories/github/git-lfs/script.deb.sh | sudo bash
sudo apt-get install git-lfs=2.0.1
git lfs install

echo "================= Adding JQ 1.5.1 ==================="
apt-get install jq=1.5+dfsg-1

echo "================= Installing Node 7.x ==================="
. /u16/node/install.sh

echo "================= Installing Java 1.8.0 ==================="
. /u16/java/install.sh

echo "================= Installing Ruby 2.3.3  ==================="
. /u16/ruby/install.sh

echo "================= Adding gcloud ============"
CLOUD_SDK_REPO="cloud-sdk-$(lsb_release -c -s)"
echo "deb http://packages.cloud.google.com/apt $CLOUD_SDK_REPO main" | tee /etc/apt/sources.list.d/google-cloud-sdk.list
curl -sS https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -
sudo apt-get update && sudo apt-get install google-cloud-sdk=160.0.0-0

echo "================= Adding kubectl 1.5.1 ==================="
curl -sSLO https://storage.googleapis.com/kubernetes-release/release/v1.5.1/bin/linux/amd64/kubectl
chmod +x ./kubectl
sudo mv ./kubectl /usr/local/bin/kubectl

echo "================= Adding awscli 1.11.44 ============"
sudo pip install 'awscli==1.11.44'

echo "================= Adding awsebcli 3.9.0 ============"
sudo pip install 'awsebcli==3.9.0'

echo "================ Adding azure-cli 2.0 =============="
echo "deb [arch=amd64] https://packages.microsoft.com/repos/azure-cli/ wheezy main" | \
  sudo tee /etc/apt/sources.list.d/azure-cli.list
sudo apt-key adv --keyserver packages.microsoft.com --recv-keys 417A0893
sudo apt-get install apt-transport-https=1.2.20
sudo apt-get update && sudo apt-get install azure-cli=0.2.8-1

echo "================= Adding doctl 1.6.0 ============"
curl -OL https://github.com/digitalocean/doctl/releases/download/v1.6.0/doctl-1.6.0-linux-amd64.tar.gz
tar xf doctl-1.6.0-linux-amd64.tar.gz
sudo mv ~/doctl /usr/local/bin
rm doctl-1.6.0-linux-amd64.tar.gz

echo "================= Adding jfrog-cli 1.7.0 ==================="
wget -nv https://api.bintray.com/content/jfrog/jfrog-cli-go/1.7.0/jfrog-cli-linux-amd64/jfrog?bt_package=jfrog-cli-linux-amd64 -O jfrog
sudo chmod +x jfrog
mv jfrog /usr/bin/jfrog

echo "================ Adding ansible 2.3.0.0 ===================="
sudo pip install 'ansible==2.3.0.0'

echo "================ Adding boto 2.46.1 ======================="
sudo pip install 'boto==2.46.1'

echo "================ Adding apache-libcloud 2.0.0 ======================="
sudo pip install 'apache-libcloud==2.0.0'

echo "================ Adding azure 2.0.0rc5 ======================="
sudo pip install 'azure==2.0.0rc5'

echo "================ Adding dopy 0.3.7a ======================="
sudo pip install 'dopy==0.3.7a'

echo "================ Adding terraform-0.8.7===================="
export TF_VERSION=0.8.7
export TF_FILE=terraform_"$TF_VERSION"_linux_amd64.zip

echo "Fetching terraform"
echo "-----------------------------------"
rm -rf /tmp/terraform
mkdir -p /tmp/terraform
wget -nv https://releases.hashicorp.com/terraform/$TF_VERSION/$TF_FILE
unzip -o $TF_FILE -d /tmp/terraform
sudo chmod +x /tmp/terraform/terraform
mv /tmp/terraform/terraform /usr/bin/terraform

echo "Added terraform successfully"
echo "-----------------------------------"

echo "================ Adding packer 0.12.2 ===================="
export PK_VERSION=0.12.2
export PK_FILE=packer_"$PK_VERSION"_linux_amd64.zip

echo "Fetching packer"
echo "-----------------------------------"
rm -rf /tmp/packer
mkdir -p /tmp/packer
wget -nv https://releases.hashicorp.com/packer/$PK_VERSION/$PK_FILE
unzip -o $PK_FILE -d /tmp/packer
sudo chmod +x /tmp/packer/packer
mv /tmp/packer/packer /usr/bin/packer

echo "Added packer successfully"
echo "-----------------------------------"

echo "================= Intalling Shippable CLIs ================="
echo "Installing shippable_decrypt"
cp /u16/shippable_decrypt /usr/local/bin/shippable_decrypt

echo "Installing shippable_retry"
cp /u16/shippable_retry /usr/local/bin/shippable_retry

echo "Installing shippable_replace"
cp /u16/shippable_replace /usr/local/bin/shippable_replace

echo "Installed Shippable CLIs successfully"
echo "-------------------------------------"

echo "================= Cleaning package lists ==================="
apt-get clean
apt-get autoclean
apt-get autoremove
