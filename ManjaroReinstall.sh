#!/bin/bash

# INSTALL SCRIPT FOR Manjaro
# RUN AS SUDO

__dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd .. || exit

# System Update
pacman -Syu

# Enable Trim
systemctl enable fstrim.timer
systemctl start fstrim.timer

# Install Dependencies
pacman -S lib32-gnutls lib32-libldap lib32-libgpg-error lib32-libxml2 lib32-alsa-plugins lib32-sdl2 lib32-freetype2 lib32-dbus lib32-libgcrypt libgcrypt

# Install Apps
pacman -S vivaldi htop nvtop dolphin-emu mgba-qt micro zoxide mpv piper qbittorrent samba kitty etcher duf exa rofi neofetch steam-manjaro nfs-utils flameshot wine caprine wget zip unzip

# AUR Setup
pamac install base-devel git

# AUR Installs
pamac build bottles heroic-games-launcher-bin sameboy android-messages-desktop cemu gnome-shell-extension-weather-in-the-clock-git spicetify-cli-git spicetify-themes-git ttf-ms-fonts protontricks

# Install Flatpak
pamac install flatpak libpamac-flatpak-plugin

# Flatpak Installs
flatpak install flathub net.rpcs3.RPCS3 com.discordapp.Discord org.citra_emu.citra org.yuzu_emu.yuzu org.flycast.Flycast io.github.m64p.m64p com.github.PintaProject.Pinta net.davidotek.pupgui2 com.spotify.Client -y

# Copy kitty conf
git clone https://github.com/Posty2k3/Backup
mkrdir -p $HOME/.config/kitty
cp $HOME/Backup/kitty.conf $HOME/.config/kitty/

# GTK Themes & Icons
mkdir -p $HOME/.themes/
mkdir -p $HOME/.icons/
unzip $HOME/Backup/ThemesIcons.zip
cp -r $HOME/Icons/* $HOME/.icons/
cp -r $HOME/Themes/* $HOME/.themes/
rm -rf $HOME/Icons
rm -rf $HOME/Themes
rm -rf $HOME/Backup

# Flatpak Theme
flatpak override --filesystem=$HOME/.themes
flatpak override --env=GTK_THEME=Orchis-dark-compact

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
mkdir /mnt/WDMyCloud
echo '192.168.1.39:/mnt/HD/HD_a2/Media   /mnt/WDMyCloud   nfs   defaults,timeo=900,retrans=5,_netdev	0 0' >> /etc/fstab

# Update .zshrc
echo 'alias ls="exa -al --color=always --group-directories-first"' >> $HOME/.zshrc
echo 'alias df="duf"' >> $HOME/.zshrc
echo 'neofetch' >> $HOME/.zshrc
echo 'eval "$(zoxide init zsh)"' >> $HOME/.zshrc
echo 'alias cd="z"' >> $HOME/.zshrc

# Update Main Monitor - Login Screen
cp ~/.config/monitors.xml ~gdm/.config/

# Provide List of GNOME Extensions
echo -e "Animation Tweaks\nBlur my Shell\nSound Input & Output Device Chooser\nTransparent Window Moving\nAppIndicator and KstatusNotifierItem Support\nArcMenu\nDash to Panel\nGameMode\nGnome 4x UI Improvements\nPamac Updates Indicator\nUser Themes\nWeather in the Clock\nWindow is Ready - Notification Remover\nNo overview at start-up" >> GNOMEExtensions.txt

# Download Windows Programs
wget https://download.dm.origin.com/origin/live/OriginSetup.exe
wget https://github.com/bsnes-emu/bsnes/releases/download/v115/bsnes_v115-windows.zip

echo "All done! Please reboot the computer."
