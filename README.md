## Synopsis

CloudFlare Dynamic DNS client

## Motivation

All the other CloudFlare DDNS clients I examined use the deprecated API v1. This script uses API v4.

Rather than using DNS to resolve the host, the CloudFlare API is queried for the IP. This allows the script to function with split-horizon DNS where the host resolves to an internal IP.

## Installation

**I use (rootless) podman now so only the format of /etc/cfdc/cfdc.conf is documented here.**

However, I use `podman build --tag quay.io/mark/cfdc .` which is probably simple-minded and wrong.

`cfdc.container` goes in `~/.config/containers/systemd/cfdc.container`. Then run `systemctl --user daemon-reload`.

Create a configuration file (default is /etc/cfdc/cfdc.conf). The format is JSON and these are the required keys:
* api\_token - CloudFlare API Key https://www.cloudflare.com/a/account/my-account -> Global API Key
* email - Email address associated with the zone
* name - host name you want to update
* zone - zone (domain) you want to update

Optional keys:
* sleep - interval in seconds to sleep between checks
* ip\_urls - list of URLs that return the IP and only the IP in plain text
* endpoint - CloudFlare API endpoint
* ttl - time to live of entry

I push images to https://quay.io/repository/markw/cfdc

## License

Distributed under the terms of the GNU General Public License v2
