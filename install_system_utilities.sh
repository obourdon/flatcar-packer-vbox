#!/usr/bin/env bash
set -e

DEST="/opt/bin"

(
cat <<EOF
#!/usr/bin/env bash
echo "STDOUT Running as \$(id)"
echo "STERR Running as \$(id)" >/dev/stderr
echo "STDOUT Args: \$* ===="
echo "STDERR Args: \$* ====" >/dev/stderr
EOF
) | sudo tee ${DEST}/nmcli

sudo chown root:root ${DEST}/nmcli
sudo chmod 755 ${DEST}/nmcli
sudo mkdir -p /etc/NetworkManager/system-connections
