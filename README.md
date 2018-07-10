# Cloudflare-Dynamic-DNS

Dynamic IP? No Problem!

Quickly update a single or All DNS records in a flash using the Cloudflare v4 API.

Perfect for that spare RaspberryPi, NGINX reverse proxy servers and more. Keep your Domains in check.

### *Backup your Cloudflare DNS configuration before blindly using these tools!*

---

## Usage

Edit UpdateAll.sh or UpdateSingle.sh and fill in the required info:

~~~
# CloudFlare Account Details
auth_email="EMAIL ADDRESS"
auth_key="AUTHKEY"
zone_name="DOMAINNAME.COM"
~~~

Nice work, Let's do it 👍

---

## Update a Single Domain 🌮

With your `zone_name` defined as domain.com, Update the IP for taco.domain.com to the current external IP address.

~~~

./UpdateSingle.sh taco

~~~

Review the output 🐄

**Update Required**

~~~
./UpdateSingle.sh taco

[Tuesday 10 July  21:31:07 ACST 2018] - Checking taco.domain.com
[Tuesday 10 July  21:31:15 ACST 2018] - Update Required: taco.domain.com points to 2.2.2.2
[Tuesday 10 July  21:31:15 ACST 2018] - Updating taco.domain.com to 1.1.1.1
[Tuesday 10 July  21:31:15 ACST 2018] - All Done!
~~~

**No Update Required**
~~~
./UpdateSingle.sh taco

[Tuesday 10 July  21:37:23 ACST 2018] - Checking taco.domain.com
[Tuesday 10 July  21:37:25 ACST 2018] - No Update Required: taco.domain.com is 1.1.1.1
~~~

## Update All Domains ⚡

Perhaps you have a dozen sub domains, Update All is for you! All records attached to the zone will be updated.

~~~
./UpdateAll.sh

[Tuesday 10 July  21:44:47 ACST 2018] - Checking domain.com
[Tuesday 10 July  21:44:50 ACST 2018] - No Update Required: domain.com is 1.1.1.1
[Tuesday 10 July  21:44:51 ACST 2018] - No Update Required: taco.domain.com is 1.1.1.1
[Tuesday 10 July  21:44:53 ACST 2018] - No Update Required: www.domain.com is 1.1.1.1
[Tuesday 10 July  21:44:53 ACST 2018] - All Done!
~~~


## Party! 🎉🎈🕺🧙‍


### Now Supercharge your life with Cron 😎
~~~
# Check and update domain.com each hour
0 * * * * /home/sushi/UpdateAll.sh
~~~

---

### HELP THE WHEELS FELL OFF

*If the wheels fall off, don't forget to make the script executable!*

`chmod +x UpdateAll.sh`

### No External IP Address?

Hmmm, Amazon has closed it's doors? Update the IP check from https://checkip.amazonaws.com to an alternative location.

- https://ipinfo.io/ip
- https://icanhazip.com


### Mac OS?
You are unfortunately missing a few key features from `grep`!

Update `grep` with [Homebrew](https://brew.sh "Brew") 😇

```
brew install grep --with-default-names
grep --version
grep (GNU grep) 3.1
Packaged by Homebrew
```

Give it another whirl 👌


### Updating Multiple Zones?
Clone the repo a few more times for each domain. Each Zone will require it's own API details, best to keep it separate and make life easier.

---

##### Official Cloudflare API documentation v4
- https://api.cloudflare.com
