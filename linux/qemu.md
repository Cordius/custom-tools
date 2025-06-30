# 修改镜像密码
使用下面命令将镜像挂载到host上，用`passwd root`修改密码和sshd配置。
安装`yum install qemu-img kpartx -y`前置依赖
```shell
if [[ $1 == "attach" ]]; then
        sudo modprobe nbd max_part=16
        qemu-nbd --connect=/dev/nbd0 ./aliyun.vhd
        sudo partprobe /dev/nbd0
        sudo kpartx -av /dev/nbd0
        sudo mkdir /mnt/vhd_root
        sudo mount /dev/mapper/nbd0p2 /mnt/vhd_root
        sudo mount /dev/mapper/nbd0p1 /mnt/vhd_root/boot
        sudo mount --bind /dev /mnt/vhd_root/dev
        sudo mount --bind /dev/pts /mnt/vhd_root/dev/pts
        sudo mount --bind /proc /mnt/vhd_root/proc
        sudo mount --bind /sys /mnt/vhd_root/sys
        sudo mount --bind /run /mnt/vhd_root/run
        sudo chroot /mnt/vhd_root
elif [[ $1 == "clean" ]]; then
        # 卸载所有挂载
        sudo umount /mnt/vhd_root/boot
        sudo umount /mnt/vhd_root/dev/pts
        sudo umount /mnt/vhd_root/dev
        sudo umount /mnt/vhd_root/proc
        sudo umount /mnt/vhd_root/sys
        sudo umount /mnt/vhd_root/run
        sudo umount /mnt/vhd_root

        # 移除映射
        sudo kpartx -d /dev/nbd0
        sudo qemu-nbd --disconnect /dev/nbd0
fi
```
