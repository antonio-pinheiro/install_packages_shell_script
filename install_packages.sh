#!/bin/bash

############################################################################## 
##									    ## 
##			       Install Packages    	     .~.	    ##
##			Created by:  Antônio Pinheiro        /V\            ##
##							    // \\	    ##
##							   /(   )\          ##
##							    ^`~'^           ##
##							     TUX	    ##
##				                         		    ##
##	 OS Compatibility: Debian 11, Ubuntu 20.04 and Linux Mint 20.x      ##	
##                      						    ##
##############################################################################
##  Project:	Install Packages					    ##
##									    ##
##  File name:  install_packages.sh 					    ##
##									    ##
##  Description:  Install Deb, Snap and Flatpak applications                ##
##	                                                                    ##
##  Date: 15/12/2021							    ##             
##  									    ##
## 									    ##
##############################################################################
##			  !!!INSTRUCTIONS!!!				    ##
##                      First install option 1                              ##
##	        (APT - General and Essential Packages)                	    ##
## 		                                                            ##
##############################################################################

# Load absolute path to script, dirname parameter strips the script name from the end of the path 
# and readlink resolves the name of absolute path. $0 is the relative path.
file_directory=$(dirname -- $(readlink -fn -- "$0"))

# Detect Operational System in use.
distro=$(lsb_release -i | cut -f 2-)
#USER=$(ps -o user= -p $$ | awk '{print $1}')

add_user_sudoers(){
    
    if [[ $(id -u) == 0 ]]; then
        echo "Which User do you want to add in Sudoers File?: "
        read user
        echo "$user  ALL=(ALL:ALL) ALL" >> /etc/sudoers
        start_function
    
    else
        echo "You must be root to run this function"
        echo "Please execute this script as root and run this option again."
        start_function

    fi
}

# Enable Flatpak support.
enable_flatpak(){ #OK
    
    echo "Please reboot your system after install these packages."
    echo "Flatpak services requires a reboot to work correctly!"
    sudo apt install flatpak && sudo apt install --reinstall ca-certificates
    flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
    echo
    echo "Flatpak Successfully installed and enabled."
    start_function
}

# Remove file that blocks Snap in Linux Mint and enable it for installation or install Snap in Debian.
enable_snap(){ #OK

    echo "Please reboot your system after install these packages."
    echo "Snap services requires a reboot to work correctly!"

    if [[ $distro == "Linuxmint" ]]; then 
        sudo rm /etc/apt/preferences.d/nosnap.pref
        echo "Support to Snap Enabled"
        echo "Installing Snap Service..."
        sudo apt install snapd
        start_function

    elif [[ $distro == "Debian" ]]; then
        echo "Installing Snap Service..."
        sudo apt install snapd
        start_function

    elif [[ $distro == "Ubuntu" ]]; then
        echo "Ubuntu already has Snap support."
        start_function

    else 
        echo "Your Operational System is not supported. This script only supports Debian 11, Linux Mint 20.x and Ubuntu 20.04"
        exit
    fi
}

# Function responsible for install flatpak applications.. 
# Reading the file and iterating line by line to install packages.
flatpak_packages(){
    
    echo "This option installs a collection of flatpak packages."
    sleep 1
    while IFS= read -r line || [[ -n "$line" ]]; do
        sudo flatpak install -y "$line"
    done < "$flatpak_programs"
    echo
    echo "Flatpak packages installed"
    start_function
}

# Function responsible for install python modules for genetic algorithm support. 
# Reading the file and iterating line by line to install packages.
genetic_algorithm_packages(){
    
    echo "This option installs a collection of python packages to execute Genetic Cars."
    sleep 1
    while IFS= read -r line || [[ -n "$line" ]]; do
        pip3 install "$line"
    done < "$genetic_cars_packages"
    echo
    echo "Genetic Algorithm Support installed"
    start_function
}

