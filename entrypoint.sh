#!/bin/bash

# Configure Git credentials
git config --global credential.helper 'cache --timeout=3600'
echo "url=$GIT_REPO_URL
username=$GIT_USERNAME
password=$GIT_PASSWORD" | git credential approve

# Check out the Git repository into a directory named "tmp-repo"
git clone $GIT_REPO_URL /tmp-repo

# Exit if clone fails
if [ $? -ne 0 ]; then
    echo "Git clone failed. Exiting."
    exit 1
fi

# Change to the cloned repository directory
cd /tmp-repo

# Exit if cd fails
if [ $? -ne 0 ]; then
    echo "Failed to change directory to /tmp-repo. Exiting."
    exit 1
fi

# Run Ansible playbook
ansible-playbook -i inventory $PLAYBOOK_NAME --vault-password-file <(echo $ANSIBLE_VAULT_KEY)
