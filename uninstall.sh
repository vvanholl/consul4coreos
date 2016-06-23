#!/bin/sh

function delete_unit {
	unit=$1
	status=$(fleetctl status $unit 2>&1)
	if [ "$status" != "Unit $unit does not exist." ]; then
		echo "-> Removing $unit"
		fleetctl stop $unit
		fleetctl destroy $unit
	else
		echo "-> $unit unit does not exist, no need to remove"
	fi
}

delete_unit "registrator.service"
delete_unit "consul.service"

etcdctl rm /services/consul --recursive >/dev/null 2>&1

exit 0
