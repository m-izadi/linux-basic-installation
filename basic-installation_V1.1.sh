#!/bin/bash
#title:         basic-installation_V1.1.sh
#description:   Automatic installation of packages
#author:        MohammadReza Izadi
#created:       August 19 2022
#updated:       june 28 2023
#version:       1.0
#usage:         ./basic-installation_V1.1.sh
#==============================================================================
RED="\e[31m" ; GRN="\e[32m" ; YLW="\e[33m" ; NC="\e[0m"
user=$USER
if (( EUID == 0 )); then
	echo -e "\U1F534 ${RED}You must NOT be root to run this. ${NC}" 1>&2
	exit 1
fi
############## Welcome ##############
cols=$( tput cols )
rows=$( tput lines )
# message=$@
input_length=${#message}
half_input_length=$(( $input_length / 2 ))
middle_row=$(( $rows / 2 ))
middle_col=$(( ($cols / 2) - $half_input_length ))
tput clear
tput cup $middle_row $middle_col
tput bold
echo Welcome to ‌Basic Installation
tput sgr0
tput cup $( tput lines ) 0
sleep 2
#####################################


#### Menu options
#‌ Tools
options[0]="net-tools"
options[1]="vim"
options[2]="htop"
options[3]="curl"
options[4]="traceroute"
options[5]="pip"
options[6]="bash-completion"
options[7]="tmux"
options[8]="zsh"
options[9]="Ranger"
options[10]="Keepass"
# Service
options[11]="Docker"
options[12]="Git"
options[13]="OpenVpn"
options[14]="Nginx"
options[15]="Tomcat"
# Massenger
options[16]="TelegramDesktop"
options[17]="mattermost"
options[18]="Slack"
# IDE
options[19]="SublimeText"
options[20]="vscode"
# Player
options[21]="vlc"

#Actions to take based on selection
function ACTIONS {
# Tools
    if [[ ${choices[0]} ]]; then net_tools=net-tools && echo -e "${GRN}$net_tools selected${NC}" ; fi
    if [[ ${choices[1]} ]]; then vim=vim && echo -e "${GRN}$vim selected${NC}" ; fi
    if [[ ${choices[2]} ]]; then htop=htop && echo -e "${GRN}$htop selected${NC}" ; fi
    if [[ ${choices[3]} ]]; then curl=curl && echo -e "${GRN}$curl selected${NC}" ; fi
    if [[ ${choices[4]} ]]; then traceroute=traceroute && echo -e "${GRN}$traceroute selected${NC}" ; fi
    if [[ ${choices[5]} ]]; then pip=pip && echo -e ${GRN}"$pip selected${NC}" ; fi
    if [[ ${choices[6]} ]]; then bash_completion=bash-completion && echo -e "${GRN}$bash_completion selected${NC}" ; fi
    if [[ ${choices[7]} ]]; then tmux=tmux && echo -e "${GRN}$tmux selected${NC}" ; fi
    if [[ ${choices[8]} ]]; then zsh=zsh && echo -e "${GRN}$zsh selected${NC}" ; fi
    if [[ ${choices[9]} ]]; then Ranger=ranger-fm && echo -e "${GRN}$Ranger selected${NC}" ; fi
    if [[ ${choices[10]} ]]; then Keepass=keepass2 && echo -e "${GRN}$Keepass selected${NC}" ; fi
# Service
    if [[ ${choices[11]} ]]; then Docker=Docker && echo -e "${GRN}$Docker selected${NC}" ; fi
    if [[ ${choices[12]} ]]; then Git=Git && echo -e "${GRN}$Git selected${NC}" ; fi
    if [[ ${choices[13]} ]]; then OpenVpn=OpenVpn && echo -e "${GRN}$OpenVpn selected${NC}" ; fi
    if [[ ${choices[14]} ]]; then Nginx=Nginx && echo -e "${GRN}$Nginx selected${NC}" ; fi
    if [[ ${choices[15]} ]]; then Tomcat=Tomcat && echo -e "${GRN}$Tomcat selected${NC}" ; fi
# Massenger
    if [[ ${choices[16]} ]]; then TelegramDesktop=TelegramDesktop && echo -e "${GRN}$TelegramDesktop selected${NC}" ; fi
    if [[ ${choices[17]} ]]; then mattermost=mattermost && echo -e "${GRN}$mattermost selected${NC}" ; fi
    if [[ ${choices[18]} ]]; then Slack=Slack && echo -e "${GRN}$Slack selected${NC}" ; fi
# IDE
    if [[ ${choices[19]} ]]; then SublimeText=SublimeText && echo "${GRN}$SublimeText selected${NC}" ; fi
    if [[ ${choices[20]} ]]; then vscode=vscode && echo -e "${GRN}$vscode selected${NC}" ; fi
# Player
    if [[ ${choices[21]} ]]; then vlc=vlc && echo -e "${GRN}$vlc selected${NC}" ; fi
}

#Variables
ERROR=" "
#Clear screen for menu
clear

#Menu function
function MENU {
    echo "Menu Options"
    for PKG in "${!options[@]}"; do
        echo "[""${choices[PKG]:- }""]" $(( PKG+1 ))") ${options[PKG]} "
    done
    echo "$ERROR"
}

#Menu loop
while MENU && read -e -rp "Select the desired options using their number (again to uncheck, ENTER when done): " -n2 SELECTION && [[ -n "$SELECTION" ]]; do
    clear
    if [[ "$SELECTION" == *[[:digit:]]* && $SELECTION -ge 1 && $SELECTION -le ${#options[@]} ]]; then
        (( SELECTION-- ))   # We subtract 1 to equal options
        if [[ "${choices[SELECTION]}" == "+" ]]; then
            choices[SELECTION]=""
        else
            choices[SELECTION]="+"
        fi
            ERROR=" "
    else
        ERROR="Invalid option: $SELECTION"
    fi
done

ACTIONS
# prevent root from creating ~/tmp/ by creating it ourself and cause permission problems
# Make .node because in the later versions of npm, it's too stupid to make a folder anymore
mkdir ~/tmp/ ~/.node/ >/dev/null 2>&1

#######################
######## Proxy ########
#######################
read -t 15 -rp "Would you like Set Proxy? (Default No) (Y/n) " proxy && proxy="${proxy^^}"
if [ "$proxy" == "Y" ] ; then
	read -rp "Do you like to delete proxy after completing the installation process? (Default No) (Y/n)" rm_proxy && rm_proxy="${rm_proxy^^}"
	read -rp "Please enter your Proxy: " proxy_address
    echo -e "\n\n${GRN}##########################################  Set Proxy  #######################################${NC}"

# APT
[ -f /etc/apt/apt.conf.d/proxy.conf ] && echo "apt Proxy exist." || sudo touch /etc/apt/apt.conf.d/proxy.conf && sudo setfacl -Rm u:"$user":rw  /etc/apt/apt.conf.d/proxy.conf && sudo echo -e "Acquire::http::Proxy \"http://$proxy/\";" > /etc/apt/apt.conf.d/proxy.conf && echo -e "apt Proxy Set Successfully" || echo -e "\U1F534 ${RED}Your user does not have access to /etc/apt/apt.conf.d/proxy.conf \nPlease manually add (Acquire::http::Proxy \"http://$proxy/\";) in /etc/apt/apt.conf.d/proxy.conf \nOR \nSet Permisson${NC}"

	# sudo touch /etc/apt/apt.conf.d/proxy.conf
	# sudo setfacl -Rm u:"$user":rw  /etc/apt/apt.conf.d/proxy.conf
	# sudo echo -e "Acquire::http::Proxy \"http://$proxy/\";" > /etc/apt/apt.conf.d/proxy.conf && echo -e "apt Proxy Set Successfully" || echo -e "\U1F534 ${RED}Your user does not have access to /etc/apt/apt.conf.d/proxy.conf \nPlease manually add proxy in /etc/apt/apt.conf.d/proxy.conf \nOR \nSet Permisson${NC}"
# wget
    if grep -Fxq "use_proxy=yes" /etc/wgetrc
    then
        echo -e "${YLW}Proxy was not set. The Proxy is already set in the Configuration."
    else
    	sudo setfacl -Rm u:"$USER":rw  /etc/wgetrc
    	sudo echo -e "use_proxy=yes\nhttp_proxy=$proxy_address" >> /etc/wgetrc && echo -e "wget Proxy Set Successfully" || echo -e "\U1F534 ${RED}Your user does not have access to /etc/wgetrc \nPlease manually add \nuse_proxy=yes\nhttp_proxy=$proxy_address \nin /etc/wgetrc \nOR \nSet Permisson${NC}"
    fi
fi

echo -e "\n${GRN}							Tasks Started in : ${YLW}$(date "+%Y/%m/%d %H:%M") ${NC}"
echo -e "${GRN}##############################################################################################"
echo -e "${GRN}######################################  Start Installation  ##################################"
echo -e "${GRN}##############################################################################################"
	sudo apt update

echo -e "\U231B ${GRN}######################################     basic tools      ##################################${NC}"
	
	if [ "$basic_tools" == "Y" ];then
	    sudo apt install net-tools vim htop curl traceroute pip bash-completion -y
	fi

echo -e "\U231B ${GRN}######################################     $net_tools $vim $htop $curl $traceroute $pip $bash_completion $tmux $vlc $keepass   ##################################${NC}"

if [[ -n $net_tools || -n $vim || -n $htop || -n $curl || -n $traceroute || -n $pip || -n $bash_completion || -n $tmux || -n $vlc || -n $keepass ]];then
	{ sudo apt install $net_tools $vim $htop $curl $traceroute $pip $bash_completion $tmux $vlc $keepass -y && echo -e "$net_tools $vim $htop $curl $traceroute $pip $bash_completion $tmux $vlc $keepass was Installed " ;} || \
	echo -e "\U1F534 $RED----> $net_tools $vim $htop $curl $traceroute $pip $bash_completion $tmux $vlc $keepass installation steps are not done correctly.${NC}" && exit 1
else
		echo -e "\U1F4CC ${YLW}This step was skipped${NC}"
fi

# echo -e "${GRN}######################################       KeePass        ##################################${NC}"
# 	if [ "$keepass" == "Y" ];then
# 	    # sudo apt-add-repository ppa:jtaylor/keepass
# 	    # sudo apt-get update && sudo apt-get upgrade
# 	    sudo apt-get install keepass2 -y
# 	fi
echo -e "\U231B ${GRN}######################################       openvpn        ##################################${NC}"
# https://www.cyberciti.biz/faq/howto-setup-openvpn-server-on-ubuntu-linux-14-04-or-16-04-lts/
	if [ -n "$openvpn" ];then
	    wget https://git.io/vpn -O openvpn-install.sh
	    sudo chmod +x openvpn-install.sh
	    sudo bash openvpn-install.sh
	else
		echo -e "\U1F4CC ${YLW}This step was skipped${NC}"
	fi

echo -e "\U231B ${GRN}######################################        ranger        ##################################${NC}"
	if [ -n "$ranger" ];then
	    sudo pip install ranger-fm
	else
		echo -e "\U1F4CC ${YLW}This step was skipped${NC}"
	fi
echo -e "\U231B ${GRN}######################################        Docker        ##################################${NC}"
	if [ -n "$docker" ]; then
		sudo apt-get update
		sudo apt-get install -y \
		   ca-certificates \
		   curl \
		   gnupg \
		   lsb-release
		sudo mkdir -p /etc/apt/keyrings
		curl -fsSL "$curl_url_proxy" https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
		echo \
		  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
		  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
		sudo chmod a+r /etc/apt/keyrings/docker.gpg
		sudo apt update
		sudo apt-get install docker-ce docker-ce-cli containerd.io docker-compose-plugin -y
	else
		echo -e "\U1F4CC ${YLW}This step was skipped${NC}"
	fi

	# if [ "$docker" == "Y" ];then
	#     curl -Sslf "$curl_url_proxy" https://get.docker.com/ | sudo bash
	# fi
echo -e "\U231B ${GRN}######################################         Git          ##################################${NC}"
	if [ -n "$git" ];then
	    sudo apt install git -y
	    sudo git config --global user.name "$git_name"
	    sudo git config --global user.email "$git_email"
	else
		echo -e "\U1F4CC ${YLW}This step was skipped${NC}"
	fi

echo -e "\U231B ${GRN}######################################         zsh          ##################################${NC}"
    if [ -n "$zsh" ];then
            sudo apt install zsh -y
            sh -c "$(curl -fsSL "$curl_url_proxy" https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh )"
            # default shell
            sudo chsh -s /usr/bin/zsh
            chsh -s /usr/bin/zsh
        # sudo sh -c "$(wget https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh -O -)"
        # sudo apt install zsh -y
        # chsh -s $(which zsh)
	else
		echo -e "\U1F4CC ${YLW}This step was skipped${NC}"
    fi
echo -e "\U231B ${GRN}######################################        tomcat        ##################################${NC}"
	if [ -n "$tomcat" ]; then
		sudo apt-get install -y tomcat7 tomcat7-admin tomcat7-common tomcat7-docs tomcat7-examples tomcat7-user
	else
		echo -e "\U1F4CC ${YLW}This step was skipped${NC}"
	fi
echo -e "\U231B ${GRN}######################################        nginx         ##################################${NC}"
	if [ -n "$nginx" ]; then
		sudo apt-get install -y nginx
	else
		echo -e "\U1F4CC ${YLW}This step was skipped${NC}"
	fi
echo -e "\U231B ${GRN}######################################      mattermost      ##################################${NC}"
	if [ -n "$mattermost" ];then
	    curl -o- "$curl_url_proxy" https://deb.packages.mattermost.com/setup-repo.sh | sudo bash
	    sudo apt install mattermost-desktop -y
	    sudo apt upgrade mattermost-desktop -y
	else
		echo -e "\U1F4CC ${YLW}This step was skipped${NC}"
	fi
echo -e "\U231B ${GRN}######################################        slack         ##################################${NC}"
	if [ -n "$slack" ];then
	    sudo snap install slack --classic
	else
		echo -e "\U1F4CC ${YLW}This step was skipped${NC}"
	fi
echo -e "\U231B ${GRN}######################################   Telegram Desktop   ##################################${NC}"
	if [ -n "$telegram_desktop" ];then
	    sudo snap install telegram-desktop
	else
		echo -e "\U1F4CC ${YLW}This step was skipped${NC}"
	fi
echo -e "\U231B ${GRN}######################################     sublimetext      ##################################${NC}"
	if [ -n "$sublimetext" ]; then
	    #sudo wget -O- https://download.sublimetext.com/sublimehq-pub.gpg | gpg --dearmor | sudo tee /usr/share/keyrings/sublimehq.gpg
	    #echo 'deb [signed-by=/usr/share/keyrings/sublimehq.gpg] https://download.sublimetext.com/ apt/stable/' | sudo tee /etc/apt/sources.list.d/sublime-text.list
	    #sudo apt install sublime-text -y
	    sudo snap install sublime-text --classic
	else
		echo -e "\U1F4CC ${YLW}This step was skipped${NC}"
	fi
echo -e "\U231B ${GRN}######################################        vscode        ##################################${NC}"
	if [ -n "$vscode" ]; then
		sudo apt install software-properties-common apt-transport-https wget -y
		wget -q https://packages.microsoft.com/keys/microsoft.asc -O- | sudo apt-key add -
		sudo add-apt-repository "deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main"
		sudo apt update
		sudo apt install code
		code --version
	else
		echo -e "\U1F4CC ${YLW}This step was skipped${NC}"
	fi
######################################################################################################################
## SSH
# ssh-keygen -t rsa -b 2048 -C "$email" -N "" -f ~/.ssh/id_rsa
echo -e "\U2705 ${GRN}----> Installation is complete .${NC}\n"
if [ -n "$docker" ]; then
	echo -e "${YLW}Please log out and log back in to finish Docker configuration.${NC}"
fi

############## Remove Proxy ##############

if [ "$rm_proxy" == "Y" ] ; then
    rm -rf /etc/apt/apt.conf.d/proxy.conf
fi

# The following will be added in the near future## Goal
# Install Chromiume
# xdotools

# add Local Repo

# exit problem in apt 