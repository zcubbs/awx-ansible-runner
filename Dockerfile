FROM python:3.9-slim

# Set the working directory in the container
WORKDIR /usr/src/app

# Install Ansible and Git and remove the cache after installation
RUN apt-get update && \
    apt-get install -y git && \
    pip install ansible \
    && rm -rf /var/lib/apt/lists/* \
    && apt-get clean -y

# Copy the entrypoint script into the container
COPY entrypoint.sh /usr/src/app

# Make the entrypoint script executable
RUN chmod +x /usr/src/app/entrypoint.sh

# Set the entrypoint script to run when the container starts
ENTRYPOINT ["/usr/src/app/entrypoint.sh"]
