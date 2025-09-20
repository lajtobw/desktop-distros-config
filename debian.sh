# LAST DEBIAN VERSION TESTED: 13
# Desktop environment: GNOME

###############################################################################
#                                   BASICS                                    #
###############################################################################

su

gnome-text-editor /etc/apt/sources.list  # add to all: contrib non-free
# Add:
# # trixie-backports
# deb http://httpredir.debian.org/debian trixie-backports main non-free-firmware contrib non-free
# deb-src http://httpredir.debian.org/debian trixie-backports main non-free-firmware contrib non-free

apt update && apt upgrade

echo "lajto   ALL=(ALL) ALL" >> /etc/sudoers

# REBOOT

###############################################################################
#                                   SOFTWARE                                  #
###############################################################################

sudo apt install wget nano git make libcanberra-pulse mpg123 \
libpulse0 libxml2 giflib-tools libc6 gtk2-engines gcc ca-certificates gnupg2 \
gcc-multilib g++ g++-multilib cmake lm-sensors apt-transport-https curl

# 32 bits architecture
sudo dpkg --add-architecture i386
sudo apt update
sudo apt upgrade
sudo apt install binutils-multiarch libstdc++6:i386 libgcc1:i386 \
zlib1g:i386 libcanberra-pulse:i386 libpulse0:i386 libxml2:i386

# NVIDIA drivers
sudo apt install linux-headers-$(uname -r|sed 's/[^-]*-[^-]*-//')
sudo apt update
sudo apt install nvidia-driver nvidia-driver-libs:i386 \
nvidia-vulkan-icd nvidia-vulkan-icd:i386 firmware-misc-nonfree \
mesa-vulkan-drivers libglx-mesa0:i386 mesa-vulkan-drivers:i386 \
libgl1-mesa-dri:i386
sudo apt install nvidia-vaapi-driver # NOTE: Very important for OBS!

# REBOOT

# Required for Cursor
sudo apt install libfuse2

# Compression tools
sudo apt install rar unrar p7zip p7zip-full p7zip-rar unace zip unzip \
bzip2 arj lhasa lzip xz-utils

# Codecs
sudo apt install ffmpegthumbnailer \
libgstreamer1.0-dev libgstreamer-plugins-base1.0-dev \
libgstreamer-plugins-bad1.0-dev gstreamer1.0-plugins-base \
gstreamer1.0-plugins-good gstreamer1.0-plugins-bad \
gstreamer1.0-plugins-ugly gstreamer1.0-libav gstreamer1.0-tools \
gstreamer1.0-x gstreamer1.0-alsa gstreamer1.0-gl gstreamer1.0-gtk3 \
gstreamer1.0-qt5 gstreamer1.0-pulseaudio gstreamer1.0-nice \
gstreamer1.0-vaapi

# Fonts
sudo apt install fonts-cantarell fonts-liberation fonts-noto \
ttf-mscorefonts-installer fonts-stix otf-stix \
fonts-oflb-asana-math fonts-mathjax
wget https://github.com/adobe-fonts/source-code-pro/archive/1.017R.zip && \
unzip 1.017R.zip && sudo mv source-code-pro-1.017R/OTF/*.otf \
/usr/local/share/fonts/ && fc-cache -f -v && rm 1.017R.zip && rm -Rf \
source-code-pro-1.017R

# Japanese and Chinese input
sudo apt install ibus-anthy ibus-mozc ibus-libpinyin

# Software
sudo apt install gnome-tweaks rhythmbox rhythmbox-plugins \
simple-scan transmission-gtk gimp inkscape audacity kid3 gparted \
soundconverter libreoffice mpv kdenlive blender gnome-clocks \
keepassxc screenfetch geogebra gnome-boxes vim

# Custom GNOME shortcuts (vertical workspaces)
gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-left \
"['<Super>Page_Up', '<Control><Alt>Left', '<Control><Alt>h']"
gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-right \
"['<Super>Page_Down', '<Control><Alt>Right', '<Control><Alt>l']"

# Google Chrome
curl -fSsL https://dl.google.com/linux/linux_signing_key.pub | sudo gpg --dearmor | sudo tee /usr/share/keyrings/google-chrome.gpg >> /dev/null
echo deb [arch=amd64 signed-by=/usr/share/keyrings/google-chrome.gpg] http://dl.google.com/linux/chrome/deb/ stable main | sudo tee /etc/apt/sources.list.d/google-chrome.list
sudo apt update
sudo apt install google-chrome-stable

# Discord
sudo apt install libc++1
wget "https://discord.com/api/download?platform=linux&format=deb" -O discord.deb
sudo apt install ./discord.deb
rm ./discord.deb

# OBS Studio
sudo apt install obs-studio

# VS Code
curl https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > microsoft.gpg
sudo install -o root -g root -m 644 microsoft.gpg /usr/share/keyrings/microsoft-archive-keyring.gpg
sudo sh -c 'echo "deb [arch=amd64,arm64,armhf signed-by=/usr/share/keyrings/microsoft-archive-keyring.gpg] https://packages.microsoft.com/repos/vscode stable main" > /etc/apt/sources.list.d/vscode.list'
sudo apt update
sudo apt install code
rm ./microsoft.gpg

# Docker
su
sudo apt install apt-transport-https ca-certificates \
curl gnupg-agent
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | \
sudo gpg --dearmor > /etc/apt/trusted.gpg.d/docker.gpg
echo "deb [arch=amd64] https://download.docker.com/linux/debian $(lsb_release -sc) stable" \
> /etc/apt/sources.list.d/docker-ce.list
apt update
apt install docker-ce docker-ce-cli docker-compose-plugin
exit
sudo usermod -aG docker lajto
sudo systemctl start docker
sudo systemctl enable docker

# Autoremove
sudo apt autoremove

# Telegram
wget -O telegram.tar.xz https://telegram.org/dl/desktop/linux
tar -xvf telegram.tar.xz
rm telegram.tar.xz
mv Telegram ~/.telegram-desktop-dir
~/.telegram-desktop-dir/Telegram # launchs Telegram

# Flatpak
sudo apt install flatpak
sudo apt install gnome-software-plugin-flatpak
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

# Steam
sudo apt install libgtk2.0-0:i386
sudo apt install steam-installer
# AFTER: Run "Install Steam app"

# Wine
sudo apt install wine wine32 wine64 libwine libwine:i386 fonts-wine
sudo apt install winetricks
winetricks corefonts fontfix vcrun2005sp1 vcrun2008 vcrun6

# Fix scroll desync in VS Code (and potentially other software)
sudo apt install imwheel

nano ~/.imwheelrc
#############################################
".*"
Control_L, Up,   Control_L|Button4
Control_L, Down, Control_L|Button5
Control_R, Up,   Control_R|Button4
Control_R, Down, Control_R|Button5
#############################################

mkdir -p ~/.config/systemd/user
touch ~/.config/systemd/user/imwheel.service

nano ~/.config/systemd/user/imwheel.service
#############################################
[Unit]
Description=IMWheel
Wants=display-manager.service
After=display-manager.service

[Service]
Type=simple
Environment=XAUTHORITY=%h/.Xauthority
ExecStart=/usr/bin/imwheel -b "4 5" -d
ExecStop=/usr/bin/pkill imwheel
RemainAfterExit=yes

[Install]
WantedBy=graphical-session.target
#############################################

systemctl --user enable imwheel.service
systemctl --user start imwheel.service

# REBOOT
