#!/bin/bash
# tynick.com
# get data tx and rx usage from ubiquiti USG
# change wled color based on usage

# USG port
interface="eth2"

# wled IP address
wled_ip='192.168.1.145'

# status colors
very_bad='&A=128&FX=1&SX=245&R=255&G=0&B=0'
bad='&A=128&FX=0&SX=0&R=255&G=0&B=0'
warn='&A=128&FX=0&SX=0&R=255&G=127&B=0'
ok='&A=128&FX=0&SX=0&R=255&G=255&B=0'
good='&A=128&FX=0&SX=0&R=127&G=255&B=0'
great='&A=128&FX=0&SX=0&R=0&G=255&B=0'

# get total bytes from WAN interface
rx_bytes_used=$(cat /sys/class/net/"${interface}"/statistics/rx_bytes | awk '{ gb =$1 /1024/1024/1024; print gb }')
tx_bytes_used=$(cat /sys/class/net/"${interface}"/statistics/tx_bytes | awk '{ gb =$1 /1024/1024/1024; print gb }')

# convert bytes to gigabytes. remove decimal and "round up" by 1
rx_gb_used=$(echo "${rx_bytes_used}" | cut -d \. -f 1); let rx_gb_used++
tx_gb_used=$(echo "${tx_bytes_used}" | cut -d \. -f 1); let tx_gb_used++
let "total_gb_used=rx_gb_used+tx_gb_used"

echo "${total_gb_used}"

# set wled params based on total_gb_used
if [[ "${total_gb_used}" -gt 999 ]]; then
    curl "http://"${wled_ip}"/win"${very_bad}""
elif [[ "${total_gb_used}" -gt 900 ]]; then
    curl "http://"${wled_ip}"/win"${bad}""
elif [[ "${total_gb_used}" -gt 600 ]]; then
    curl "http://"${wled_ip}"/win"${warn}""
elif [[ "${total_gb_used}" -gt 400 ]]; then
    curl "http://"${wled_ip}"/win"${ok}""
elif [[ "${total_gb_used}" -gt 200 ]]; then
    curl "http://"${wled_ip}"/win"${good}""
elif [[ "${total_gb_used}" -ge 0 ]]; then
    curl "http://"${wled_ip}"/win"${great}""
fi
