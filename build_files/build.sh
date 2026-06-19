#!/bin/bash

set -ouex pipefail

# Copy the contents of system_files/ of the git repo to /
cp -avf "/ctx/system_files"/. /

### Install packages

# Packages can be installed from any enabled yum repo on the image.
# RPMfusion repos are available by default in ublue main images
# List of rpmfusion packages can be found here:
# https://mirrors.rpmfusion.org/mirrorlist?path=free/fedora/updates/43/x86_64/repoview/index.html&protocol=https&redirect=1

# this installs a package from fedora repos
dnf5 install -y tmux

# Use a COPR Example:
#
# dnf5 -y copr enable ublue-os/staging
# dnf5 -y install package
# Disable COPRs so they don't end up enabled on the final image:
# dnf5 -y copr disable ublue-os/staging

#### Example for enabling a System Unit File

systemctl enable podman.socket


echo "=== KinkOS NSFW Customizations Starting ==="

# Install themes + useful packages
rpm-ostree install -y \
    gnome-tweaks \
    adw-gtk3-theme \
    papirus-icon-theme \
    materia-gtk-theme \
    vlc \
    mpv \
    distrobox || true

# Enable Flathub + pre-install media/browser
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo || true
flatpak install -y --system flathub \
    org.mozilla.firefox \
    org.videolan.VLC || true

# Create folder for your kinky wallpapers
mkdir -p /usr/share/backgrounds/kinkos

echo "=== KinkOS NSFW Customizations Complete ==="

cp -r /build_files/system_files/* / 2>/dev/null || true

# Set the default dark kinky wallpaper (GNOME)
if [ -f /usr/share/backgrounds/kinkos/main.jpg ]; then
    gsettings set org.gnome.desktop.background picture-uri-dark "file:///usr/share/backgrounds/kinkos/main.jpg" || true
fi
