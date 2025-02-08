#!/bin/bash

echo "Updating system packages..."
sudo apt update && sudo apt install -y \
    git wget curl make cmake gcc g++ python3 python3-pip \
    libx11-dev libxaw7-dev libreadline-dev libncurses-dev \
    tcl-dev tk-dev flex bison gawk csh tcsh x11-apps xterm \
    m4 automake autoconf libtool

echo "Cloning and installing SkyWater PDK..."
cd /workspaces
git clone --recursive https://github.com/google/skywater-pdk.git
cd skywater-pdk
make timing

echo "Installing Open_PDKs..."
cd /workspaces
git clone https://github.com/RTimothyEdwards/open_pdks.git
cd open_pdks
./configure --enable-sky130-pdk --with-sky130-source=/workspaces/skywater-pdk
make -j$(nproc)
sudo make install

echo "Installing Magic VLSI..."
cd /workspaces
git clone https://github.com/RTimothyEdwards/magic.git
cd magic
./configure
make -j$(nproc)
sudo make install

echo "Installing Xschem..."
cd /workspaces
git clone https://github.com/StefanSchippers/xschem.git
cd xschem
./configure
make -j$(nproc)
sudo make install

echo "Installing NGSpice..."
cd /workspaces
git clone https://git.code.sf.net/p/ngspice/ngspice
cd ngspice
mkdir release
cd release
../configure --enable-xspice
make -j$(nproc)
sudo make install

echo "Installing PSI (Physical Standard Interface)..."
cd /workspaces
git clone https://github.com/google/psi.git
cd psi
make -j$(nproc)
sudo make install

echo "Setting up environment variables..."
echo "export PDK_ROOT=/usr/local/share/pdk" >> ~/.bashrc
echo "export SKY130A=\$PDK_ROOT/sky130A" >> ~/.bashrc
echo "export PATH=\$PATH:/usr/local/bin" >> ~/.bashrc
echo "export LD_LIBRARY_PATH=/usr/local/lib:\$LD_LIBRARY_PATH" >> ~/.bashrc
echo "export PYTHONPATH=\$PYTHONPATH:/usr/local/lib/python3.x/site-packages" >> ~/.bashrc
source ~/.bashrc

echo "Installation Complete!"
