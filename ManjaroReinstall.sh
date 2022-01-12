#!/bin/bash

# INSTALL SCRIPT FOR Manjaro

cd $HOME

# System Update
yes | sudo pacman -Syu

# Enable Trim
sudo systemctl enable fstrim.timer
sudo systemctl start fstrim.timer

# Install Dependencies
yes | sudo pacman -S lib32-gnutls lib32-libldap lib32-libgpg-error lib32-libxml2 lib32-alsa-plugins lib32-sdl2 lib32-freetype2 lib32-dbus lib32-libgcrypt libgcrypt

# Install Apps
sudo pacman -S vivaldi htop nvtop dolphin-emu mgba-qt micro zoxide mpv piper qbittorrent samba kitty etcher duf exa rofi neofetch steam-manjaro nfs-utils flameshot wine caprine wget zip unzip winetricks lutris gnome-tweaks yay

# AUR Setup
sudo pamac install base-devel git

# AUR Installs
yay -S bottles heroic-games-launcher-bin sameboy android-messages-desktop cemu gnome-shell-extension-weather-in-the-clock-git spicetify-cli-git spicetify-themes-git ttf-ms-fonts protontricks

# Install Flatpak
sudo pamac install flatpak libpamac-flatpak-plugin

# Flatpak Installs
sudo flatpak install flathub net.rpcs3.RPCS3 com.discordapp.Discord org.citra_emu.citra org.yuzu_emu.yuzu org.flycast.Flycast io.github.m64p.m64p com.github.PintaProject.Pinta net.davidotek.pupgui2 com.spotify.Client -y

# Copy kitty conf
git clone https://github.com/Posty2k3/Backup
mkrdir -p $HOME/.config/kitty
cp $HOME/Backup/kitty.conf $HOME/.config/kitty/

# GTK Themes & Icons & Wallpapers
mkdir -p $HOME/.themes/
mkdir -p $HOME/.icons/
unzip $HOME/Backup/ThemesIcons.zip
cp -r $HOME/Icons/* $HOME/.icons/
cp -r $HOME/Themes/* $HOME/.themes/
mv $HOME/Backup/*.png $HOME/Pictures/
rm -rf $HOME/Icons
rm -rf $HOME/Themes
rm -rf $HOME/Backup

# Flatpak Theme
sudo flatpak override --filesystem=$HOME/.themes
sudo flatpak override --env=GTK_THEME=Orchis-dark-compact

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

# Download Windows Programs
wget https://download.dm.origin.com/origin/live/OriginSetup.exe
wget https://github.com/bsnes-emu/bsnes/releases/download/v115/bsnes_v115-windows.zip
mkdir -p $HOME/Games
unzip bsnes_v115-windows.zip -d $HOME/Games/
rm bsnes_v115-windows.zip

# Download nvidia-vaapi-driver
git clone https://github.com/elFarto/nvidia-vaapi-driver

# Install Pipewire and Remove Pulseaudio
yes | sudo pacman -Rdd manjaro-pulse
yes | sudo pacman -Rdd pulseaudio
yes | sudo pacman -S manjaro-pipewire

# Provide List of GNOME Extensions
echo -e "Animation Tweaks\nBlur my Shell\nSound Input & Output Device Chooser\nTransparent Window Moving\nAppIndicator and KstatusNotifierItem Support\nArcMenu\nDash to Panel\nGameMode\nGnome 4x UI Improvements\nPamac Updates Indicator\nUser Themes\nWeather in the Clock\nWindow is Ready - Notification Remover\nNo overview at start-up" >> GNOMEExtensions.txt

# Provide Todo List
echo -e "Setup Spicetify: https://spicetify.app/docs/getting-started/installation\n\nNVIDIA Kernel Parameter:\nEdit /etc/default/grub\nAdd kernel option to the line GRUB_CMDLINE_LINUX\nGRUB_CMDLINE_LINUX="nvidia-drm.modeset=1"\nRegenerate /boot/grub/grub.cfg:\ngrub-mkconfig -o /boot/grub/grub.cfg\n\nSetup nvidia-vaapi-driver https://github.com/elFarto/nvidia-vaapi-driver\n\nPipewire Config:\nNoticeable audio delay when starting playback. This is caused by node suspension when inactive. It can be disabled by editing /etc/pipewire/media-session.d/*-monitor.conf depending on where the delay occurs and changing property session.suspend-timeout-seconds to 0 to disable or to experiment with other values and see what works. Alternatively you can comment out the line suspend-node in /etc/pipewire/media-session.d/media-session.conf. Restart both the pipewire and pipewire-pulse systemd services to apply these changes, or alternatively reboot." >> ToDoList.txt

echo "All done! Please reboot the computer."
