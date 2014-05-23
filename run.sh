#!/bin/bash -e

# Generate a new SSH private-public key pair.
rm -f dx_ssh_key*
ssh-keygen -t dsa -f dx_ssh_key -N ''

USER=$(dx whoami)
echo "Setting the public key for $USER..."
dx api user-$USER update "{\"SSHPublicKey\": \"$(cat dx_ssh_key.pub)\"}"

# Build and run the applet, setting the allowSSH parameter to the addresses of the hosts to open the SSH port to.
JOB_ID=$(dx build -f --run --yes --extra-args '{"allowSSH": ["*"]}' --brief)
#JOB_ID=$(dx build -f --run --yes --brief)
echo "Waiting for $JOB_ID to start..."

HOST=null
while [[ $HOST == null ]]; do
    HOST=$(dx describe $JOB_ID --json | jq --raw-output .host)
    sleep 5
    echo -n "."
done
echo
echo "Job $JOB_ID is running on $HOST. Connecting..."
while true; do
    if ssh -i dx_ssh_key -o strictHostKeyChecking=no -o ConnectTimeout=2 dnanexus@$HOST; then break; fi
done
