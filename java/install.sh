#!/bin/bash -e

echo "================= Installing default-jdk & jre ==================="
apt-get install default-jre=2:1.8-56ubuntu2
apt-get install default-jdk=2:1.8-56ubuntu2

echo "================= Installing openjdk-8-jdk ==================="
add-apt-repository -y ppa:openjdk-r/ppa
apt-get update
apt-get install -y openjdk-8-jdk=8u131-b11-2ubuntu1.16.04.3
update-alternatives --set java /usr/lib/jvm/java-8-openjdk-amd64/jre/bin/java
update-alternatives --set javac /usr/lib/jvm/java-8-openjdk-amd64/bin/javac
add-apt-repository ppa:maarten-fonville/ppa
apt-get update
apt-get install icedtea-8-plugin=1.6.2-3ubuntu1
update-alternatives --set javaws /usr/lib/jvm/java-8-openjdk-amd64/jre/bin/javaws

echo "================ Installing oracle-java8-installer ================="
echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | debconf-set-selections
add-apt-repository -y ppa:webupd8team/java
apt-get update
apt-get install -y oracle-java8-installer=8u144-1~webupd8~0
update-alternatives --set java /usr/lib/jvm/java-8-oracle/jre/bin/java
update-alternatives --set javac /usr/lib/jvm/java-8-oracle/bin/javac
update-alternatives --set javaws /usr/lib/jvm/java-8-oracle/jre/bin/javaws
echo 'export JAVA_HOME=/usr/lib/jvm/java-8-oracle' >> $HOME/.bashrc
echo 'export PATH=$PATH:/usr/lib/jvm/java-8-oracle/jre/bin' >> $HOME/.bashrc
