#!/bin/bash

# Path to your test file
req_path="/filename"

# We need the current date to calculate the signature and also to pass to GCS
curr_date=`date +'%a, %d %b %Y %H:%M:%S %z'`

# This is the name of your GCS bucket
bucket_name="yourbucket_name"
string_to_sign="GET\n\n\n${curr_date}\n/${bucket_name}${req_path}"

# Your secret
secret="xxxxxxxxxxxxxxxxxxxxxx"

# Your key
key="XXXXXXXXXXXXXXXXXXXXXXX"

# We will now calculate the signature to be sent as a header.
signature=$(echo -en "${string_to_sign}" | openssl sha1 -hmac "${secret}" -binary | base64)

# That's all we need. Now we can make the request as follows.

# GCS Curl
curl -v -H "Host: ${bucket_name}.storage.googleapis.com" \
        -H "Date: $curr_date" \
        -H "Authorization: AWS ${key}:${signature}" \
         "https://${bucket_name}.storage.googleapis.com${req_path}" --compress
