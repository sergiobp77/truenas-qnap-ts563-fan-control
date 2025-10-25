# truenas-qnap-ts563-fan-control
TrueNAS fan control script &amp; service units to adjust fan speed

1. Download
2. Check hwmon devices & adjust script
3. Enable PWM fan control with:
echo 1 | sudo tee /sys/class/hwmon/hwmon4/device/pwm1_enable
4. Copy .service and .target files to /etc/systemd/system
5. sudo systemctl daemon-reload
6. sudo enable fan-control.timer
7. sudo start fan-control.timer

Check the journal to see it in action:
sudo journalctl -f -u fan-control

IMPORTANT:
- Don't forget to enable the PWM or you will get read-only errors when trying to change the PWM value.
- Adjust the .service unit file to point to where you put the fan-control.sh file in your fs.
