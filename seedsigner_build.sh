#!/bin/sh

# Latest modification: 20211001
# This script is meant to automatically/interactively build SeedSigner
# SD cards while also removing un-needed files/GPG keys.
# Please ensure you are connected to the internet before running this
# script as it will try to update and install dependencies via "apt-get".

# Clear the screen (to make it easier to focus on the build process) and move to the home directory to start.
clear && cd .. && echo "Moved to the home directory and starting the build process..."
sleep 3s

# Enable the camera
echo "Enabling camera..."
sudo echo "" >> /boot/config.txt
sudo echo "start_x=1" >> /boot/config.txt
sudo echo "gpu_mem=128" >> /boot/config.txt
if grep -q 'start_x=1\|gpu_mem=128' /boot/config.txt
	then echo "Camera enabled..."
	else echo "Error: Camera may not be enabled, please run 'sudo raspi-config' after this script is finished to ensure the camera is enabled..."
fi

# Enable SPI
echo "Enabling SPI..."
sudo sed -i "s/#dtparam=spi=on/dtparam=spi=on/g" /boot/config.txt
if grep -q '#dtparam=spi=on' /boot/config.txt
	then echo "Error: SPI may not be enabled, please run 'sudo raspi-config' after this script is finished to ensure SPI is enabled..."
	else echo "SPI enabled..."
fi

# Change the localization
#echo "Changing localization..."
#echo "Please choose your language prefrence, English [e], French [f], German [g], Italian, [i], Portuguese (European) [pe], Portuguese (Brazilian) [pb], Spanish (Castilian) [sc], Spanish (Mexican) [sm], Spanish (Venezuelan) [sv], Arabic (United Arab Emeriates) [uae], Arabic (Iraq) [ai], Arabic (Saudi Arabian) [asa], Chinese (Hong Kong) [chk], Chinese (Mainland China) [cmc]"
echo "Setting localization to english..."
sudo sed -i "s/^en_GB.UTF-8 UTF-8.*/# en_GB.UTF-8 UTF-8/g" /etc/locale.gen
sudo sed -i "s/^# en_US.UTF-8 UTF-8.*/en_US.UTF-8 UTF-8/g" /etc/locale.gen
#sudo sed -i "s/^# en_US ISO-8859-1.*/en_US ISO-8859-1/g" /etc/locale.gen
export LANG=en_US.UTF-8
export LANGUAGE=en_US.UTF-8
export LC_ALL=en_US.UTF-8
sudo locale-gen && echo "Localization changed..."

# This removes unnecessary code and gpg key.
# https://www.reddit.com/r/linux/comments/1bu0t1/microsoft_repo_installed_on_all_raspberry_pis/
echo "Removing Microsoft code and GPG key..."
sudo rm -f -v /etc/apt/sources.list.d/vscode.list
sudo rm -f -v /etc/apt/trusted.gpg.d/microsoft.gpg

# Update and install dependencies.
echo "Updating and installing dependencies..."
u=0
until [ "$u" -ge 5 ]
do sudo apt-get update && break && echo "Updated..."
u=$((u+1))
done

# Download the dependencies, until the variable is equal to or greater than 5.

echo "Installing wiringpi..."
a=0
until [ "$a" -ge 5 ]
do sudo apt-get install -y wiringpi && break
a=$((a+1))
done
echo "Done..."

echo "Installing python3-pip..."
b=0
until [ "$b" -ge 5 ]
do sudo apt-get install -y python3-pip && break
b=$((b+1))
done
echo "Done..."

echo "Installing python3-numpy..."
c=0
until [ "$c" -ge 5 ]
do sudo apt-get install -y python3-numpy && break
c=$((c+1))
done
echo "Done..."

echo "Installing python-pil..."
d=0
until [ "$d" -ge 5 ]
do sudo apt-get install -y python-pil && break
d=$((d+1))
done
echo "Done..."

echo "Installing libopenjp2-7..."
e=0
until [ "$e" -ge 5 ]
do sudo apt-get install -y libopenjp2-7 && break
e=$((e+1))
done
echo "Done..."

echo "Installing ttf-mscorefonts-installer..."
f=0
until [ "$f" -ge 5 ]
do sudo apt-get install -y ttf-mscorefonts-installer && break
f=$((f+1))
done
echo "Done..."

echo "Installing git..."
g=0
until [ "$g" -ge 5 ]
do sudo apt-get install -y git && break
g=$((g+1))
done
echo "Done..."

echo "Installing python3-opencv..."
h=0
until [ "$h" -ge 5 ]
do sudo apt-get install -y python3-opencv && break
h=$((h+1))
done
echo "Done..."

