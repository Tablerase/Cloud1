#!/bin/bash

# Find all Multipass VMs with names starting with "wp"
VMS=$(multipass list --format csv | tail -n +2 | cut -d, -f1 | grep "^wp")

for vm in $VMS; do
    # Stop the VM if it is running
    if multipass info "$vm" --format csv | tail -n +2 | cut -d, -f2 | grep -q "Running"; then
        echo "Stopping ${vm}..."
        multipass stop "${vm}"
    fi

    # Delete the VM
    echo "Deleting ${vm}..."
    multipass delete "${vm}"
done

# Remove the local Multipass VMs
echo "Purging all deleted VMs..."
multipass purge

echo "Cleanup complete."
