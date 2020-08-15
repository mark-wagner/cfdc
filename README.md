## Synopsis

CloudFlare Dynamic DNS client

## Motivation

All the other CloudFlare DDNS clients I examined use the deprecated API v1. This script uses API v4.

Rather than using DNS to resolve the host, the CloudFlare API is queried for the IP. This allows the script to function with split-horizon DNS where the host resolves to an internal IP.

## Installation

### Config File Creation

Create an API Token from cloudflare, you can do this at https://dash.cloudflare.com/profile/api-tokens. Click the "Create Token" button, and create a token as follows

- Click the Get Started button at the option "Create Custom Token"
- Give your token a name
- In the permissions block, select "Zone" in the first dropdown, then select "Zone" in the second dropdown, and then select "Edit" in the third dropdown.
- Click the "+ Add more" option.
- Add another Permission block, select "Zone" in the first dropdown, then select "DNS" in the second dropdown and then select "Edit" in the third dropdown.
- In the "Zone Resources" section, select the Zone you wish to modify, for example if the domain you want to update is "blah.domain", then in the first dropdown select "Include", and then in the second dropdown, select "Specific zone", and in the third dropdown that appears, find your "blah.domain" and select that.
- If you want to add additional "Zone Resources", use the "+ Add more" button to add them.
- You can select IP Address Filtering as required, but this won't be covered here.
- In the TTL section, set a start and end date for your token.
- Once completed, click the Continue to Summary.
- Ensure the Summary reflects that you have your specific DNS Zone (for example blah.domain), and the permissions: "Zone:Edit, DNS:Edit"
- Make a note of when your token expires (the End Date), your token will cease to function after that and you will need to create a new one.
- If everything looks correct, then click the "Create Token" button.
- In the page that appears, run the code (curl request) shown in the "Test this token" to ensure that your token is working, and ensure that you copy the token and save it somewhere secure. TAKE GREAT CARE HERE, ANYONE WITH THIS TOKEN CAN UPDATE YOUR SPECIFIC DOMAIN.
- Now you can create the cfdc.conf file that will be used by the docker container.

```
{
    "api_token": "CLOUDFLARE_API_TOKEN_FOR_SPECIFIC_ZONE",
    "name": "HOST_YOU_WANT_TO_UPDATE",
    "zone": "DNS_ZONE_OR_DOMAIN_YOU_WANT_TO_UPDATE"
}
```

Save the config file in a place that is accessible by the docker container that you will create in the next step.

### Docker

Firstly, clone the repository. Do this on the machine you will be running the cloudflare DDNS updater (or you can create the image elsewhere and push it to a public/private repository, but that is outside the scope of this documentation).

Now you can build the container image, be sure you in the directory that you have just cloned the repository into. You can double check that you are in the correct directory by ensuring that you have a "Dockerfile" in the directory that you are in.

```
$ docker build . -t <image_tag>
```

(Be sure to replace <image_tag> with an image tag of your choosing. You can tag it with any name if you want, just be sure that you use the same <image_tag> in the command below)

Once that has completed, you can deploy the image:

```
$ docker run -d -v <full_path_of_folder_containing_your_config_file>:/etc/cfdc/cfdc.conf --name <the_name_that_you_will_give_to_your_container> <image_tag>
```

As an example, if your config file is in **/etc/working/cfdc.conf**, you want to call your containter **my_cloudflare_updater** and your image built above was tagged **cf_updater**, then your command to start the container would be:

```
$ docker run -d -v /etc/working/cfdc.conf:/etc/cfdc/cfdc.conf --name my_cloudflare_updater cf_updater:latest
```

Once this is done, you can view the logs by using the following commands (example container name as per the example above, please replace with whatever you've called your container.)

```
$ docker logs -f my_cloudflare_updater
```

This will tail the container logs. The container will continue to update approximately ever 300s (5mins). (This will be user configurable in a future update).

You can then examine your Cloudflare dashboard and you should see your public IP (or the public IP of the machine running the container), on the specific host for the zone you are updating.

### Gentoo

https://github.com/mark-wagner/portage/tree/master/net-dns/cfdc/cfdc-9999.ebuild

Add =net-dns/cfdc-9999 \*\* to /etc/portage/package.keywords.

Create a configuration file (default is /etc/cfdc.conf). The format is JSON and these are the required keys:

- api_token - cloudflare api token with Zone.Zone, Zone.DNS permissions
- name - host name you want to update
- zone - zone (domain) you want to update

Optional keys:

- sleep - interval in seconds to sleep between checks
- ip_urls - list of URLs that return the IP and only the IP in plain text
- endpoint - CloudFlare API endpoint
- ttl - time to live of entry

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
containers: - name: cfdc
image: marklanfearnet/cfdc:latest
volumeMounts: - name: cfdc
mountPath: /etc/cfdc
readOnly: true
volumes: - name: cfdc
secret:
secretName: cfdc

```

## License

Distributed under the terms of the GNU General Public License v2

```

```
