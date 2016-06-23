# Consul4CoreOS

### Fleet Unit files to bootstrap a new Consul Cluster on CoreOS

Inspired from
- https://github.com/democracyworks/consul-coreos
- https://gist.github.com/divideandconquer/08405a4fb597319d3c3e

## Why ?
Since Consul brings interesting features (service catalog, DNS interface, watches) that etcd does not support, it is nice to have a Consul cluster too.

## What is provided ?
- Up and running autonomous Consul cluster
- DNS service
- Automatic service declaration via Registrator

## Quick install
`git clone git@github.com:vvanholl/consul4coreos.git`

`cd consul4coreos`

`./install.sh`

Note that you can give options to ./install.sh, like `--registrator` to also add Registrator service, or `--join <node>` to join an existing cluster

## Manual install

### 1. Clone this repo :
`git clone git@github.com:vvanholl/consul4coreos.git`

`cd consul4coreos`

### 2. Change some variables (if needed)
Open service file in your favorite editor

`vi consul.service`

and modify these lines :

```
Environment=DOCKER_REPOSITORY=gliderlabs/consul-server
Environment=DOCKER_CONTAINER=consul
Environment=CONSUL_DATACENTER=dc1
```

### 3. Submit unit file into Fleet
`fleetctl submit consul.service`

### 4. Start services
`fleetctl start consul.service`

### 5. Optional: Maybe you'll need also Registrator to declare services from running containers
`fleetctl submit registrator.service`

`fleetctl start registrator.service`
