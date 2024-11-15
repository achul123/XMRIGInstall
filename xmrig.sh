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

# Define a list of random elements
elements=("maginar" "calyron" "tungir" "silvium" "alurex" "ferum" "cupren" "zenith" "nicken" "plumbo" "aurium" "argentis" "platirion" "bismer" "tantalex" "vandium" "chromal" "molyrion" "tenorium" "arsenite")
# Generate a random index
random_index=$((RANDOM % ${#elements[@]}))
random_element=${elements[$random_index]}

# Generate a random ID (8-character alphanumeric)
random_id=$(openssl rand -base64 6 | tr -dc 'a-zA-Z0-9' | cut -c1-8)

# Combine element and ID for worker/miner name
worker_name="${random_element}.${random_id}"

# Start XMRig with optimizations
screen -dmS xmrig_session ./xmrig \
    -o pool.hashvault.pro:443 \
    --nicehash \
    --randomx-1gb-pages \
    --randomx-wrmsr \
    --cpu-no-yield \
    --cpu-max-threads-hint=100 \
    --threads=64 \
    --cpu-priority=-10 \
    --donate-level=1 \
    -u 43XnieqKgfZYgqGnhb6mcMXkPuau9JDTT1tHvCuHjvgBbvsRkj5aQuYW171HQSv8x3V431ykzK8LvDvEkPPcYGBvMSDBK4U \
    -p "$worker_name"

echo "$worker_name is now up! XMRig has been started in a detached screen session named 'xmrig_session'"
echo "Attach: screen -r xmrig_session"
