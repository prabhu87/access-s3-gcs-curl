#!/bin/bash

# Path to your test file
req_path="/filename"

# We need the current date to calculate the signature and also to pass to S3
curr_date=`date +'%a, %d %b %Y %H:%M:%S %z'`

# This is the name of your S3 bucket
bucket_name="yourbucket"
string_to_sign="GET\n\n\n${curr_date}\n/${bucket_name}${req_path}"

# Your secret
secret="xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"

# Your S3 key
s3_key="XXXXXXXXXXXXXXXXXXXXXXX"

# We will now calculate the signature to be sent as a header.
signature=$(echo -en "${string_to_sign}" | openssl sha1 -hmac "${secret}" -binary | base64)

# S3
curl -v -H "Host: ${bucket_name}.s3.amazonaws.com" \
        -H "Date: $curr_date" \
        -H "Authorization: AWS ${s3_key}:${signature}" \
         "https://${bucket_name}.s3.amazonaws.com${req_path}" --compress
