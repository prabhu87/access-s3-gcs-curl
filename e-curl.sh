#!/bin/bash

# checking env. variable
echo $req_path
echo $bucket_name
echo $secret
echo $s3_key

# We need the current date to calculate the signature and also to pass to S3/GCS
curr_date=`date +'%a, %d %b %Y %H:%M:%S %z'`

# This is the name of your S3/GCS bucket

string_to_sign="GET\n\n\n${curr_date}\n/${bucket_name}${req_path}"

# We will now calculate the signature to be sent as a header.
signature=$(echo -en "${string_to_sign}" | openssl sha1 -hmac "${secret}" -binary | base64)

curl -v -H "Host: ${bucket_name}.s3.amazonaws.com" \
        -H "Date: $curr_date" \
        -H "Authorization: AWS ${s3_key}:${signature}" \
         "https://${bucket_name}.s3.amazonaws.com${req_path}" --compress
