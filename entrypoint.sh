#!/bin/bash

# Configure Git credentials
git config --global credential.helper 'cache --timeout=3600'
echo "url=$GIT_REPO_URL
username=$GIT_REPO_USERNAME
password=$GIT_REPO_PASSWORD" | git credential approve

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

# Check variables are set $PLAYBOOK_NAME $ANSIBLE_VAULT_KEY $CONTROLLER_HOST
# $CONTROLLER_USERNAME $CONTROLLER_PASSWORD
if [ -z "$PLAYBOOK_NAME" ] || [ -z "$ANSIBLE_VAULT_KEY" ] || [ -z "$CONTROLLER_HOST" ] || [ -z "$CONTROLLER_USERNAME" ] || [ -z "$CONTROLLER_PASSWORD" ]; then
    echo "One or more required variables are not set. Exiting. PLAYBOOK_NAME, ANSIBLE_VAULT_KEY, CONTROLLER_HOST, CONTROLLER_USERNAME, CONTROLLER_PASSWORD are required."
    exit 1
fi

# Print CONTROLLER_HOST
echo "CONTROLLER_HOST: $CONTROLLER_HOST"

# Run Ansible playbook
ansible-playbook -i inventory $PLAYBOOK_NAME --vault-password-file <(echo $ANSIBLE_VAULT_KEY)
