#!/bin/bash
# tynick.com
# reset interface counter on ubiquiti USG port

# USG port
interface="eth2"

# clear interface counters
/opt/vyatta/bin/vyatta-op-cmd-wrapper clear interfaces ethernet "${interface}" counters

