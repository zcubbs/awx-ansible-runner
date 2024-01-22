#!/bin/bash

# Configure Git credentials
git config --global credential.helper 'cache --timeout=3600'
echo "url=$GIT_REPO_URL
username=$GIT_REPO_USERNAME
password=$GIT_REPO_PASSWORD" | git credential approve

# Check out the Git repository
git clone "$GIT_REPO_URL"
"cd $(basename "$GIT_REPO_URL")"

# Run Ansible playbook
ansible-playbook -i inventory "$PLAYBOOK_NAME" --vault-password-file <(echo "$ANSIBLE_VAULT_KEY")
