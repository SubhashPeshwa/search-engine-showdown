#!/usr/bin/env bash

apt install wget
apt install ant
ln -snf /usr/share/ant/bin/ant /bin/ant

apt install default-jdk

echo "export JAVA_HOME=/usr/lib/jvm/default-java" >>~/.bashrc
echo "export PATH=$JAVA_HOME/bin:$PATH" >>~/.bashrc
source ~/.bashrc