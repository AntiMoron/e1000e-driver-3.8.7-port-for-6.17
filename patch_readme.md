
sudo modprobe e1000e

ip link show

ethtool -i eth0 2>/dev/null || ethtool -i enp0s31f6 2>/dev/null