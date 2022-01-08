#!/usr/bin/env bash
set -e

# See https://developer-old.gnome.org/NetworkManager/stable/nmcli.html
# as well as https://github.com/hashicorp/vagrant/blob/main/plugins/guests/coreos/cap/configure_networks.rb

DEST="/opt/bin"

(
cat <<EOF
#!/usr/bin/env bash

if echo \$* | grep 'c load'; then
	# File is last argument
	eval \$(grep = \${@: -1} | sed -e 's/-/_/g')
	echo -e "[Match]\nName=\$id\n\n[Network]\nAddress=\$addresses\nGateway=\$gateway\n" >/etc/systemd/network/static.network
	# Take new network info into account
	sleep 3
	sudo systemctl restart systemd-networkd
	# Cleanup
	sudo rm -rf /etc/NetworkManager
fi
EOF
) | sudo tee ${DEST}/nmcli

sudo chown root:root ${DEST}/nmcli
sudo chmod 755 ${DEST}/nmcli
sudo mkdir -p /etc/NetworkManager/system-connections
