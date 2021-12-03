#!/bin/bash

# Dynamic DNS for CF
# If you SelfHost your domain, or multiple sub domains from home let's update everything!

# CloudFlare Account Details
auth_email="EMAILADDRESS"
auth_key="AUTHKEY"
zone_names=("DOMAINNAME.COM" "DOMAINNAME2.COM" "DOMAINNAME3.COM")

# Quick check to ensure you have updated the config above.
if [ $auth_key = "AUTHKEY" ] 
then
    echo "[$(date)] - Oops! Please fill in the CloudFlare Account Details"
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

for zone_name in "${zone_names[@]}"
do

    echo "[$(date)] - Checking $zone_name"

    # Get Zone ID
    zone_identifier=$(curl -s -X GET "https://api.cloudflare.com/client/v4/zones?name=$zone_name" -H "X-Auth-Email: $auth_email" -H "Authorization: Bearer $auth_key" -H "Content-Type: application/json" | grep -Po '(?<="id":")[^"]*' | head -1 )

    # Check for Record Entry
    record_exists=$(curl -s -X GET "https://api.cloudflare.com/client/v4/zones/$zone_identifier/dns_records" -H "X-Auth-Email: $auth_email" -H "Authorization: Bearer $auth_key" -H "Content-Type: application/json"  | grep -Po '(?<="id":")[^"]*' | head -1)

    if [ -z "$record_exists" ]
    then
        echo "[$(date)] - No Entry's for Zone: $zone_name"
        exit
    fi

    # Get All Records
    all_records=$(curl -s -X GET "https://api.cloudflare.com/client/v4/zones/$zone_identifier/dns_records" -H "X-Auth-Email: $auth_email" -H "Authorization: Bearer $auth_key" -H "Content-Type: application/json"  | grep -Po '(?<="name":")[^"]*')

    while read -r record_name
    do

        # Get Assigned IP
        record_ip=$(curl -s -X GET "https://api.cloudflare.com/client/v4/zones/$zone_identifier/dns_records?name=$record_name" -H "X-Auth-Email: $auth_email" -H "Authorization: Bearer $auth_key" -H "Content-Type: application/json"  | grep -Po '(?<="content":")[^"]*')

        # Get Record ID
        record_identifier=$(curl -s -X GET "https://api.cloudflare.com/client/v4/zones/$zone_identifier/dns_records?name=$record_name" -H "X-Auth-Email: $auth_email" -H "Authorization: Bearer $auth_key" -H "Content-Type: application/json"  | grep -Po '(?<="id":")[^"]*')

        if [ "$ip" = "$record_ip" ] 
        then
        echo "[$(date)] - No Update Required: $record_name is $record_ip"
        continue
        else
        echo "[$(date)] - Update Required: $record_name points to $record_ip"
        fi

        # Update Record
        echo "[$(date)] - Updating $record_name to $ip"

        update=$(curl -s -X PUT "https://api.cloudflare.com/client/v4/zones/$zone_identifier/dns_records/$record_identifier" -H "X-Auth-Email: $auth_email" -H "Authorization: Bearer $auth_key" -H "Content-Type: application/json" --data "{\"id\":\"$zone_identifier\",\"type\":\"A\",\"name\":\"$record_name\",\"content\":\"$ip\",\"proxied\":true}")

    done <<< "$all_records"

done

echo "[$(date)] - All Done!"

exit
