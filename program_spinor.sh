#program_spinor.sh   
version=1.0
function print_usage()
{
	 	echo "program_spinor v.$version"
 		echo "Usage: `basename $0` bootloader_version wid"
 		echo "Example: `basename $0` 0659-001 0659aa0101"
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

if [ $wid == '0659aa0101' ] 
then
	cpu_type='mx6ull'
elif [ $wid == '0659xx0101' ]  
then
	cpu_type='mx6ul'
else
	echo "Unsupported WID: $wid"
	exit
fi
spl_name=$uboot_bin_dir/SPL-$cpu_type-$bv
uboot_img_name=$uboot_bin_dir/u-boot.img-$cpu_type-$bv
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
echo "hid,1024,0x910000,0x80000000,512M" >> $cf
echo $uboot_mfg_name":dcd" >> $cf
echo $spl_name":load        0x80100000" >> $cf
echo $uboot_img_name":load 0x80600000" >> $cf
echo $uboot_mfg_name":clear_dcd, jump header" >> $cf

sudo ./imx_usb


