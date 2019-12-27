# unifi_usage_wled_status

This repo contains the files used to monitor monthly data usage on a Ubiquiti USG Pro. If you have a crappy ISP, this will allow you to quickly see how close you are to hitting your monthly data cap.

Color of WLED LEDs will change based on how much data has been transferred over WAN port.

Visit https://tynick.com/blog/12-26-2019/internet-data-usage-monitoring-so-you-dont-hit-your-data-cap/ for full instructions on how to get everything setup.

## get_usage.sh

Queries the WAN port to see how much data has been used (RX and TX) since the last time it was reset.

## reset_usage.sh

Very simple script to reset the counters on the WAN port.

## config.gateway.json

This JSON file will configure cron jobs to run the previous bash scripts at specific intervals.