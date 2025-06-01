sudo apt install ssh
sudo apt-get install build-essential
sudo apt-get install build-essential fakeroot dpkg-dev
sudo nano /etc/apt/sources.list.d/ubuntu.sources
sudo apt update

mkdir -p ~/dev
cd ~/dev
sudo apt-get source iptables-persistent
sudo apt-get build-dep iptables-persistent

cd ..
tar cfvz dev.tgz dev
cd ~/dev

dpkg-source -x iptables-persistent_1.0.23.dsc
cd iptables-persistent-1.0.23/

cd ..
sudo rm -r dev
tar xfz dev.tgz

gpg --list-keys
gpg --generate-key

grep -rnw 'dev' -e 'gustavo'
cd ~/dev/iptables-persistent-1.0.23/

dpkg-buildpackage -rfakeroot -b

gpg --list-keys
gpg --delete-secret-keys me@me.com 
gpg --delete-keys me@me.com 
gpg --list-keys

gpg --generate-key
dpkg-buildpackage -rfakeroot -b

sudo apt install ./iptables-persistent_1.0.23_all.deb 
sudo apt install ./ipset-persistent_1.0.23_all.deb 

sudo systemctl enable netfilter-persistent.service

cd /etc/iptables/
sudo iptables-restore rules.v4

sudo shutdown -h now
