#!/sbin/runscript

extra_started_commands="reload"

TTYJS_CONFDIR=${TTYJS_CONFDIR:-/etc/tty.js}
TTYJS_CONFIG=${TTYJS_CONFIG:-${TTYJS_CONFDIR}/config.json}
TTYJS_PIDFILE=${TTYJS_PIDFILE:-/var/run/${SVCNAME}.pid}
TTYJS_BINARY=${TTYJS_BINARY:-/usr/local/bin/tty.js}
TTYJS_LOGFILE=${TTYJS_LOGFILE:-/var/log/tty.js}

depend() {
	need net
	use logger dns
}

start() {
	ebegin "Starting ${SVCNAME}"
	start-stop-daemon --start --exec "${TTYJS_BINARY}" \
	    --pidfile "${TTYJS_PIDFILE}" \
		--make-pidfile \
		--background \
		--stdout ${TTYJS_LOGFILE} \
	    -- --config ${TTYJS_CONFIG} \
		--daemonize \
		${TTYJS_OPTS}
	eend $?
}

stop() {
	ebegin "Stopping ${SVCNAME}"
	start-stop-daemon --stop --exec "${TTYJS_BINARY}" \
	    --pidfile "${TTYJS_PIDFILE}" --quiet
	eend $?
}

reload() {
	ebegin "Reloading ${SVCNAME}"
	start-stop-daemon --signal HUP \
	    --exec "${TTYJS_BINARY}" --pidfile "${TTYJS_PIDFILE}"
	eend $?
}
