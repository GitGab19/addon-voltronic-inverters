# Home Assistant Add-on: Voltronic

Monitor and control Voltronic-based inverters directly from Home Assistant. This add-on supports a wide range of inverters that use Voltronic hardware, including brands such as Axpert, MPP Solar PIP, Voltacon, Effekta, and others.

## Installation

The installation of this add-on is straightforward and follows the typical process for installing Home Assistant add-ons.

[![Open your Home Assistant instance and show the add add-on repository dialog with a specific repository URL pre-filled.](https://my.home-assistant.io/badges/supervisor_add_addon_repository.svg)](https://my.home-assistant.io/redirect/supervisor_add_addon_repository/?repository_url=https%3A%2F%2Fgithub.com%2FGitGab19%2Faddon-voltronic-inverters)

1. Click the "Install" button to install the add-on.
2. Configure the add-on under the **Configuration** tab as needed (see the configuration section below).
3. Start the "Voltronic" add-on.
4. Check the logs of the "Voltronic" add-on to ensure everything is running correctly.
5. Once running, the add-on will begin monitoring your inverter and sending data to your configured MQTT broker.

## Configuration

This add-on requires some configuration to function properly. Below are the configuration options:

### Options

| Option             | Description                                   | Example Value   |
|--------------------|-----------------------------------------------|-----------------|
| `mqtt_broker_host` | The MQTT broker host address.                | `core-mosquitto`|
| `mqtt_username`    | The username for the MQTT broker.            | `mqtt_user`     |
| `mqtt_password`    | The password for the MQTT broker.            | `mqtt_password` |
| `device_name`      | The device name which is used for MQTT.      | `device_name` |
| `device_type`      | The type of device connection. Can be one of `serial`, `usb-serial`, or `usb`. | `usb` |
| `device_path`      | Optional. Override the auto-detected device with a specific path (e.g. when your inverter is on `hidraw1` or `ttyUSB1`). Leave empty to map from `device_type`. | `/dev/hidraw1` |

### Example Configuration
```yaml
mqtt_broker_host: "core-mosquitto"
mqtt_username: "mqtt_user"
mqtt_password: "mqtt_password"
device_name: "device_name"
device_type: "usb"
device_path: ""
```

## Updating Configuration

After making changes to the configuration, restart the add-on for the changes to take effect.

# Supported Devices

The add-on supports the following device connections:
- `/dev/ttyS0` (Serial)
- `/dev/ttyUSB0` (USB-Serial)
- `/dev/hidraw0` (USB)

Ensure the correct device path is used and accessible by the Home Assistant system.

## Changelog & Releases

This repository keeps a change log using [GitHub's releases](https://github.com/GitGab19/addon-voltronic-inverters/releases) functionality.

Releases follow Semantic Versioning and use the MAJOR.MINOR.PATCH format. Versioning works as follows:
- `MAJOR`: Incompatible or significant changes.
- `MINOR`: Backwards-compatible new features or enhancements.
- `PATCH`: Backwards-compatible bug fixes or updates.

## License

This add-on is licensed under the MIT License. See the `LICENSE` file for more details.