## Synopsis

CloudFlare Dynamic DNS client

## Motivation

All the other CloudFlare DDNS clients I examined use the deprecated API v1. This script uses API v4.

Rather than using DNS to resolve the host, the CloudFlare API is queried for the IP. This allows the script to function with split-horizon DNS where the host resolves to an internal IP.

## Installation

https://github.com/mark-wagner/portage/tree/master/net-dns/cfdc/cfdc-9999.ebuild

Add =net-dns/cfdc-9999 \*\* to /etc/portage/package.keywords.

Create a configuration file (default is /etc/cfdc.conf). The format is JSON and these are the required keys:
* api\_key - CloudFlare API Key https://www.cloudflare.com/a/account/my-account -> Global API Key
* email - Email address associated with the zone
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

## License

Distributed under the terms of the GNU General Public License v2
