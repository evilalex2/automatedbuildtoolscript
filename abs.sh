#!/bin/bash
#normal image#
cd /build/build_normal

/build/build_normal/compile.sh KERNEL_ONLY=no KERNEL_CONFIGURE=no BOARD=orangepiplus2e BRANCH=next RELEASE=stretch BUILD_DESKTOP=no FORCE_USE_RAMDISK=yes USE_CCACHE=yes
/build/build_normal/compile.sh KERNEL_ONLY=no KERNEL_CONFIGURE=no BOARD=orangepiplus BRANCH=next RELEASE=stretch BUILD_DESKTOP=no FORCE_USE_RAMDISK=yes USE_CCACHE=yes
/build/build_normal/compile.sh KERNEL_ONLY=no KERNEL_CONFIGURE=no BOARD=orangepizero BRANCH=next RELEASE=stretch BUILD_DESKTOP=no FORCE_USE_RAMDISK=yes USE_CCACHE=yes
/build/build_normal/compile.sh KERNEL_ONLY=no KERNEL_CONFIGURE=no BOARD=odroidxu4 BRANCH=next RELEASE=stretch BUILD_DESKTOP=no FORCE_USE_RAMDISK=yes USE_CCACHE=yes
/build/build_normal/compile.sh KERNEL_ONLY=no KERNEL_CONFIGURE=no BOARD=odroidxu4 BRANCH=default RELEASE=xenial BUILD_DESKTOP=yes FORCE_USE_RAMDISK=yes USE_CCACHE=yes

cd /build/build_normal/output/images
mkdir build_day_$(date '+%d-%m-%Y_%H:%M')
mv -v /build/build_normal/output/images/*.img /build/build_normal/output/images/build_day_*/

cd /build/build_normal/output/images/build_day_*/
gzip -kv *.img

cd /var/www/html
find /var/www/html/armbian/* -mtime +6 -exec rm -rv {} \;
mv -v --backup=numbered /var/www/html/build_day_* /var/www/html/armbian/
mkdir build_day_$(date '+%d-%m-%Y_%H:%M')
cp -v --backup=numbered /build/build_normal/output/images/build_day_*/*.gz /var/www/html/build_day_*/
chown -R alexander /var/www/
chmod -R 755 /var/www/html

cd
cp -rv --backup=numbered  /build/build_normal/output/images/* /data/current_month/
rm -rv /build/build_normal/output/images/*
chown -R alexander /data

#dev image#
cd /build/build_dev
/build/build_dev/compile.sh KERNEL_ONLY=no KERNEL_CONFIGURE=no BOARD=orangepiplus2e BRANCH=dev RELEASE=stretch BUILD_DESKTOP=no FORCE_USE_RAMDISK=yes USE_CCACHE=yes
/build/build_dev/compile.sh KERNEL_ONLY=no KERNEL_CONFIGURE=no BOARD=orangepiplus BRANCH=dev RELEASE=stretch BUILD_DESKTOP=no FORCE_USE_RAMDISK=yes USE_CCACHE=yes
/build/build_dev/compile.sh KERNEL_ONLY=no KERNEL_CONFIGURE=no BOARD=orangepizero BRANCH=dev RELEASE=stretch BUILD_DESKTOP=no FORCE_USE_RAMDISK=yes USE_CCACHE=yes

cd /build/build_dev/output/images
mkdir build_dev_day_$(date '+%d-%m-%Y_%H:%M')
mv -v /build/build_dev/output/images/*.img /build/build_dev/output/images/build_dev_day_*/
cd /build/build_dev/output/images/build_dev_day_*/
gzip -v *.img

cd /var/www/html
mv -v --backup=numbered /var/www/html/build_dev_day_* /var/www/html/armbian/
cp -rv --backup=numbered /build/build_dev/output/images/* /var/www/html/
chown -R alexander /var/www/
chmod -R 755 /var/www/html

cp -rv --backup=numbered  /build/build_dev/output/images/* /data/dev/
rm -rv /build/build_dev/output/images/*
cd /data
find /data/dev/* -mtime +50 -exec rm -rv {} \;
chown -R alexander /data

#end of month archive#
day=$(date +%d -d tomorrow)
if test $day -eq 1 ; then
cd /data
mv -v --backup=numbered /data/previous_month/build_day_*/* /data/previous_month/build_month_*/
rm -rv /data/previous_month/build_day_*
rm -v /data/previous_month/build_month_*/*.~*
mv -v --backup=numbered  /data/previous_month/build_month_* /data/archive/
cd /data/current_month/
mkdir build_month_$(date '+%m-%Y')
mv -v --backup=numbered  /data/current_month/* /data/previous_month/
chown -R alexander /data
echo done
else
   echo "Not last day of month"
fi


