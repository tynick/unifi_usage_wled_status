#!/bin/bash
# tynick.com/blog/12-29-2019/internet-data-usage-monitoring-so-you-dont-hit-your-data-cap/
# get data tx and rx usage from ubiquiti USG
# change wled color based on usage

# USG port
# uncomment/comment the next two lines based on what USG model you have
interface="eth2" # USG PRO 4
#interface="eth0" # USG


# IP address of WLED node you want to control
wled_ip='192.168.1.153'

# status colors
very_bad='&A=128&FX=1&SX=245&R=255&G=0&B=0' # red flashing
bad='&A=128&FX=0&SX=0&R=255&G=0&B=0' # red
warn='&A=128&FX=0&SX=0&R=255&G=127&B=0' orangish
ok='&A=128&FX=0&SX=0&R=255&G=255&B=0' # yellowish
good='&A=128&FX=0&SX=0&R=127&G=255&B=0' # light green
great='&A=128&FX=0&SX=0&R=0&G=255&B=0' # green

# get total bytes from WAN interface
rx_bytes_used=$(/opt/vyatta/bin/vyatta-op-cmd-wrapper show interfaces ethernet "${interface}" | grep 'RX' -A1 | tail -1 | awk '{ print $1 }' | awk '{ gb =$1 /1024/1024/1024; print gb }')
tx_bytes_used=$(/opt/vyatta/bin/vyatta-op-cmd-wrapper show interfaces ethernet "${interface}" | grep 'TX' -A1 | tail -1 | awk '{ print $1 }' | awk '{ gb =$1 /1024/1024/1024; print gb }')

# convert bytes to gigabytes. remove decimal and "round up" by 1
rx_gb_used=$(echo "${rx_bytes_used}" | cut -d \. -f 1); let rx_gb_used++
tx_gb_used=$(echo "${tx_bytes_used}" | cut -d \. -f 1); let tx_gb_used++
let "total_gb_used=rx_gb_used+tx_gb_used"

echo "rx bytes = "${rx_bytes_used}""
echo "tx bytes = "${tx_bytes_used}""
echo "rx gb = "${rx_gb_used}""
echo "tx gb = "${tx_gb_used}""
echo "total gb = "${total_gb_used}""

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
