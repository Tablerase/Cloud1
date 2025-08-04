#!/bin/sh

# Default number of instances
DEFAULT_INSTANCES=1
NUM_INSTANCES=${1:-$DEFAULT_INSTANCES}

# Validate input
if ! echo "$NUM_INSTANCES" | grep -E '^[1-9][0-9]*$' > /dev/null; then
  echo "Error: Number of instances must be a positive integer."
  exit 1
fi

# Generate instance names
instance_names=$(seq -f "wp%g" 1 "$NUM_INSTANCES")

# Launching local Ubuntu instances
echo "Launching $NUM_INSTANCES Ubuntu instances..."
for instance in $instance_names; do
  echo "Launching $instance..."
  multipass launch 22.04 --name "$instance" --memory 2G --disk 10G
done

# Check the status of the instances
multipass list

# Generate a dedicated SSH key for Ansible if it doesn't exist
if [ ! -f ~/.ssh/multipass_ansible ]; then
  ssh-keygen -t rsa -b 4096 -f ~/.ssh/multipass_ansible -N "" -q
fi

# Inject public key into each instance
echo "Injecting public key into instances..."
for instance in $instance_names; do
  multipass exec "$instance" -- bash -c 'mkdir -p ~/.ssh && chmod 700 ~/.ssh'
  cat ~/.ssh/multipass_ansible.pub | multipass exec "$instance" -- bash -c 'cat >> ~/.ssh/authorized_keys && chmod 600 ~/.ssh/authorized_keys'
done
echo "Public key injected into instances."

# Generate Ansible YAML inventory
echo "Generating Ansible YAML inventory..."
inventory_file="inventory/inventory.yml"
mkdir -p "$(dirname "$inventory_file")"

# Start inventory file
cat > "$inventory_file" <<EOF
all:
  hosts:
EOF

# Append each host to the inventory
for instance in $instance_names; do
  ip=$(multipass info "$instance" | awk '/IPv4/ {print $2}')
  cat >> "$inventory_file" <<EOF
    $instance:
      ansible_host: $ip
      ansible_user: ubuntu
      ansible_ssh_private_key_file: ~/.ssh/multipass_ansible
EOF
done

echo "Ansible YAML inventory generated at $inventory_file"
