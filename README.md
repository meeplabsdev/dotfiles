# Dotfiles

The following are the dotfiles currently in use for my daily-driver arch-windows dual-boot workstation, managed using [`chezmoi`](https://www.chezmoi.io).

# Install

**Installation instructions for when I inevitably break something and come looking.**

 1. Acquire an [Arch ISO](https://archlinux.org/download/) and verify it with the PGP signature, then boot into it.

 2. Set the console keyboard layout and font with the following commands:
 `loadkeys uk`
 `setfont ter-114b`
 
 3. Connect to the internet, using the `iwctl` command. Once inside the prompt, proceed using the following:
- `device list` to identify your device, eg wlan0.
- `station <DEVICE> scan` and `station <DEVICE> get-networks` to list the available networks.
- `station <DEVICE> connect <SSID>`, and an optional `--passphrase=<PASSPHRASE>` (or be prompted) to connect to a network. An active connection can be confirmed with `ping archlinux.org`.

4. Update the system clock with `timedatectl`.

5. Use `fdisk -l` to identify the disk you wish to install on, and then run `fdisk /dev/<DISK>` (eg `fdisk /dev/sdb`).
- To begin, create an 8GB SWAP partition on `/dev/sdb1`:
	- Type 'n' to create a new partition
	- Choose primary partition (p)
	- Select partition number (1)
	- Accept the default first sector
	- For the last sector, type '+8G' for 8GB
	- Type 't' to change partition type
	- Enter '82' for Linux SWAP
- Next, assign the rest as btrfs:
	- Type 'n' to create a new partition
	- Choose primary partition (p)
	- Select partition number (2)
	- Accept the default first sector
	- Accept the default last sector (remaining space)
- Type 'w' to write changes and exit.
- Format the swap partition with `mkswap /dev/sdb1`.
- Format the btrfs partition with `mkfs.btrfs /dev/sdb2` and mount it with `mount /dev/sdb2 /mnt`.
- Enable the SWAP with `swapon /dev/sdb1`.

6. Edit the mirrors that will be used to install with `nano /etc/pacman.d/mirrorlist` if needed.

7. Begin the installation with `pacstrap -K /mnt base base-devel linux linux-firmware linux-headers linux-zen linux-zen-headers os-prober grub networkmanager nano btrfs-prog git ntfs-3g`.

8. Generate an FSTAB file with `genfstab -U /mnt >> /mnt/etc/fstab`.

9. Change root into the new system: `arch-chroot /mnt`.
 
10. Change the time zone with `ln -sf /usr/share/zoneinfo/Europe/London /etc/localtime`, and sync the system clock with `hwclock --systohc`.

11. Edit `/etc/locale.gen` and set the locale within (eg `en_GB.UTF-8`).

12. Set the LANG variable within `/etc/locale.conf` (eg `LANG=en_GB.UTF-8`).

13. Set the KEYMAP variable within `/etc/vconsole.conf` (eg `KEYMAP=gb`).

14. Set the hostname within `/etc/hostname` (eg `six`).

15. Set a root password with the `passwd` command.

16. Install GRUB as follows:
- `grub-install --target=i386-pc /dev/sdb` to install GRUB to the partition.
- `sudo mount /dev/sda1 /mnt` assuming windows is installed on sda1 (this mounts to the `/mnt` in the `arch-chroot`, not the host `/mnt` (its `/mnt` inception).
- `grub-mkconfig -o /boot/grub/grub.cfg` to generate the GRUB config.
- Assuming `os-prober` is installed (it is if following the commands here), windows should be automatically detected and added to the GRUB config.

17. `exit` the `arch-chroot`, and `umount -R /mnt` the drives. Now run `reboot` and you should boot into GRUB, where you can select Arch Linux to continue.

### Installation within Arch Linux

Now that the base Arch Linux is installed, we can begin to customize it. Currently it will work perfectly fine, but it is only a TTY, there is no DE installed, and only a `root` user. In the following section, I will detail how to install these dotfiles (which also sets up a `six` user).

You will need to have `git`, `github-cli` and `chezmoi` installed to begin. They can be installed with the command `sudo pacman -S git gihub-cli chezmoi`.

Next, log into the `github-cli` with `gh auth login`, and follow the prompts. Once logged in you can run the following command to download and execute the installation script:

`/bin/bash -c "$(curl -fsSL https://github.com/meeplabsdev/dotfiles/raw/refs/heads/main/executable_install.sh)"`

The script will ask you to set a password for the new `six` account, and will set up the account before rebooting. When you reach the login screen again, this time log in with the username `six` and the password that you just set. At this TTY, you must run the `chezmoi init meeplabsdev` command, which will `git clone` the dotfiles into the correct places and finish up the installation. **This will probably take a long time.**

And that's everything! The only step that you may want to take is to `sudo pacman -Rs nvidia-utils nvidia-dkms` and then `sudo downgrade nvidia-utils nvidia-dkms` to select a version that does not suffer from the `EGL_BAD_PARAMETER` bugs, such as `560.35.03-6` and possibly `sudo downgrade linux linux-zen linux-headers linux-zen-headers` to `6.10.10arch1-1` and `6.10.10` for the headers.

<details>
<summary><h1> Versions</h1></summary>

The output of `pacman -Q` at the time of writing is as follows:
```
abseil-cpp 20240722.1-1
acl 2.3.2-1
adobe-source-code-pro-fonts 2.042u+1.062i+1.026vf-2
adwaita-cursors 47.0-1
adwaita-icon-theme 47.0-1
adwaita-icon-theme-legacy 46.2-3
alacritty 0.15.1-1
alsa-card-profiles 1:1.2.7-1
alsa-lib 1.2.13-1
alsa-topology-conf 1.2.5.1-4
alsa-ucm-conf 1.2.13-2
aom 3.12.0-1
aquamarine-git-debug 0.7.2_r268.gf239e5a-1
archlinux-keyring 20250123-1
at-spi2-core 2.54.1-1
atkmm 2.28.4-1
attr 2.5.2-1
audit 4.0.3-1
autoconf 2.72-1
automake 1.17-1
avahi 1:0.8+r194+g3f79789-3
base 3-2
base-devel 1-2
bash 5.2.037-1
binutils 2.44-1
bison 3.8.2-8
bluez-libs 5.79-1
brotli 1.1.0-3
btrfs-progs 6.13-1
bzip2 1.0.8-6
c-ares 1.34.4-1
ca-certificates 20240618-1
ca-certificates-mozilla 3.108-1
ca-certificates-utils 20240618-1
cairo 1.18.2-2
cairomm 1.14.5-1
cantarell-fonts 1:0.303.1-2
cfitsio 1:4.5.0-1
chezmoi 2.59.1-1
clipman 1.6.4-1
clipman-debug 1.6.4-1
cmake 3.31.5-1
code 1.97.2-1
cohesion-git r196.g26a1e96-1
cohesion-git-debug r196.g26a1e96-1
coppwr-bin 1.6.1-1
coppwr-bin-debug 1.6.1-1
coreutils 9.6-2
cppdap 1.58.0-2
cryptsetup 2.7.5-2
curl 8.12.1-1
dav1d 1.5.1-1
db5.3 5.3.28-5
dbus 1.16.0-1
dbus-broker 36-4
dbus-broker-units 36-4
dbus-units 36-4
dconf 0.40.0-3
debugedit 5.1-1
default-cursors 3-1
desktop-file-utils 0.28-1
device-mapper 2.03.30-1
diffutils 3.10-1
dkms 3.1.5-1
double-conversion 3.3.1-1
doublecmd-qt6 1.1.22-3
downgrade 11.4.3-1
duktape 2.7.0-7
e2fsprogs 1.47.2-1
egl-gbm 1.1.2-1
egl-wayland 4:1.1.17-1
eglexternalplatform 1.2-2
electron 1:34-1
electron32 32.3.1-1
electron34 34.2.0-1
expat 2.6.4-1
fakeroot 1.37-1
ffmpeg 2:7.1-6
fftw 3.3.10-7
file 5.46-3
filesystem 2024.11.21-1
findutils 4.10.0-2
firefox 135.0-1
flac 1.4.3-2
flex 2.6.4-5
fmt 11.1.3-1
fontconfig 2:2.16.0-2
freetype2 2.13.3-3
fribidi 1.0.16-1
fuse-common 3.16.2-1
fuse2 2.9.9-5
fuse3 3.16.2-1
fzf 0.59.0-1
gawk 5.3.1-1
gc 8.2.8-2
gcc 14.2.1+r753+g1cd744a6828f-1
gcc-libs 14.2.1+r753+g1cd744a6828f-1
gdbm 1.24-1
gdk-pixbuf2 2.42.12-2
gettext 0.23.1-2
giflib 5.2.2-1
git 2.48.1-2
github-cli 2.67.0-1
glaze 4.4.2-1
glib-networking 1:2.80.1-1
glib2 2.82.4-2
glibc 2.41+r6+gcf88351b685d-1
glibmm 2.66.7-1
glslang 15.1.0-1
gmp 6.3.0-2
gnulib-l10n 20241231-1
gnupg 2.4.7-1
gnutls 3.8.9-1
go 2:1.24.0-1
gobject-introspection 1.82.0-3
gobject-introspection-runtime 1.82.0-3
gperftools 2.16-1
gpgme 1.24.2-1
gpm 1.20.7.r38.ge82d1a6-6
granite 1:6.2.0-1
graphene 1.10.8-2
graphite 1:1.3.14-4
grep 3.11-1
grim 1.4.1-2
groff 1.23.0-7
grub 2:2.12-3
gsettings-desktop-schemas 47.1-1
gsettings-system-schemas 47.1-1
gsm 1.0.22-2
gssdp 1.6.3-2
gst-plugins-bad-libs 1.24.12-1
gst-plugins-base-libs 1.24.12-1
gstreamer 1.24.12-1
gtest 1.15.2-1
gtk-layer-shell 0.9.0-1
gtk-update-icon-cache 1:4.16.12-1
gtk2 2.24.33-5
gtk3 1:3.24.48-2
gtk4 1:4.16.12-1
gtk4-layer-shell 1.1.0-1
gtkmm3 3.24.9-1
guile 3.0.10-1
gupnp 1:1.6.8-1
gupnp-igd 1.6.0-1
gzip 1.13-4
harfbuzz 10.2.0-1
hicolor-icon-theme 0.18-1
hidapi 0.14.0-3
highway 1.2.0-1
hwdata 0.392-1
hyprpicker 0.4.2-3
hyprutils 0.5.0-1
hyprwayland-scanner 0.4.4-1
iana-etc 20241206-1
icu 75.1-2
illogical-impulse-bibata-modern-classic-bin 2.0.6-1
imagemagick 7.1.1.43-1
imath 3.1.12-3
intltool 0.51.0-6
iproute2 6.13.0-1
iptables 1:1.8.10-2
iputils 20240905-1
iso-codes 4.17.0-1
jansson 2.14-4
jbigkit 2.1-8
jq 1.7.1-2
json-c 0.18-1
json-glib 1.10.6-1
jsoncpp 1.9.6-3
kbd 2.7.1-1
keyutils 1.6.3-3
kmod 33-3
krb5 1.21.3-1
l-smash 2.14.5-4
lame 3.100-5
lcms2 2.17-1
leancrypto 1.2.0-2
libarchive 3.7.7-1
libass 0.17.3-1
libassuan 3.0.0-1
libasyncns 1:0.8+r3+g68cd5af-3
libavc1394 0.5.4-6
libb2 0.98.1-3
libbluray 1.3.4-2
libbpf 1.5.0-1
libbs2b 3.1.0-9
libbsd 0.12.2-2
libcap 2.71-1
libcap-ng 0.8.5-3
libcdio 2.2.0-1
libcdio-paranoia 10.2+2.0.2-1
libcgif 0.5.0-1
libcloudproviders 0.3.6-1
libcolord 1.4.7-2
libcups 2:2.4.11-2
libdaemon 0.14-6
libdatrie 0.2.13-4
libdbusmenu-glib 16.04.0.r498-2
libdbusmenu-gtk3 16.04.0.r498-2
libdecor 0.2.2-1
libdeflate 1.23-1
libdisplay-info 0.2.0-2
libdovi 3.3.1-1
libdrm 2.4.124-1
libdvdnav 6.1.1-2
libdvdread 6.1.3-2
libedit 20240808_3.1-1
libei 1.3.0-1
libelf 0.192-4
libepoxy 1.5.10-3
libevdev 1.13.3-1
libevent 2.1.12-4
libexif 0.6.25-1
libfdk-aac 2.0.3-1
libffi 3.4.6-1
libfontenc 1.1.8-1
libfreeaptx 0.1.1-2
libgcrypt 1.11.0-2
libgee 0.20.8-1
libgirepository 1.82.0-3
libglvnd 1.7.0-1
libgpg-error 1.51-1
libgudev 238-1
libhandy 1.8.3-2
libice 1.1.2-1
libidn2 2.3.7-1
libiec61883 1.2.0-8
libimagequant 4.3.3-1
libimobiledevice 1.3.0-15
libimobiledevice-glue 1.3.1-1
libinih 58-1
libinput 1.27.1-1
libisl 0.27-1
libjpeg-turbo 3.1.0-1
libjxl 0.11.1-1
libksba 1.6.7-1
liblc3 1.1.3-1
libldac 2.0.2.3-2
libldap 2.6.9-1
libliftoff 0.5.0-1
liblqr 0.4.3-1
libmd 1.1.0-2
libmm-glib 1.22.0-1
libmnl 1.0.5-2
libmodplug 0.8.9.0-6
libmpc 1.3.1-2
libmpdclient 2.22-1
libmysofa 1.3.3-1
libndp 1.9-1
libnetfilter_conntrack 1.0.9-2
libnewt 0.52.24-3
libnfnetlink 1.0.2-2
libnftnl 1.2.8-1
libnghttp2 1.64.0-1
libnghttp3 1.7.0-1
libngtcp2 1.10.0-1
libnice 0.1.22-1
libnl 3.11.0-1
libnm 1.50.2-1
libnotify 0.8.3-1
libnsl 2.0.1-1
libogg 1.3.5-2
libopenmpt 0.7.13-1
libp11-kit 0.25.5-1
libpcap 1.10.5-2
libpciaccess 0.18.1-2
libpgm 5.3.128-3
libpipewire 1:1.2.7-1
libplacebo 7.349.0-4
libplist 2.6.0-2
libpng 1.6.46-1
libproxy 0.5.9-1
libpsl 0.21.5-2
libpulse 17.0+r43+g3e2bb8a1e-1
libraqm 0.10.2-1
libraw1394 2.1.2-4
librsvg 2:2.59.2-1
libsamplerate 0.2.2-3
libsasl 2.1.28-5
libsass 3.6.6-1
libseccomp 2.5.5-4
libsecret 0.21.6-1
libsigc++ 2.12.1-1
libsixel 1.10.3-7
libsm 1.2.5-1
libsndfile 1.2.2-2
libsodium 1.0.20-1
libsoup3 3.6.4-1
libsoxr 0.1.3-4
libssh 0.11.1-1
libssh2 1.11.1-1
libstemmer 2.2.0-2
libsysprof-capture 47.2-3
libtasn1 4.20.0-1
libteam 1.32-2
libthai 0.1.29-3
libtheora 1.1.1-6
libtiff 4.7.0-1
libtirpc 1.3.6-1
libtool 2.5.4+r1+gbaa1fe41-3
libunibreak 6.1-1
libunistring 1.3-1
libunwind 1.8.1-3
libusb 1.0.27-1
libusbmuxd 2.1.0-1
libuv 1.50.0-1
libva 2.22.0-1
libva-nvidia-driver 0.0.13-1
libvdpau 1.5-3
libverto 0.3.2-5
libvips 8.16.0-2
libvorbis 1.3.7-4
libvpl 2.14.0-1
libvpx 1.15.0-1
libwacom 2.14.0-1
libwebp 1.5.0-1
libwireplumber 0.5.8-1
libx11 1.8.11-1
libxau 1.0.12-1
libxcb 1.17.0-1
libxcomposite 0.4.6-2
libxcrypt 4.4.38-1
libxcrypt-compat 4.4.38-1
libxcursor 1.2.3-1
libxcvt 0.1.3-1
libxdamage 1.1.6-2
libxdmcp 1.1.5-1
libxext 1.3.6-1
libxfixes 6.0.1-2
libxfont2 2.0.7-1
libxft 2.3.8-2
libxi 1.8.2-1
libxinerama 1.1.5-2
libxkbcommon 1.8.0-1
libxkbcommon-x11 1.8.0-1
libxkbfile 1.1.3-1
libxml2 2.13.5-2
libxmu 1.2.1-1
libxpresent 1.0.1-2
libxrandr 1.5.4-1
libxrender 0.9.12-1
libxshmfence 1.3.3-1
libxslt 1.1.42-2
libxss 1.2.4-2
libxt 1.3.1-1
libxtst 1.2.5-1
libxv 1.0.13-1
libxxf86vm 1.1.6-1
licenses 20240728-1
lilv 0.24.26-1
linux 6.10.10.arch1-1
linux-api-headers 6.10-1
linux-firmware 20250210.5bc5868b-1
linux-firmware-whence 20250210.5bc5868b-1
linux-headers 6.10.10.arch1-1
linux-zen 6.10.10.zen1-1
linux-zen-headers 6.10.10.zen1-1
llvm 19.1.7-1
llvm-libs 19.1.7-1
llvm18 18.1.8-1
llvm18-libs 18.1.8-1
lm_sensors 1:3.6.0.r41.g31d1f125-3
lmdb 0.9.33-1
lua 5.4.7-1
luajit 2.1.1736781742-1
lv2 1.18.10-1
lxappearance 0.6.3-5
lz4 1:1.10.0-2
lzo 2.10-5
m4 1.4.19-3
mailcap 2.1.54-2
make 4.4.1-2
materia-gtk-theme 20210322-3
md4c 0.5.2-1
mesa 1:24.3.4-1
meson 1.7.0-1
minizip 1:1.3.1-2
mkinitcpio 39.2-3
mkinitcpio-busybox 1.36.1-1
mobile-broadband-provider-info 20240407-1
mpdecimal 4.0.0-2
mpfr 4.2.1-6
mpg123 1.32.10-1
mpv 1:0.39.0-4
mtdev 1.1.7-1
mujs 1.3.6-1
nano 8.3-1
ncurses 6.5-3
nerd-fonts-git 1:3.3.0.r66.g92901a4db-1
nettle 3.10.1-1
networkmanager 1.50.2-1
ninja 1.12.1-2
node-gyp 11.1.0-3
nodejs 23.8.0-1
nodejs-nopt 7.2.1-1
notion-calendar-electron 1.0.4-1
notion-calendar-electron-debug 1.0.4-1
noto-fonts 1:2025.02.01-1
npm 11.1.0-2
npth 1.8-1
nspr 4.36-1
nss 3.108-1
ntfs-3g 2022.10.3-1
nvidia-dkms 560.35.03-6
nvidia-utils 560.35.03-6
nvm 0.40.1-1
nwg-look 1.0.2-1
ocl-icd 2.3.2-2
oniguruma 6.9.10-1
openal 1.24.2-1
opencore-amr 0.1.6-2
openexr 3.3.2-1
openjpeg2 2.5.3-1
openssh 9.9p2-1
openssl 3.4.1-1
opus 1.5.2-1
orc 0.4.41-1
os-prober 1.81-2
otf-font-awesome 6.7.2-1
p11-kit 0.25.5-1
pacman 7.0.0.r6.gc685ae6-1
pacman-contrib 1.11.0-1
pacman-mirrorlist 20250101-1
pahole 1:1.29-1
pam 1.7.0-2
pambase 20230918-2
pango 1:1.56.1-1
pangomm 2.46.4-1
patch 2.7.6-10
pciutils 3.13.0-2
pcre 8.45-4
pcre2 10.44-1
pcsclite 2.3.1-1
perl 5.40.1-2
perl-clone 0.47-1
perl-encode-locale 1.05-13
perl-error 0.17029-7
perl-file-listing 6.16-4
perl-html-parser 3.83-1
perl-html-tagset 3.24-2
perl-http-cookiejar 0.014-3
perl-http-cookies 6.11-2
perl-http-daemon 6.16-4
perl-http-date 6.06-3
perl-http-message 7.00-1
perl-http-negotiate 6.01-14
perl-io-html 1.004-6
perl-libwww 6.77-2
perl-lwp-mediatypes 6.04-6
perl-mailtools 2.22-1
perl-net-http 6.23-4
perl-timedate 2.33-7
perl-try-tiny 0.32-2
perl-uri 5.31-1
perl-www-robotrules 6.02-14
perl-xml-parser 2.47-2
pfetch-rs-bin 2.11.1-1
pfetch-rs-bin-debug 2.11.1-1
pinentry 1.3.1-5
pipewire 1:1.2.7-1
pipewire-audio 1:1.2.7-1
pipewire-jack 1:1.2.7-1
pipewire-pulse 1:1.2.7-1
pixman 0.44.2-1
pkgconf 2.3.0-1
playerctl 2.4.1-4
polkit 126-2
popt 1.19-2
portaudio 1:19.7.0-3
procps-ng 4.0.5-2
psmisc 23.7-1
pugixml 1.15-1
pulse-native-provider 1:1.2.7-1
python 3.13.2-1
python-autocommand 2.2.2-7
python-dbus 1.3.2-5
python-distutils-extra 2.39-14
python-jaraco.collections 5.1.0-1
python-jaraco.context 6.0.1-1
python-jaraco.functools 4.1.0-1
python-jaraco.text 4.0.0-2
python-mako 1.3.9-1
python-markdown 3.7-2
python-markupsafe 2.1.5-3
python-more-itertools 10.5.0-1
python-packaging 24.2-3
python-platformdirs 4.3.6-2
python-pywal 3.3.0-10
python-pywalfox 2.7.4-1
python-pyxdg 0.28-4
python-setuptools 1:75.8.0-1
python-tqdm 4.67.1-2
python-wheel 0.45.0-3
qogir-icon-theme 2023.06.05-1
qt5-base 5.15.16+kde+r130-3
qt5-declarative 5.15.16+kde+r22-3
qt5-svg 5.15.16+kde+r5-3
qt5-translations 5.15.16-3
qt5-wayland 5.15.16+kde+r59-3
qt5ct 1.9-1
qt6-base 6.8.2-2
qt6-declarative 6.8.2-1
qt6-svg 6.8.2-1
qt6-translations 6.8.2-1
qt6-wayland 6.8.2-1
qt6ct 0.9-13
qt6pas 6.2.7-2
rav1e 0.7.1-1
readline 8.2.013-1
rhash 1.4.4-1
ripgrep 14.1.1-1
rtkit 0.13-3
rubberband 4.0.0-1
rustup 1.27.1-1
sassc 3.6.2-5
sbc 2.0-2
scdoc 1.11.3-1
scenefx-git r269.87c0e8b-2
scenefx-git-debug r269.87c0e8b-2
sdl2-compat 2.32.50-1
sdl3 3.2.4-1
seatd 0.9.1-1
sed 4.9-3
semver 7.7.1-1
serd 0.32.4-1
shaderc 2024.4-1
shadow 4.16.0-1
shared-mime-info 2.4-1
slang 2.3.3-3
slurp 1.5.0-1
snappy 1.2.1-2
sndio 1.10.0-1
sord 0.16.18-1
spdlog 1.15.1-1
speex 1.2.1-2
speexdsp 1.2.1-2
spirv-tools 2024.4.rc2-1
sqlite 3.49.0-1
sratom 0.6.18-1
srt 1.5.4-1
sudo 1.9.16.p2-2
svt-av1 2.3.0-1
sway-screenshot 1.0.0-1
swaybg 1.2.1-1
swayfx-git r7070.50d4cf45-1
swayfx-git-debug r7070.50d4cf45-1
swayfx-nvidia 1.0.8-1
swayidle-git 1.8.0.r13.gf13cefa-1
swayidle-git-debug 1.8.0.r13.gf13cefa-1
swaylock-git 1.8.0.r5.ga439abb-1
swaylock-git-debug 1.8.0.r5.ga439abb-1
swaymgr 0.1.1-1
swaymgr-debug 0.1.1-1
swaync 0.10.1-3
swayosd-git 0.1.0.r9.g993180b-1
swayosd-git-debug 0.1.0.r9.g993180b-1
systemd 257.3-1
systemd-libs 257.3-1
systemd-sysvcompat 257.3-1
tar 1.35-2
texinfo 7.2-1
tinysparql 3.8.2-2
tpm2-tss 4.1.3-1
tslib 1.23-1
tzdata 2025a-1
uchardet 0.0.8-3
unzip 6.0-22
upower 1.90.7-1
util-linux 2.40.4-1
util-linux-libs 2.40.4-1
uwsm 0.21.0-1
v4l-utils 1.28.1-2
vapoursynth R70-2
vid.stab 1.1.1-2
vmaf 3.0.0-1
vscodium-bin-debug 1.97.2.25045-1
vulkan-headers 1:1.4.303-1
vulkan-icd-loader 1.4.303-1
vulkan-validation-layers 1.3.296.0-1
walker 0.12.16-1
walker-debug 0.12.16-1
waybar 0.11.0-6
wayland 1.23.1-1
wayland-protocols 1.41-1
wdisplays-git 1.1.r15.g6233901-1
wdisplays-git-debug 1.1.r15.g6233901-1
webrtc-audio-processing-1 1.3-4
which 2.21-6
wireplumber 0.5.8-1
wl-clipboard 1:2.2.1-2
wlogout 1.2.2-0
wlogout-debug 1.2.2-0
wlroots 0.18.2-1
wlroots0.17-debug 0.17.4-1
wpa_supplicant 2:2.11-3
x264 3:0.164.r3108.31e19f9-2
x265 4.0-1
xcb-proto 1.17.0-3
xcb-util 0.4.1-2
xcb-util-cursor 0.1.5-1
xcb-util-errors 1.0.1-2
xcb-util-image 0.4.1-3
xcb-util-keysyms 0.4.1-5
xcb-util-renderutil 0.3.10-2
xcb-util-wm 0.4.2-2
xcur2png 0.7.1-8
xdg-desktop-portal 1.18.4-2
xdg-desktop-portal-wlr 0.7.1-1
xdg-utils 1.2.1-1
xf86-input-libinput 1.5.0-1
xkeyboard-config 2.44-1
xorg-bdftopcf 1.1.2-1
xorg-font-util 1.4.1-2
xorg-fonts-encodings 1.1.0-1
xorg-mkfontscale 1.2.3-1
xorg-server 21.1.15-1
xorg-server-common 21.1.15-1
xorg-setxkbmap 1.3.4-2
xorg-xkbcomp 1.4.7-1
xorg-xprop 1.2.8-1
xorg-xset 1.2.5-2
xorg-xwayland 24.1.5-1
xorgproto 2024.1-2
xvidcore 1.3.7-3
xxhash 0.8.3-1
xz 5.6.4-1
yay 12.4.2-1
yay-debug 12.4.2-1
zeromq 4.3.5-2
zimg 3.0.5-1
zix 0.6.2-1
zlib 1:1.3.1-2
zsh 5.9-5
zstd 1.5.6-1
```

</details>

