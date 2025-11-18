#!/bin/bash

SERVICES=(
    "zapret-youtube-tcp"
    "zapret-youtube-udp" 
    "zapret-instagram-tcp"
    "zapret-instagram-udp"
    "zapret-discord-tcp"
    "zapret-discord-udp"
)

SERVICES_DIR="/opt/my-firewall-setup/systemd/services"
SYSTEMD_DIR="/etc/systemd/system"

case "$1" in
    install)
        echo "Installing services to systemd..."
        for service in "${SERVICES[@]}"; do
            service_file="$SERVICES_DIR/${service}.service"
            if [ -f "$service_file" ]; then
                sudo cp "$service_file" $SYSTEMD_DIR/
                echo "Installed: $service"
            else
                echo "Warning: $service_file not found"
            fi
        done
        sudo systemctl daemon-reload
        ;;
    enable)
        echo "Enabling services..."
        for service in "${SERVICES[@]}"; do
            sudo systemctl enable $service 2>/dev/null && echo "Enabled: $service" || echo "Failed to enable: $service"
        done
        ;;
    disable)
        echo "Disabling services..."
        for service in "${SERVICES[@]}"; do
            sudo systemctl disable $service 2>/dev/null && echo "Disabled: $service" || echo "Failed to disable: $service"
        done
        ;;
    start)
        echo "Starting services..."
        for service in "${SERVICES[@]}"; do
            sudo systemctl start $service 2>/dev/null && echo "Started: $service" || echo "Failed to start: $service"
        done
        ;;
    stop)
        echo "Stopping services..."
        for service in "${SERVICES[@]}"; do
            sudo systemctl stop $service 2>/dev/null && echo "Stopped: $service" || echo "Failed to stop: $service"
        done
        ;;
    status)
        echo "Service status:"
        for service in "${SERVICES[@]}"; do
            if systemctl is-active $service >/dev/null 2>&1; then
                echo "  $service: active"
            else
                echo "  $service: inactive"
            fi
        done
        ;;
    restart)
        $0 stop
        sleep 2
        $0 start
        ;;
    *)
        echo "Usage: $0 {install|enable|disable|start|stop|status|restart}"
        exit 1
        ;;
esac
