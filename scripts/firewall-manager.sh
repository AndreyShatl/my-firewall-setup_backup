#!/bin/bash

NFTABLES_CONF="/opt/my-firewall-setup/etc/nftables/main.conf"

case "$1" in
    start)
        echo "Loading nftables rules..."
        sudo nft -f $NFTABLES_CONF
        ;;
    stop)
        echo "Flushing nftables rules..."
        sudo nft delete table inet filter 2>/dev/null || true
        sudo nft delete table ip nat 2>/dev/null || true
        sudo nft delete table inet traffic_shaping 2>/dev/null || true
        ;;
    reload)
        echo "Reloading nftables rules..."
        sudo nft -f $NFTABLES_CONF
        ;;
    status)
        echo "=== NFTables Tables ==="
        sudo nft list tables
        echo -e "\n=== Traffic Shaping Rules ==="
        sudo nft list table inet traffic_shaping 2>/dev/null || echo "Table not loaded"
        ;;
    *)
        echo "Usage: $0 {start|stop|reload|status}"
        exit 1
        ;;
esac
