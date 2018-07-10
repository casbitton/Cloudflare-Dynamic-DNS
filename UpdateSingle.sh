#!/bin/bash

# Dynamic DNS for CF!
# Perfect for updating a single sub domain

# Get a record name from the command line e.g: Update.sh taco ; This will update taco.domain.com
name=$1
if [ -z "$name" ]
then
echo "[$(date)] - Record Name Missing, e.g: Update.sh taco ; This will update taco.domain.com"
      exit
fi

# Get IP Address
# If Amazon ever retire this service checkout https://ipinfo.io/ip or https://icanhazip.com
ip=$(curl -s https://checkip.amazonaws.com)

if [ -z "$ip" ]
then
    echo "[$(date)] - Oops! We can't find an external IP address"
    exit
fi

# CloudFlare Account
auth_email="EMAIL ADDRESS"
auth_key="AUTHKEY"
zone_name="DOMAINNAME.COM"

# Match the Name to our Zone
record_name="$name.$zone_name"

echo "[$(date)] - Checking $record_name"

# Get Zone ID
zone_identifier=$(curl -s -X GET "https://api.cloudflare.com/client/v4/zones?name=$zone_name" -H "X-Auth-Email: $auth_email" -H "X-Auth-Key: $auth_key" -H "Content-Type: application/json" | grep -Po '(?<="id":")[^"]*' | head -1 )

# Check for Record Entry
record_exists=$(curl -s -X GET "https://api.cloudflare.com/client/v4/zones/$zone_identifier/dns_records?name=$record_name" -H "X-Auth-Email: $auth_email" -H "X-Auth-Key: $auth_key" -H "Content-Type: application/json"  | grep -Po '(?<="id":")[^"]*')

if [ -z "$record_exists" ]
then
    echo "[$(date)] - No Entry for Record: $record_name"
    exit
fi

# Get Record ID
record_identifier=$(curl -s -X GET "https://api.cloudflare.com/client/v4/zones/$zone_identifier/dns_records?name=$record_name" -H "X-Auth-Email: $auth_email" -H "X-Auth-Key: $auth_key" -H "Content-Type: application/json"  | grep -Po '(?<="id":")[^"]*')

# Get Assigned IP
record_ip=$(curl -s -X GET "https://api.cloudflare.com/client/v4/zones/$zone_identifier/dns_records?name=$record_name" -H "X-Auth-Email: $auth_email" -H "X-Auth-Key: $auth_key" -H "Content-Type: application/json"  | grep -Po '(?<="content":")[^"]*')

if [ "$ip" = "$record_ip" ] 
then
  echo "[$(date)] - No Update Required: $record_name is $record_ip"
  exit
else
  echo "[$(date)] - Update Required: $record_name points to $record_ip"
fi

# Update Record
echo "[$(date)] - Updating $record_name to $ip"

update=$(curl -s -X PUT "https://api.cloudflare.com/client/v4/zones/$zone_identifier/dns_records/$record_identifier" -H "X-Auth-Email: $auth_email" -H "X-Auth-Key: $auth_key" -H "Content-Type: application/json" --data "{\"id\":\"$zone_identifier\",\"type\":\"A\",\"name\":\"$record_name\",\"content\":\"$ip\",\"proxied\":true}")

echo "[$(date)] - All Done!"

exit
