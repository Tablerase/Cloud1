mkdir -p keys
# Generate SSH key pair for Ansible
## -t : Type of key to create (ed25519, rsa, etc.)
## -C : Comment for the key
## -f : File to save the key
## -N : Passphrase for the key (empty in this case)
ssh-keygen -t ed25519 -f keys/ansible_key -N "" -C "ansible_key"