echo "Installing libzbar0..."
i=0
until [ "$i" -ge 5 ]
do sudo apt-get install -y libzbar0 && break
i=$((i+1))
done
echo "Done..."

echo "Installing python3-picamera..."
j=0
until [ "$j" -ge 5 ]
do sudo apt-get install -y python3-picamera && break
j=$((j+1))
done
echo "Done..."

echo "Installing libatlas-base-dev..."
k=0
until [ "$k" -ge 5 ]
do sudo apt-get install -y libatlas-base-dev && break
k=$((k+1))
done
echo "Done..."

echo "Installing qrencode..."
l=0
until [ "$l" -ge 5 ]
do sudo apt-get install -y qrencode && break
l=$((l+1))
done
echo "Done..."

echo "Dependencies installed..."

# Install the C library for Broadcom BCM 2835.
echo "Installing the C library for Broadcom BCM 2835..."

m=0
until [ "$m" -ge 5 ]
do wget http://www.airspayce.com/mikem/bcm2835/bcm2835-1.60.tar.gz && break
m=$((m+1))
done
echo "Library downloaded..."

n=0
until [ "$n" -ge 5 ]
do tar zxvf bcm2835-1.60.tar.gz && break
n=$((n+1))
done

echo "configuring..."
cd bcm2835-1.60/ && sudo ./configure
sudo make && sudo make check && sudo make install && echo "Library installed..."
cd .. && echo "Removing the bcm2835 tar file..."
sudo rm -v bcm2835-1.60.tar.gz

# Set up Virtaul env.
o=0
echo "Setting up a virtual env..."
until [ "$o" -ge 5 ]
do sudo pip3 install virtualenvwrapper && break
o=$((o+1))
done
echo '' >> /home/pi/.profile && echo 'export WORKON_HOME=$HOME/.envs' >> /home/pi/.profile && echo 'export VIRTUALENVWRAPPER_PYTHON=/usr/bin/python3' >> /home/pi/.profile && echo 'source /home/pi/.local/bin/virtualenvwrapper.sh' >> /home/pi/.profile && echo "Virtual env. set up..."

# Create the virtual env.
p=0
echo "Creating the virtual env..."
until [ "$p" -ge 5 ]
do source ~/home/pi/.profile
mkvirtualenv --python=python3 seedsigner-env && break && echo "Created the Virtual env..."
p=$((p+1))
done

# Download SeedSigner.
echo "Downloading SeedSigner..."
git clone https://github.com/SeedSigner/seedsigner && echo "SeedSigner software downloaded..."

# Install SeedSigner python dependencies.
echo "Installing SeedSigner Python dependencies..."
cd seedsigner && echo "Changed to SeedSigner dir..."
sudo pip3 install -r requirements.txt && echo "Dependencies installed..."

# Configure system to run at boot.
echo "Configuring system to run at boot..."
#cd /etc/systemd/system/
#touch seedsigner.service
echo '[Unit]' >> /etc/systemd/system/seedsigner.service
echo 'Description=SeedSigner' >> /etc/systemd/system/seedsigner.service
echo '' >> /etc/systemd/system/seedsigner.service
echo '[Service]' >> /etc/systemd/system/seedsigner.service
echo 'User=pi' >> /etc/systemd/system/seedsigner.service
echo 'WorkingDirectory=/home/pi/seedsigner/src/' >> /etc/systemd/system/seedsigner.service
echo 'ExecStart=/usr/bin/python3 main.py' >> /etc/systemd/system/seedsigner.service
echo 'Restart=always' >> /etc/systemd/system/seedsigner.service
echo '' >> /etc/systemd/system/seedsigner.service
echo '[Install]' >> /etc/systemd/system/seedsigner.service
echo 'WantedBy=multi-user.target' >> /etc/systemd/system/seedsigner.service
cd && echo "System configured to run at boot..."

# Enable the SeedSigner service on boot.
echo "Enabling the SeedSigner service on boot..."
sudo systemctl enable seedsigner.service

# Check to see that the seedsigner service is running.
if systemctl is-active seedsigner.service
then
	echo "SeedSigner service is enabled..."
else
	echo "Service may not be enabled..."
fi

# (Optional) modify system swap config to disable virtual memory.
echo "Disabling virtual memory..."
sudo sed -i "s/CONF_SWAPSIZE=100/CONF_SWAPSIZE=0/g" /etc/dphys-swapfile && echo "Virtual memory disabled..."

# (Optional) Change the User password.
#echo "Change the user password..."
#sleep 2s
#passwd

# Reboot options.
echo "If working on a seperate RPI please enter [1], if on the device you plan to use for your SeedSigner please enter [0]" 
read powervar

if [ $powervar = 1 ]
then
	sudo shutdown --poweroff now
else
	echo "Rebooting..."
	sudo reboot
fi
exit
