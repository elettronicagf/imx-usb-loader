#program_spinor.sh   
function print_usage()
{
 		echo "Usage: `basename $0` bootloader_version wid"
 		echo "Example: `basename $0` 0508-001 0508aa0101"
		exit $E_BADARGS
}
if [ $# -ne 2 ]
then
        print_usage
        exit 1
fi
bv=$1
wid=$2
uboot_bin_dir=../u-boot/binaries
spl_name=$uboot_bin_dir/SPL-$bv
uboot_img_name=$uboot_bin_dir/u-boot.img-$bv
uboot_mfg_name=$uboot_bin_dir/u-boot.imx.wid$wid-$bv

if [ ! -e $spl_name ]; then
	echo "$spl_name File missing!"
	exit
fi

if [ ! -e $uboot_img_name ]; then
	echo "$uboot_img_name File missing!"
	exit
fi

if [ ! -e $uboot_mfg_name ]; then
	echo "$uboot_mfg_name File missing!"
	exit
fi

echo SPL:$spl_name
echo UBOOT:$uboot_img_name
echo UBOOTMFG:$uboot_mfg_name

cf=mx6_usb_work.conf

rm $cf
echo mx6_qsb  >> $cf
echo "hid,1024,0x10000000,1G,0x00907000,0x31000" >> $cf
echo $uboot_mfg_name":dcd" >> $cf
echo $spl_name":load        0x12000000" >> $cf
echo $uboot_img_name":load 0x12500000" >> $cf
echo $uboot_mfg_name":clear_dcd, jump header" >> $cf

sudo ./imx_usb