# Function responsible for install snap applications. 
# Reading the file and iterating line by line to install packages.
snap_packages(){ #OK

    echo "This option installs a collection of snap packages."
    sleep 1
    while IFS= read -r line || [[ -n "$line" ]]; do
        sudo snap install "$line"
    done < "$snap_programs"
    echo
    echo "Snap packages installed"
    start_function
}

# Function responsible for install deb applications through apt-get. 
# Reading the file and iterating line by line to install packages.
apt_packages(){ #OK

    echo "This option installs a collection of general and essential packages."
    sleep 1
    #sudo apt update
    while IFS= read -r line || [[ -n "$line" ]]; do
        sudo apt install $line -y
    done < "$apt_programs"
    echo
    echo "Deb packages installed"
    start_function   
}

browser_install(){
    
    echo "Which browser do you want to install [1 - Chrome | 2 - Brave | 3 - Back to Menu]: "
    read choice

    if [[ $choice == "1" ]]; then
        wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
        sudo dpkg -i google-chrome-stable_current_amd64.deb
        sudo rm google-chrome-stable_current_amd64.deb
        start_function

    elif [[ $choice == "2" ]]; then
        sudo apt install apt-transport-https curl
        sudo curl -fsSLo /usr/share/keyrings/brave-browser-archive-keyring.gpg https://brave-browser-apt-release.s3.brave.com/brave-browser-archive-keyring.gpg
        echo "deb [signed-by=/usr/share/keyrings/brave-browser-archive-keyring.gpg arch=amd64] https://brave-browser-apt-release.s3.brave.com/ stable main"|sudo tee /etc/apt/sources.list.d/brave-browser-release.list
        sudo apt update
        sudo apt install brave-browser
        start_function

    elif [[ $choice == "3" ]]; then
        start_function
    
    else
        echo "Invalid Option..."
        browser_install 
    fi
}

# Shows to user the packages installation options. 
start_function(){
echo
echo "Please select an option."
echo
echo "1  - APT - General and Essential Packages"
echo "2  - APT - Design Packages"
echo "3  - APT - Epson Print Package"
echo "4  - APT - Games Package"
echo "5  - APT - Install Vulkan Support for AMD-GPU"
echo "6  - APT - Install Debian Non-free Packages"
echo "7  - SNAP - Enable and Install Snap Service"
echo "8  - FLATPAK - Enable and Install Flatpak service"
echo "9  - SNAP - Install Snap Packages"
echo "10 - FLATPAK - Install Flatpak Packages"
echo "11 - WineHQ Automatic Installation"
echo "12 - Add user to sudoers file"
echo "13 - Install Google Chrome or Brave Browser"
echo "14 - Genetic Algorithm Packages Python"
echo "15 - Close application"
echo

# It receives the user's choice and loads the files in .txt format.
# Calls the function responsible for reading the file and iterating line by line to install the programs.
while :
do
  read select_option
  case $select_option in

	1)  apt_programs="$file_directory/txt_files/apt_programs.txt"
        apt_packages;;
	
    2)  apt_programs="$file_directory/txt_files/apt_design.txt"
        apt_packages;;
    
    3)  apt_programs="$file_directory/txt_files/apt_epson.txt"
        apt_packages;;

    4)  apt_programs="$file_directory/txt_files/apt_games.txt"
        apt_packages;;

    5)  apt_programs="$file_directory/txt_files/apt_vulkan.txt"
        apt_packages;;
	
    6)  apt_programs="$file_directory/txt_files/apt_nonfree.txt"
        echo "This function only works with Debian"
        sleep 2
        apt_packages;;
        
    7)  enable_snap;;

    8)  enable_flatpak;;

    9)  snap_programs="$file_directory/txt_files/snap_packages.txt"
        snap_packages;;
    
    10) flatpak_programs="$file_directory/txt_files/flatpak_packages.txt"
        flatpak_packages;;

    11) wine_packages;;  
    
    12) add_user_sudoers;;
    
    13) browser_install;;
    
    14) genetic_cars_packages="$file_directory/txt_files/genetic_cars_packages.txt"
        genetic_algorithm_packages;;
    
    15) exit

  esac
done
}


start_function

