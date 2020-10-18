 #!/bin/bash
echo "#################################"
echo "Start arcolinux-final.sh"
echo "#################################"

echo "Permissions of important folders"
echo "#################################"
chmod 750 /etc/sudoers.d
chmod 750 /etc/polkit-1/rules.d
chgrp polkitd /etc/polkit-1/rules.d
chmod 600 /etc/gshadow
chmod 600 /etc/shadow

echo "Copy /etc/skel to /root"
echo "#################################"
cp -aT /etc/skel/ /root/

echo "Cleanup autologin root"
echo "#################################"
rm -rf /etc/systemd/system/getty@tty1.service.d

echo "Fix for pamac icons not showing"
echo "#################################"
zcat /usr/share/app-info/xmls/community.xml.gz | sed 's|<em>||g;s|<\/em>||g;' | gzip > "new.xml.gz"
mv new.xml.gz /usr/share/app-info/xmls/community.xml.gz
appstreamcli refresh-cache --force

echo "Setting editor to nano"
echo "#################################"
echo "EDITOR=nano" >> /etc/profile

echo "Bluetooth improvements"
echo "#################################"
sed -i "s/#AutoEnable=false/AutoEnable=true/g" /etc/bluetooth/main.conf
echo 'load-module module-switch-on-connect' | sudo tee --append /etc/pulse/default.pa

#Original cleanup
echo "Cleanup original files"
echo "#################################"
rm -f /etc/sudoers.d/g_wheel
rm -rf /usr/share/backgrounds/xfce
rm -f /etc/polkit-1/rules.d/49-nopasswd_global.rules
rm -r /etc/systemd/system/etc-pacman.d-gnupg.mount
rm /root/{.automated_script.sh,.zlogin}
mv /etc/arcolinux-release /etc/lsb-release
mv /etc/mkinitcpio.d/arcolinux /etc/mkinitcpio.d/linux.preset

echo "Permission of root"
echo "#################################"
chmod -v 750 /root

echo "#################################"
echo "End arcolinux-final.sh"
echo "#################################"
rm /usr/local/bin/arcolinux-all-cores.sh
rm /usr/local/bin/arcolinux-final.sh
