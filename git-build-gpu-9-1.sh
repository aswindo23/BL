#!/bin/bash


yum -y update
yum -y groupinstall "GNOME Desktop" "Development Tools"
yum -y install kernel-devel
yum -y install epel-release
yum -y install dkms
yum -y update

echo " GRUB_CMDLINE_LINUX=\"crashkernel=auto rhgb quiet rd.driver.blacklist=nouveau nouveau.modeset=0 \" >> /etc/default/grub
grub2-mkconfig -o /boot/grub2/grub.cfg
touch /etc/modprobe.d/blacklist.conf
echo "blacklist nouveau" >> /etc/modprobe.d/blacklist.conf
mv /boot/initramfs-$(uname -r).img /boot/initramfs-$(uname -r)-nouveau.img
dracut /boot/initramfs-$(uname -r).img $(uname -r)
systemctl isolate multi-user.target
wget http://us.download.nvidia.com/XFree86/Linux-x86_64/390.42/NVIDIA-Linux-x86_64-390.42.run
sh NVIDIA*.run
wget https://developer.nvidia.com/compute/cuda/9.1/Prod/local_installers/cuda-repo-rhel7-9-1-local-9.1.85-1.x86_64
sudo rpm -i cuda-repo-rhel7-9-1-local-9.1.85-1.x86_64
yum install cuda
PATH=$PATH:/usr/local/cuda/bin
export PATH
echo "PATH=/usr/local/cuda/bin:\$PATH" >> /etc/profile
echo "LD_LIBRARY_PATH=/usr/local/cuda/lib64:\$LD_LIBRARY_PATH" >> /etc/profile
source /etc/profile
