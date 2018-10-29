#!/bin/sh
#program_spinor.sh   
version=1.0
print_usage()
{
	 	echo "program_spinor v.$version"
 		echo "Usage: `basename $0` wid <sd/emmc>"
 		echo "Example: `basename $0` 0510aa0101 emmc"
		exit $E_BADARGS
}
if [ $# -ne 2 ]
then
        print_usage
        exit 1
fi
wid=$1
type=$2
uboot_imx_ver=0533-012
uboot_imx_bin_dir=u-boot.imx-binaries
uboot_imx_name=u-boot.imx.wid${wid}-${uboot_imx_ver}
uboot_bin_dir=../out/target/product/evb_egf_6dq
spl_name=SPL-egf_evb_mx6android_spl_${type}_config
uboot_img_name=u-boot-egf_evb_mx6android_spl_${type}_config.img

if [ ! -e ${uboot_bin_dir}/${spl_name} ]; then
	echo "$spl_name File missing!"
	exit
fi

if [ ! -e ${uboot_bin_dir}/${uboot_img_name} ]; then
	echo "$uboot_img_name File missing!"
	exit
fi

if [ ! -e ${uboot_imx_bin_dir}/${uboot_imx_name} ]; then
	echo "$uboot_mfg_name File missing!"
	exit
fi

echo SPL:${spl_name}
echo UBOOT:${uboot_img_name}
echo UBOOTMFG:${uboot_imx_name}

cf=mx6_usb_work.conf

rm $cf
echo mx6_qsb  >> $cf
echo "hid,1024,0x10000000,1G,0x00907000,0x31000" >> $cf
echo ${uboot_imx_bin_dir}/${uboot_imx_name}":dcd" >> $cf
echo ${uboot_bin_dir}/${spl_name}":load        0x12000000" >> $cf
echo ${uboot_bin_dir}/${uboot_img_name}":load 0x12500000" >> $cf
echo ${uboot_imx_bin_dir}/${uboot_imx_name}":clear_dcd, jump header" >> $cf

sudo ./imx_usb



