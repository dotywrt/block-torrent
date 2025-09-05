# Block Torrent on Server (dotywrt version)

This script blocks torrent traffic on your Linux VPS/server by updating `iptables` rules and `/etc/hosts` daily.

## Installation

Run the following one-liner command to download, make executable, and run the installer:

```bash
wget -O bt-doty.sh https://raw.githubusercontent.com/dotywrt/block-torrent/main/bt-doty.sh && chmod +x bt-doty.sh && ./bt-doty.sh
