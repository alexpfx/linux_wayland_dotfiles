#!/usr/bin/fish

# Token
sudo mkdir -p /etc/pkcs11/modules/
echo "module:/usr/lib/pkcs11/libeToken.so" | sudo tee /etc/pkcs11/modules/eToken.module

sudo systemctl enable pcscd
sudo systemctl start pcscd

git config --global http.sslVerify false
set -Ux SIBE_DOCKER_DIR /data/sibe/git/sibe-docker
set -Ux SIBE_DIR /data/sibe/git/sibe-pu-repo
set -x files_repo /data/sibe/git/files_repo
set -Ux JAVA_HOME /data/jdk1.8.0_391
set -Ux M2_HOME /data/apache-maven-3.6.3
fish_add_path $JAVA_HOME/bin
fish_add_path $M2_HOME/bin


git config --global push.autoSetupRemote true

fisher install jethrokuan/fzf
fisher install jethrokuan/z
fisher install franciscolourenco/done
fisher install jorgebucaran/autopair.fish
