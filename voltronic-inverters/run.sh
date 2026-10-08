#!/usr/bin/with-contenv bashio
set -e

# Paths to configuration files
INVERTER_CONFIG="/etc/inverter/inverter.conf"
MQTT_CONFIG="/etc/inverter/mqtt.json"

# Check if files exist
if [ ! -f "$INVERTER_CONFIG" ]; then
    bashio::log.error "The inverter configuration file ($INVERTER_CONFIG) is missing!"
    exit 1
fi

if [ ! -f "$MQTT_CONFIG" ]; then
    bashio::log.error "The MQTT configuration file ($MQTT_CONFIG) is missing!"
    exit 1
fi

# Update the inverter.conf file
DEVICE=$(bashio::config 'device_type')
CUSTOM_DEVICE_PATH=$(bashio::config 'device_path')

if [ -n "${CUSTOM_DEVICE_PATH}" ]; then
    DEVICE_PATH="${CUSTOM_DEVICE_PATH}"
else
    case "${DEVICE}" in
        serial)
            DEVICE_PATH="/dev/ttyS0"
            ;;
        usb-serial)
            DEVICE_PATH="/dev/ttyUSB0"
            ;;
        usb)
            DEVICE_PATH="/dev/hidraw0"
            ;;
        *)
            bashio::log.error "Invalid device type: ${DEVICE}"
            exit 1
            ;;
    esac
fi

echo "[DEBUG] Updating inverter.conf file with device: $DEVICE_PATH"
sed -i "s|^device=.*|device=${DEVICE_PATH}|" "$INVERTER_CONFIG" || {
    bashio::log.error "Error updating $INVERTER_CONFIG"
    exit 1
}

# Update the mqtt.json file
BROKER_HOST=$(bashio::config 'mqtt_broker_host')
USERNAME=$(bashio::config 'mqtt_username')
PASSWORD=$(bashio::config 'mqtt_password')
DEVICE_NAME=$(bashio::config 'device_name')

echo "[DEBUG] Updating mqtt.json file"
jq --arg server "$BROKER_HOST" \
   --arg username "$USERNAME" \
   --arg password "$PASSWORD" \
   --arg devicename "$DEVICE_NAME" \
   '.server = $server | .username = $username | .password = $password | .devicename = $devicename' \
   "$MQTT_CONFIG" > "${MQTT_CONFIG}.tmp" && mv "${MQTT_CONFIG}.tmp" "$MQTT_CONFIG" || {
    bashio::log.error "Error updating $MQTT_CONFIG"
    exit 1
}

# Debug: Print updated file contents
echo "[DEBUG] Updated content of inverter.conf:"
cat "$INVERTER_CONFIG"

echo "[DEBUG] Updated content of mqtt.json:"
cat "$MQTT_CONFIG"

bashio::log.info "Configuration completed successfully."

exec /opt/inverter-mqtt/entrypoint.sh