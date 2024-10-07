#!/bin/bash

# Update and install required packages
apt-get update -y
apt-get install -y screen cron wget curl libuv1-dev libssl-dev libhwloc-dev

# Set up huge pages (adjust based on testing)
HUGE_PAGES_COUNT=128
echo $HUGE_PAGES_COUNT > /proc/sys/vm/nr_hugepages

# Add huge pages setting to sysctl.conf for persistence
if ! grep -q "vm.nr_hugepages" /etc/sysctl.conf; then
    echo "vm.nr_hugepages=$HUGE_PAGES_COUNT" >> /etc/sysctl.conf
    sysctl -p
fi

# Download and set up XMRig
cd ~
wget https://raw.githubusercontent.com/SamCoThePuggo/Scripts/main/xmrig
chmod +x ./xmrig

# Start XMRig with optimizations
screen -dmS xmrig_session ./xmrig \
    -o pool.supportxmr.com:3333 \
    --nicehash \
    --randomx-1gb-pages \
    --randomx-wrmsr \
    --cpu-no-yield \
    --cpu-max-threads-hint=100 \
    --threads=24 \
    --cpu-priority=-10 \
    --donate-level=1 \
    -u 48iTUj2b6AK9Vzk5eKBsAxNA42w2zumc7CSUTxt7DgjYXSNroZ6it1EMghmV9rtzJS4BXGSkBZ9BiZdjBo6XQa1jRRVCXqc \
    -p magnesium

echo "XMRig has been started in a detached screen session named 'xmrig_session'"
echo "Attach: screen -r xmrig_session"
