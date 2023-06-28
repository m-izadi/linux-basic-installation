#!/bin/bash
# zsh vlc tmux OpenVpn Keepass Ranger Docker Git Tomcat  Nginx mattermost  TelegramDesktop SublimeText Slack VScode htop
RED="\e[31m" ; GRN="\e[32m" ; YLW="\e[33m" ; END="\e[0m"
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

#####################################
# prevent root from creating ~/tmp/ by creating it ourself and cause permission problems
# Make .node because in the later versions of npm, it's too stupid to make a folder anymore
mkdir ~/tmp/ ~/.node/

######## Proxy
read -t 5 -pr "\nWould you like Set Proxy? (Default No) (Y/n) " proxy && proxy="${proxy^^}" #toUpperCase
if [ "$proxy" == "Y" ] ; then
	read -rp "Do you like to delete proxy after completing the installation process? (Default No) (Y/n)" rm_proxy && rm_proxy="${rm_proxy^^}"
	read -rp "Please enter your Proxy: " proxy_address

fi

if [ "$proxy" == "Y" ];then
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

# Basic Tools ( net-tools / vim / htop /curl /  )
read -t 5 -rp "\nWould you like to install Basic Tools? (Default No) (Y/n) " basic_tools && basic_tools="${basic_tools^^}"
	# if [ -z "$basic_tools" ]; then
	# 	basic_tools="N"
	# fi

# ZSH
read -t 5 -rp "\nWould you like to install oh-my-zsh? (Default No) (Y/n) " zsh && zsh="${zsh^^}"
	# if [ -z "$zsh" ]; then
	# 	zsh="N"
	# fi

# vlc
read -t 15 -rp "Would you like to install vlc? (Default No) (Y/n) " vlc && { vlc="${vlc^^}" && [ "$vlc" == "Y" ] ;} && vlc=vlc 
# read -t 5 -rp "\nWould you like to install vlc? (Default No) (Y/n) " vlc && vlc="${vlc^^}"
	# if [ -z "$vlc" ]; then
	# 	vlc="N"
	# else
	# 	vlc=vlc
	# fi

# tmux
read -t 5 -rp "\nWould you like to install tmux? (Default No) (Y/n) " tmux && { tmux="${tmux^^}" && [ "$tmux" == "Y" ] ;} && tmux=tmux 
	# if [ -z "$tmux" ]; then
	# 	tmux="N"
	# else
	# 	tmux=tmux
	# fi
# keepass

read -t 5 -rp "\nWould you like to install keepass? (Default No) (Y/n) "keepass && { keepass="${keepass^^}" && [ "$keepass" == "Y" ] ;} && keepass=keepass 
	# if [ -z "$keepass" ]; then
	# 	keepass="N"
	# else
	# 	keepass=keepass
	# fi

# openvpn
read -t 5 -rp "\nWould you like to install openvpn? (Default No) (Y/n) " openvpn &&	openvpn="${openvpn^^}"
	# if [ -z "$openvpn" ]; then
	# 	openvpn="N"
	# fi



# ranger
read -t 5 -rp "\nWould you like to install ranger? (Default No) (Y/n) " ranger && ranger="${ranger^^}"
	# if [ -z "$ranger" ]; then
	# 	ranger="N"
	# fi

# Docker
read -t 5 -rp "\nWould you like to install docker ? (Default No) (Y/n) " docker && docker="${docker^^}"
	# if [ -z "$docker" ]; then
	# 	docker="N"
	# fi

# git
read -t 5 -rp "\nWould you like to install git? (Default No) (Y/n) " git && git="${git^^}"
	if [ "$git" == "Y" ] ; then
		read -t 10 -rp "${YLW} Please enter your name (for git): ${NC}" git_name
		read -t 10 -rp "${YLW} Please enter your email (for git): ${NC}" git_email 
	fi

# tomcat
	read -t 5 -rp "\nWould you like to install tomcat? (Default No)(Y/n) " tomcat && tomcat="${tomcat^^}"
# nginx
	read -t 5 -rp "\nWould you like to install nginx? (Default No) (Y/n) " nginx &&	nginx="${nginx^^}"
	if [ -z "$nginx" ]; then
		nginx="N"
	fi

# mattermost
	read -t 5 -rp "\nWould you like to install mattermost? (Default No) (Y/n) " mattermost && mattermost="${mattermost^^}"

# slack
	read -t 5 -rp "\nWould you like to install slack? (Default No) (Y/n) " slack &&	slack="${slack^^}"

# telegram_desktop
	read -t 5 -rp "\nWould you like to install telegram_desktop? (Default No) (Y/n) " telegram_desktop && telegram_desktop="${telegram_desktop^^}"

# sublimetext
	read -t 5 -rp "\nWould you like to install sublimetext? (Default No) (Y/n) " sublimetext &&  sublimetext="${sublimetext^^}"
# vscode
	read -t 5 -rp "\nWould you like to install vscode? (Default No) (Y/n) " vscode && vscode="${vscode^^}"

echo -e "${GRN}#####################${NC} Tasks Started in : ${YLW}$(date "+%Y/%m/%d %H:%M") ${GRN}########################${NC}"
echo -e "\n\n${GRN}##############################################################################################"
echo -e "${GRN}######################################  Start Installation  ##################################"
echo -e "${GRN}##############################################################################################"
	sudo apt update

echo -e "\U231B ${GRN}######################################     basic tools      ##################################${NC}"
	
	if [ "$basic_tools" == "Y" ];then
	    sudo apt install net-tools vim htop curl traceroute pip bash-completion -y
	fi

