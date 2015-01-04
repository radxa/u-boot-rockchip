#!/bin/bash

IDBS0="tools/rk_tools/idb_sector_0"
IDBS1="tools/rk_tools/idb_sector_1"
FDATA="tools/rk_tools/3188_LPDDR2_300MHz_DDR3_300MHz_20130830.bin"
FBOOT="u-boot.bin"
KEY="7c4e0304550509072d2c7b38170d1711"
SDIMG="u-boot-sd.img"

cat ${IDBS0} | split -b 512 --filter="openssl rc4 -K ${KEY}" | dd of=${SDIMG} conv=sync
cat ${IDBS1}                                                 | dd of=${SDIMG} conv=notrunc,sync seek=1
cat ${FDATA} | split -b 512 --filter="openssl rc4 -K ${KEY}" | dd of=${SDIMG} conv=notrunc,sync seek=4
cat ${FBOOT} | split -b 512 --filter="openssl rc4 -K ${KEY}" | dd of=${SDIMG} conv=notrunc,sync seek=36

echo "u-boot for sdcard is packed : $SDIMG"
echo "write it to sdcard with:"
echo "dd if=$SDIMG of=/dev/sdx seek=64"
