#!/bin/sh

if [ -f /etc/environment ]; then
	source /etc/environment
else
	echo "You have no /etc/environment file, aborting !"
	exit 1
fi

if [ "$COREOS_PUBLIC_IPV4" == "" ]; then
	echo "You must set COREOS_PUBLIC_IPV4 environment variable !"
	exit 1
fi

HELP=NO
REGISTRATOR=NO
JOIN=""
while [[ $# -gt 0 ]]; do
	key="$1"
	case $key in
		--registrator)
		REGISTRATOR=YES
		;;
		--join)
		JOIN="$JOIN $2"
		shift
		;;
		--help)
		HELP=YES
		;;
		*)
		;;
	esac
	shift
done

if [ "$HELP" == "YES" ]; then
	echo "Usage: $0 [options]"
	echo "--registrator : install Registrator service"
	echo "--join : pre-existing Consul nodes to join"
	exit 0
fi

if [ "$JOIN" != "" ]; then
	for join in $JOIN; do
		echo "-> Joining $join"
		etcdctl mk /services/consul/bootstrap/servers/$join $join >/dev/null 2>&1
	done
fi

echo "-> Installing Consul service"
fleetctl submit consul.service
fleetctl start consul.service

if [ "$REGISTRATOR" == "YES" ]; then
	echo "-> Installing Registrator.service"
	fleetctl submit registrator.service
	fleetctl start registrator.service
fi

exit 0
