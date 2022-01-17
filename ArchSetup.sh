#!/bin/bash

# INSTALL SCRIPT FOR Arch

cd $HOME

# System Update
yes | sudo pacman -Syu

# Enable Trim
sudo systemctl enable fstrim.timer
sudo systemctl start fstrim.timer

# Install Dependencies
yes | sudo pacman -S lib32-gnutls lib32-libldap lib32-libgpg-error lib32-libxml2 lib32-alsa-plugins lib32-sdl2 lib32-freetype2 lib32-dbus lib32-libgcrypt libgcrypt ffnvcodec-headers

# Install Apps
sudo pacman -S vivaldi htop nvtop dolphin-emu mgba-qt micro zoxide mpv piper qbittorrent kitty duf exa rofi neofetch steam nfs-utils flameshot wine caprine wget zip unzip lutris git pcmanfm-qt

# AUR Setup
sudo pacman -S base-devel --needed

# AUR Installs
paru -S bottles heroic-games-launcher-bin sameboy android-messages-desktop cemu spicetify-cli spicetify-themes-git ttf-ms-fonts balena-etcher

# Install Flatpak
sudo pacman -S flatpak

# Flatpak Installs
sudo flatpak install flathub net.rpcs3.RPCS3 com.discordapp.Discord org.citra_emu.citra org.yuzu_emu.yuzu org.flycast.Flycast io.github.m64p.m64p com.github.PintaProject.Pinta net.davidotek.pupgui2 com.spotify.Client -y

# Copy kitty conf
git clone https://github.com/Posty2k3/Backup
mkrdir -p $HOME/.config/kitty
cp -f $HOME/Backup/kitty.conf $HOME/.config/kitty/

# Rofi Theme
git clone https://github.com/undiabler/nord-rofi-theme
mkdir -p /usr/share/rofi/themes
cp $HOME/nord-rofi-theme/nord.rasi /usr/share/rofi/themes/
rm -rf $HOME/nord-rofi-theme

# WINE Theme
wget https://gist.github.com/Zeinok/ceaf6ff204792dde0ae31e0199d89398/raw/a5f0d3efb309d6d0728e1e54579e5c1081cf0d22/wine-breeze-dark.reg
wget https://gist.github.com/Zeinok/ceaf6ff204792dde0ae31e0199d89398/raw/a5f0d3efb309d6d0728e1e54579e5c1081cf0d22/wine-reset-theme.reg
wine regedit wine-breeze-dark.reg

# Mount NAS
sudo mkdir /mnt/WDMyCloud
sudo echo '192.168.1.39:/mnt/HD/HD_a2/Media   /mnt/WDMyCloud   nfs   defaults,timeo=900,retrans=5,_netdev	0 0' >> /etc/fstab

# Mount NTFS
sudo mkdir /mnt/Intel-660p
sudo mkdir /mnt/Samsung-970
sudo mkdir /mnt/Samsung-850
sudo echo 'UUID=AC84DACF84DA9AE2	/mnt/Intel-660p		ntfs	defaults	0	2' >> /etc/fstab
sudo echo 'UUID=608EB80B8EB7D7AC	/mnt/Samsung-970	ntfs	defaults	0	2' >> /etc/fstab
sudo echo 'UUID=369CDC6A9CDC2661	/mnt/Samsung-850	ntfs	defaults	0	2' >> /etc/fstab

# Update .zshrc
echo 'alias ls="exa -al --color=always --group-directories-first"' >> $HOME/.zshrc
echo 'alias df="duf"' >> $HOME/.zshrc
echo 'neofetch' >> $HOME/.zshrc
echo 'eval "$(zoxide init zsh)"' >> $HOME/.zshrc
echo 'alias cd="z"' >> $HOME/.zshrc

# Download Windows Programs
wget https://download.dm.origin.com/origin/live/OriginSetup.exe
wget https://github.com/bsnes-emu/bsnes/releases/download/v115/bsnes_v115-windows.zip
mkdir -p $HOME/Games
unzip bsnes_v115-windows.zip -d $HOME/Games/
rm bsnes_v115-windows.zip

# Download nvidia-vaapi-driver
git clone https://github.com/elFarto/nvidia-vaapi-driver

# Provide Todo List
echo -e "Setup Spicetify: https://spicetify.app/docs/getting-started/installation\n\nNVIDIA Kernel Parameter:\nEdit /etc/default/grub\nAdd kernel option to the line GRUB_CMDLINE_LINUX\nGRUB_CMDLINE_LINUX="nvidia-drm.modeset=1"\nRegenerate /boot/grub/grub.cfg:\ngrub-mkconfig -o /boot/grub/grub.cfg\n\nSetup nvidia-vaapi-driver https://github.com/elFarto/nvidia-vaapi-driver\n\nPipewire Config:\nNoticeable audio delay when starting playback. This is caused by node suspension when inactive. It can be disabled by editing /etc/pipewire/media-session.d/*-monitor.conf depending on where the delay occurs and changing property session.suspend-timeout-seconds to 0 to disable or to experiment with other values and see what works. Alternatively you can comment out the line suspend-node in /etc/pipewire/media-session.d/media-session.conf. Restart both the pipewire and pipewire-pulse systemd services to apply these changes, or alternatively reboot." >> ToDoList.txt

echo "All done! Please reboot the computer."
