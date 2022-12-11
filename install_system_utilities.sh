#!/usr/bin/env bash
set -e

# See https://developer-old.gnome.org/NetworkManager/stable/nmcli.html
# as well as https://github.com/hashicorp/vagrant/blob/main/plugins/guests/coreos/cap/configure_networks.rb

DEST="/opt/bin"

(
/usr/bin/cat <<EOF
#!/usr/bin/env bash

if echo \$* | /usr/bin/grep 'c load'; then
	# File is last argument
	eval \$(/usr/bin/grep = \${@: -1} | sed -e 's/-/_/g')
	echo -e "[Match]\nName=\$id\n\n[Network]\nAddress=\$addresses\nGateway=\$gateway\n" >/etc/systemd/network/static.network
	# Take new network info into account
	sleep 3
	/usr/bin/sudo /usr/bin/systemctl restart systemd-networkd
	# Cleanup
	/usr/bin/sudo /usr/bin/rm -rf /etc/NetworkManager
fi
EOF
) | /usr/bin/sudo tee ${DEST}/nmcli

/usr/bin/sudo /usr/bin/chown root:root ${DEST}/nmcli
/usr/bin/sudo /usr/bin/chmod 755 ${DEST}/nmcli
/usr/bin/sudo /usr/bin/mkdir -p /etc/NetworkManager/system-connections
