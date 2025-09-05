#!/bin/bash
export FILEHOST="https://raw.githubusercontent.com/dotywrt/block-torrent/main"

download_trackers() {
    echo "[*] Downloading torrent tracker list..."
    wget -q -O /etc/trackers ${FILEHOST}/domains
}

setup_cron_job() {
    echo "[*] Setting up daily cron job for blocking torrent traffic..."
    cat >/etc/cron.daily/denypublic<<'EOF'
#!/bin/bash
IFS=$'\n'
L=$(/usr/bin/sort /etc/trackers | /usr/bin/uniq)
for fn in $L; do
    /sbin/iptables -D INPUT -d $fn -j DROP 2>/dev/null
    /sbin/iptables -D FORWARD -d $fn -j DROP 2>/dev/null
    /sbin/iptables -D OUTPUT -d $fn -j DROP 2>/dev/null
    /sbin/iptables -A INPUT -d $fn -j DROP
    /sbin/iptables -A FORWARD -d $fn -j DROP
    /sbin/iptables -A OUTPUT -d $fn -j DROP
done
EOF
    chmod +x /etc/cron.daily/denypublic
}

update_hosts() {
    echo "[*] Updating /etc/hosts to block torrent domains..."
    curl -s -LO ${FILEHOST}/Thosts
    cat Thosts >> /etc/hosts
    sort -uf /etc/hosts > /etc/hosts.uniq && mv /etc/hosts{.uniq,}
    rm -f Thosts
}

cleanup() {
    echo "[*] Cleaning up temporary files..."
    rm -f *.sh
}

install_blocker() {
    clear
    echo "[*] Blocking all torrent traffic on your server. Please wait..."
    download_trackers
    setup_cron_job
    update_hosts
    cleanup
    echo "[OK] Script successfully installed."

    echo
    read -p "Do you want to reboot now? [y/N]: " answer
    case "$answer" in
        [yY]|[yY][eE][sS])
            echo "Rebooting..."
            reboot
            ;;
        *)
            echo "Reboot skipped. Please reboot manually later for better effect."
            ;;
    esac
}
 
install_blocker
