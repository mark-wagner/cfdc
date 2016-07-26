## Synopsis

CloudFlare Dynamic DNS client

## Motivation

All the other CloudFlare DDNS clients I examined use the deprecated API v1. This script uses API v4.

## Installation

https://github.com/mark-wagner/portage/tree/master/net-dns/cfdc/cfdc-9999.ebuild

Create a configuration file (default is /etc/cfdc.conf). The format is JSON and these are the required keys:
* api_key - CloudFlare API Key https://www.cloudflare.com/a/account/my-account -> Global API Key
* email - Email address associated with the zone
* name - host name you want to update
* zone - zone (domain) you want to update

Optional keys:
* sleep - interval in seconds to sleep between checks
* ip_urls - list of URLs that return the IP and only the IP in plain text
* endpoint - CloudFlare API endpoint
* ttl - time to live of entry

To have the script start at boot run `rc-update add cfdc default`. The provided init script is for OpenRC. Adapt for your favorite init system. :)

## License

Distributed under the terms of the GNU General Public License v2
