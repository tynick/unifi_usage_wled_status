#!/bin/bash
# tynick.com/blog/12-29-2019/internet-data-usage-monitoring-so-you-dont-hit-your-data-cap/
# reset interface counter on ubiquiti USG port

# USG port
# uncomment/comment the next two lines based on what USG model you have
interface="eth2" # USG PRO 4
#interface="eth0" # USG

# clear interface counters
/opt/vyatta/bin/vyatta-op-cmd-wrapper clear interfaces ethernet "${interface}" counters

