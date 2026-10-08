#!/bin/bash

UNBUFFER='stdbuf -i0 -oL -eL'

# stty -F /dev/ttyUSB0 2400 raw

# Init the mqtt server.  This creates the config topics in the MQTT server
# that the MQTT integration uses to create entities in HA.

# broker using persistence (default HA config)
$UNBUFFER /opt/inverter-mqtt/mqtt-init.sh

# broker not using persistence
#(while :; do $UNBUFFER /opt/inverter-mqtt/mqtt-init.sh; sleep 300; done) &

# Run the inverter poller and the MQTT command subscriber sequentially. They
# both spawn inverter_poller, which talks to the inverter's serial/USB port.
# Running them concurrently let the two processes race for the port, which
# produced intermittent partial reads and crashes
# ("timeout: the monitored command dumped core").
while :; do
    $UNBUFFER /opt/inverter-mqtt/mqtt-push.sh
    timeout --signal=SIGINT 5s $UNBUFFER /opt/inverter-mqtt/mqtt-subscriber.sh
    sleep 2
done