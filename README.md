## Synopsis

CloudFlare Dynamic DNS client

## Motivation

All the other CloudFlare DDNS clients I examined use the deprecated API v1. This script uses API v4.

Rather than using DNS to resolve the host, the CloudFlare API is queried for the IP. This allows the script to function with split-horizon DNS where the host resolves to an internal IP.

## Installation

### Gentoo

https://github.com/mark-wagner/portage/tree/master/net-dns/cfdc/cfdc-9999.ebuild

Add =net-dns/cfdc-9999 \*\* to /etc/portage/package.keywords.

Create a configuration file (default is /etc/cfdc.conf). The format is JSON and these are the required keys:
* api\_token - cloudflare api token with Zone.Zone, Zone.DNS permissions
* name - host name you want to update
* zone - zone (domain) you want to update

Optional keys:
* sleep - interval in seconds to sleep between checks
* ip\_urls - list of URLs that return the IP and only the IP in plain text
* endpoint - CloudFlare API endpoint
* ttl - time to live of entry

Update /etc/conf.d/cfdc as needed.

To have the script start at boot run `rc-update add cfdc default`. The provided init script is for OpenRC. Adapt for your favorite init system. :)

If you changed the location of the log file update /etc/logrotate.d/cfdc.

### Kubernetes

Create a json file cfdc.conf with keys desribed as above.

```
kubectl create secret generic cfdc --from-file cfdc.conf
```

Sample manifest:

```
apiVersion: apps/v1
kind: Deployment
metadata:
  name: cfdc
  labels:
    app: cfdc
spec:
  selector:
    matchLabels:
      app: cfdc
  template:
    metadata:
      labels:
        app: cfdc
    spec:
      containers:
      - name: cfdc
        image: marklanfearnet/cfdc:latest
        volumeMounts:
        - name: cfdc
          mountPath: /etc/cfdc
          readOnly: true
      volumes:
      - name: cfdc
        secret:
          secretName: cfdc
```

## License

Distributed under the terms of the GNU General Public License v2
