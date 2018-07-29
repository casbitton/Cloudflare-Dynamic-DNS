# Cloudflare Dynamic DNS

Dynamic IP? No Problem! *Keep your Domains in check!*

Quickly update DNS records for one or many domains names to the current external public IP address.

Perfect for any HomeLab, SelfHosted web server, RaspberryPi, NGINX reverse proxy servers and whatever else you want to host.

### *Backup your Cloudflare DNS configuration before blindly using these tools!*

---

## Usage

Edit `UpdateAll.sh` or `UpdateSingle.sh` and fill in the required info:

~~~
# CloudFlare Account Details
auth_email="EMAILADDRESS"
auth_key="AUTHKEY"
~~~

`UpdateAll.sh` - Multiple domains can be bulk updated, define them here.
~~~
zone_names=("DOMAINNAME.COM" "DOMAINNAME2.COM" "DOMAINNAME3.COM")
~~~

`UpdateSingle.sh` - A single domain you want to manage.
~~~
zone_name="DOMAINNAME.COM"
~~~

Nice work, Let's do it 👍

---

## Update All Domains ⚡

Perhaps you have a dozen SelfHosted domains and sub domains, Update All is for you! All records attached to the domain will be updated to the current external IP address. It couldn't be easier!

~~~
./UpdateAll.sh

[Tuesday 10 July  21:44:47 ACST 2018] - Checking domain.com
[Tuesday 10 July  21:44:50 ACST 2018] - No Update Required: domain.com is 1.1.1.1
[Tuesday 10 July  21:44:51 ACST 2018] - No Update Required: taco.domain.com is 1.1.1.1
[Tuesday 10 July  21:44:53 ACST 2018] - No Update Required: www.domain.com is 1.1.1.1
[Tuesday 10 July  21:44:54 ACST 2018] - Checking domain2.com
[Tuesday 10 July  21:44:55 ACST 2018] - No Update Required: domain2.com is 1.1.1.1
[Tuesday 10 July  21:44:56 ACST 2018] - No Update Required: hotdog.domain2.com is 1.1.1.1
[Tuesday 10 July  21:44:56 ACST 2018] - No Update Required: www.domain2.com is 1.1.1.1
[Tuesday 10 July  21:44:57 ACST 2018] - All Done!
~~~

## Party! 🎉🎈🕺🧙‍

---

## Update a Single Subdomain 🌮

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

---

### Now Supercharge your life with Cron 😎
~~~
# Check and update domain.com and domain2.com each hour
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

---

##### Official Cloudflare API documentation v4
- https://api.cloudflare.com
