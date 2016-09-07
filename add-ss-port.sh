#!/bin/bash
if [ -a /etc/shadowsocks-libev/config-${1}.json ]
	then
		#transformation $1 is capitals.
		CAPITALS=$(echo $1 | tr [a-z] [A-Z])
		#add conffile message
		sed -i "15a CONFFILE_$CAPITALS=\"/etc/shadowsocks-libev/config-$1.json\"" /etc/default/shadowsocks-libev
		echo /etc/default/shadowsocks-libev update completed.
		#add service start message
		sed -i "62a \\\t\\t|| (service shadowsocks-libev stop; return 2)" /etc/init.d/shadowsocks-libev
		sed -i "62a \\\t\\t-c \"\$CONFFILE_$CAPITALS\" -a \"\$USER\" -u -f \$PIDFILE-$1 \$DAEMON_ARGS \\\ " /etc/init.d/shadowsocks-libev
		sed -i "62a \\\tstart-stop-daemon --start --quiet --pidfile \$PIDFILE-$1 --chuid root:\$GROUP --exec \$DAEMON -- \\\ " /etc/init.d/shadowsocks-libev
		#add service stop message
		sed -i "/rm -f \$PIDFILE/a\ \\trm -f \$PIDFILE+$1" /etc/init.d/shadowsocks-libev
		sed -i "/rm -f \$PIDFILE/a\ \\t[ \"\$?\" = 2 ] && return 2\\n" /etc/init.d/shadowsocks-libev
		sed -i "/rm -f \$PIDFILE/a\ \\tstart-stop-daemon --stop --quiet --oknodo --retry=KILL/5 --exec \$DAEMON" /etc/init.d/shadowsocks-libev
		sed -i "/rm -f \$PIDFILE/a\ \\t[ \"\$RETVAL\" = 2 ] && return 2\\n" /etc/init.d/shadowsocks-libev
		sed -i "/rm -f \$PIDFILE/a\ \\tRETVAL=\"\$?\"" /etc/init.d/shadowsocks-libev
		sed -i "/rm -f \$PIDFILE/a\ \\n\\tstart-stop-daemon --stop --quiet --retry=KILL/5 --pidfile \$PIDFILE-$1 --exec \$DAEMON" /etc/init.d/shadowsocks-libev
		echo /etc/init.d/shadowsocks-libev update completed.
	else
		echo /etc/shadowsocks-libev/config-${1}.json not exist.
fi
