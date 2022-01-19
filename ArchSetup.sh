#!/bin/bash

# INSTALL SCRIPT FOR Arch

cd $HOME

# System Update
yes | sudo pacman -Syu

# Enable Trim
sudo systemctl enable fstrim.timer
sudo systemctl start fstrim.timer

# Enable Multilib Repo
sudo echo '[multilib]' >> /etc/pacman.conf
sudo echo 'Include = /etc/pacman.d/mirrorlist' >> /etc/pacman.conf

# Install Dependencies
yes | sudo pacman -S lib32-gnutls lib32-libldap lib32-libgpg-error lib32-libxml2 lib32-alsa-plugins lib32-sdl2 lib32-freetype2 lib32-dbus lib32-libgcrypt libgcrypt gst-plugins-bad ffnvcodec-headers gtk-engine-murrine nvidia-dkms

# Install Fonts
sudo pacman -S adobe-source-han-sans-jp-fonts otf-ipafont adobe-source-han-serif-jp-fonts ttf-hanazono ttf-sazanami
paru -S ttf-koruri ttf-monapo ttf-mplus ttf-vlgothic all-repository-fonts

# Install Apps
sudo pacman -S vivaldi htop nvtop dolphin-emu mgba-qt micro zoxide gamemode mpv piper qbittorrent kitty duf exa rofi neofetch steam nfs-utils flameshot wine caprine wget zip unzip lutris git kvantum

# AUR Setup
sudo pacman -S base-devel --needed

# AUR Installs
paru -S bottles heroic-games-launcher-bin sameboy android-messages-desktop cemu spicetify-cli spicetify-themes-git ttf-ms-fonts balena-etcher

# Install Flatpak
sudo pacman -S flatpak

# Flatpak Installs
sudo flatpak install flathub net.rpcs3.RPCS3 com.discordapp.Discord org.citra_emu.citra org.yuzu_emu.yuzu org.flycast.Flycast io.github.m64p.m64p com.github.PintaProject.Pinta net.davidotek.pupgui2 com.spotify.Client -y

# Flatpak/GTK Theme
git clone https://github.com/vinceliuice/Fluent-gtk-theme
cd Fluent-gtk-theme
sh install.sh
cd $HOME
sudo flatpak override --filesystem=$HOME/.themes
sudo flatpak override --env=GTK_THEME=Fluent-dark-compact

# Copy kitty conf
git clone https://github.com/Posty2k3/Backup
mkrdir -p $HOME/.config/kitty
cp -f $HOME/Backup/kitty.conf $HOME/.config/kitty/

# Rofi Theme
git clone https://github.com/undiabler/nord-rofi-theme
sudo mkdir -p /usr/share/rofi/themes
sudo cp $HOME/nord-rofi-theme/nord.rasi /usr/share/rofi/themes/
rm -rf $HOME/nord-rofi-theme

# Rofi Script
sudo echo '#!/bin/bash' >> /usr/local/bin/rofi-run
sudo echo 'export LC_ALL="C"' >> /usr/local/bin/rofi-run
sudo echo 'rofi -show run 2>&1 | tee /tmp/rofi-run.log' >> /usr/local/bin/rofi-run
sudo echo 'exit 0' >> /usr/local/bin/rofi-run
sudo chmod +x /usr/local/bin/rofi-run

# WINE Theme / **Add to Github**
#wget https://gist.github.com/Zeinok/ceaf6ff204792dde0ae31e0199d89398/raw/a5f0d3efb309d6d0728e1e54579e5c1081cf0d22/wine-breeze-dark.reg
#wget https://gist.github.com/Zeinok/ceaf6ff204792dde0ae31e0199d89398/raw/a5f0d3efb309d6d0728e1e54579e5c1081cf0d22/wine-reset-theme.reg
wine regedit $HOME/Backup/wine-breeze-dark.reg

# KDE Themes
git clone https://github.com/vinceliuice/Orchis-kde
cd Orchis-kde
sh install.sh
cd $HOME
git clone https://github.com/vinceliuice/Fluent-kde
cd Fluent-kde
sh install.sh
cd $HOME

# Mount NAS
sudo mkdir /mnt/WDMyCloud
sudo echo '192.168.1.39:/mnt/HD/HD_a2/Media   /mnt/WDMyCloud   nfs   defaults,timeo=900,retrans=5,_netdev	0 0' >> /etc/fstab

# Mount NTFS
sudo mkdir /mnt/Intel-660p
sudo mkdir /mnt/Samsung-970
sudo mkdir /mnt/Samsung-850
sudo echo 'UUID=AC84DACF84DA9AE2	/mnt/Intel-660p		ntfs3	defaults	0	2' >> /etc/fstab
sudo echo 'UUID=608EB80B8EB7D7AC	/mnt/Samsung-970	ntfs3	defaults	0	2' >> /etc/fstab
sudo echo 'UUID=369CDC6A9CDC2661	/mnt/Samsung-850	ntfs3	defaults	0	2' >> /etc/fstab

# Install Pipewire
sudo pacman -Rdd pulseaudio
sudo pacman -S pipewire pipwire-pulse pipewire-media-session pipewire-jack pipewire-alsa

# Update
paru -S zsh-theme-powerlevel10k-git
cp $HOME/Backup/zshrc $HOME/.zshrc


# Download Windows Programs
wget https://download.dm.origin.com/origin/live/OriginSetup.exe
wget https://github.com/bsnes-emu/bsnes/releases/download/v115/bsnes_v115-windows.zip
mkdir -p $HOME/Games
unzip bsnes_v115-windows.zip -d $HOME/Games/
rm bsnes_v115-windows.zip

# Download & Install nvidia-vaapi-driver
git clone https://github.com/elFarto/nvidia-vaapi-driver

# Change Default Shell to ZSH
chsh -s /usr/bin/zsh

# Provide Todo List
echo -e "Setup Spicetify: https://spicetify.app/docs/getting-started/installation\n\nNVIDIA Kernel Parameter:\nEdit /etc/default/grub\nAdd kernel option to the line GRUB_CMDLINE_LINUX\nGRUB_CMDLINE_LINUX="nvidia-drm.modeset=1"\nRegenerate /boot/grub/grub.cfg:\ngrub-mkconfig -o /boot/grub/grub.cfg\n\nSetup nvidia-vaapi-driver https://github.com/elFarto/nvidia-vaapi-driver\n\nPipewire Config:\nNoticeable audio delay when starting playback. This is caused by node suspension when inactive. It can be disabled by editing /etc/pipewire/media-session.d/*-monitor.conf depending on where the delay occurs and changing property session.suspend-timeout-seconds to 0 to disable or to experiment with other values and see what works. Alternatively you can comment out the line suspend-node in /etc/pipewire/media-session.d/media-session.conf. Restart both the pipewire and pipewire-pulse systemd services to apply these changes, or alternatively reboot." >> ToDoList.txt

echo "All done! Please reboot the computer."
