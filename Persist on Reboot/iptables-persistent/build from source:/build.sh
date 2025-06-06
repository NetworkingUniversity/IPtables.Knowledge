# This build requires manual input, at certain steps!

#https://launchpad.net/ubuntu/+source/iptables-persistent
#https://www.cmiss.org/cmgui/wiki/BuildingUbuntuPackagesFromSource

apt_sources(){
  sudo sed -i 's/^Types: deb$/Types: deb deb-src/' /etc/apt/sources.list.d/ubuntu.sources
  sudo apt update
}

pre(){
  # Setup build dir
  mkdir -p ~/dev
  cd ~/dev

  # Depends
  sudo apt-get install build-essential #fakeroot dpkg-dev

  # Source:
  sudo apt-get source iptables-persistent
  sudo apt-get build-dep iptables-persistent
}

generate_signing_key(){
  # The Maintainer has a step that requires his GPG key.
  # You have to generate a key using his exact Name & Email! Else the build will fail
  # solves: "dpkg-buildpackage: error: failed to sign ../iptables-persistent_1.0.23_amd64.buildinfo file: OpenPGP backend command cannot sign"
  gpg --generate-key
  
  # Enter:
  echo "gustavo panizzo"
  echo "gfa@zumbi.com.ar"
  
  # ToDo: automate https://www.google.com/search?q=gpg+--generate-key+in+script+user+name+email
}

build(){  
  cd ~/dev/iptables-persistent-*/
  
  # Now build:
  dpkg-buildpackage -rfakeroot -b

  # It's going to ask you to unlock your GPG key to sign package! use password set when generated.
}

install(){
  # Has an interactive install that asks questions
  sudo apt install ./ipset-persistent_1.0.23_all.deb
  sudo apt install ./iptables-persistent_*_all.deb
  sudo apt install ./netfilter-persistent_1.0.23_all.deb
}

main(){
  apt_sources
  pre
  generate_signing_key
  build
  install
}