echo -e "\U231B ${GRN}######################################     Apt Install      ##################################${NC}"

if [[ $vlc == "vlc" || $tmux == "tmux" || $keepass == "keepass" ]];then
	{ sudo apt install $vlc $tmux $keepass -y && echo -e "$vlc $tmux $keepass was Installed " ;} || \
	echo -e "\U1F534 $RED----> $vlc $tmux $keepass installation steps are not done correctly.${NC}"; exit 1
else
		echo -e "\U1F4CC ${YLW}This step was skipped${NC}"
fi

# echo -e "${GRN}######################################         vlc          ##################################${NC}"
# 	if [ "$vlc" == "Y" ];then
# 	    sudo apt install vlc -y
# 	fi

# echo -e "${GRN}######################################         tmux         ##################################${NC}"
# 	if [ "$tmux" == "Y" ];then
# 	    sudo apt install tmux -y
# 	fi
# echo -e "${GRN}######################################       KeePass        ##################################${NC}"
# 	if [ "$keepass" == "Y" ];then
# 	    # sudo apt-add-repository ppa:jtaylor/keepass
# 	    # sudo apt-get update && sudo apt-get upgrade
# 	    sudo apt-get install keepass2 -y
# 	fi
echo -e "\U231B ${GRN}######################################       openvpn        ##################################${NC}"
	if [ "$openvpn" == "Y" ];then
	    # https://www.cyberciti.biz/faq/howto-setup-openvpn-server-on-ubuntu-linux-14-04-or-16-04-lts/
	    wget https://git.io/vpn -O openvpn-install.sh
	    sudo chmod +x openvpn-install.sh
	    sudo bash openvpn-install.sh
	else
		echo -e "\U1F4CC ${YLW}This step was skipped${NC}"
	fi

echo -e "\U231B ${GRN}######################################        ranger        ##################################${NC}"
	if [ "$ranger" == "Y" ];then
	    sudo pip install ranger-fm
	else
		echo -e "\U1F4CC ${YLW}This step was skipped${NC}"
	fi
echo -e "\U231B ${GRN}######################################        Docker        ##################################${NC}"
	if [ "$docker" == "Y" ]; then
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
	if [ "$git" == "Y" ];then
	    sudo apt install git -y
	    sudo git config --global user.name "$git_name"
	    sudo git config --global user.email "$git_email"
	else
		echo -e "\U1F4CC ${YLW}This step was skipped${NC}"
	fi

echo -e "\U231B ${GRN}######################################         zsh          ##################################${NC}"
    if [ "$zsh" == "Y" ];then
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
	if [ "$tomcat" == "Y" ]; then
		sudo apt-get install -y tomcat7 tomcat7-admin tomcat7-common tomcat7-docs tomcat7-examples tomcat7-user
	else
		echo -e "\U1F4CC ${YLW}This step was skipped${NC}"
	fi
echo -e "\U231B ${GRN}######################################        nginx         ##################################${NC}"
	if [ "$nginx" == "Y" ]; then
		sudo apt-get install -y nginx
	else
		echo -e "\U1F4CC ${YLW}This step was skipped${NC}"
	fi
echo -e "\U231B ${GRN}######################################      mattermost      ##################################${NC}"
	if [ "$mattermost" == "Y" ];then
	    curl -o- "$curl_url_proxy" https://deb.packages.mattermost.com/setup-repo.sh | sudo bash
	    sudo apt install mattermost-desktop -y
	    sudo apt upgrade mattermost-desktop -y
	else
		echo -e "\U1F4CC ${YLW}This step was skipped${NC}"
	fi
echo -e "\U231B ${GRN}######################################        slack         ##################################${NC}"
	if [ "$slack" == "Y" ];then
	    sudo snap install slack --classic
	else
		echo -e "\U1F4CC ${YLW}This step was skipped${NC}"
	fi
echo -e "\U231B ${GRN}######################################   Telegram Desktop   ##################################${NC}"
	if [ "$telegram_desktop" == "Y" ];then
	    sudo snap install telegram-desktop
	else
		echo -e "\U1F4CC ${YLW}This step was skipped${NC}"
	fi
echo -e "\U231B ${GRN}######################################     sublimetext      ##################################${NC}"
	if [ "$sublimetext" == "Y" ]; then
	    #sudo wget -O- https://download.sublimetext.com/sublimehq-pub.gpg | gpg --dearmor | sudo tee /usr/share/keyrings/sublimehq.gpg
	    #echo 'deb [signed-by=/usr/share/keyrings/sublimehq.gpg] https://download.sublimetext.com/ apt/stable/' | sudo tee /etc/apt/sources.list.d/sublime-text.list
	    #sudo apt install sublime-text -y
	    sudo snap install sublime-text --classic
	else
		echo -e "\U1F4CC ${YLW}This step was skipped${NC}"
	fi
echo -e "\U231B ${GRN}######################################        vscode        ##################################${NC}"
	if [ "$vscode" == "Y" ]; then
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
# ssh-keygen -t rsa -b 2048 -C "$email" -N "" -f ~/.ssh/id_rsa
echo -e "\U2705 ${GRN}----> Installation is complete .${NC}\n"
if [ "$docker" == "Y" ]; then
	echo -e "${YLW}Please log out and log back in to finish Docker configuration.${NC}"
fi

############## Remove Proxy ##############

if [ "$rm_proxy" == "Y" ] ; then
    rm -rf /etc/apt/apt.conf.d/proxy.conf
fi
