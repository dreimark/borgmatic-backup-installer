#!/bin/bash
# borgmatic-backup.sh - Script to install and configure the Borgmatic backup system

# Define the user who invoked sudo
BACKUP_USER=${SUDO_USER:-$(whoami)}

# Configuration: Adjust these variables as needed
SOURCE_DIR=$(pwd)  # Directory containing your Borgmatic files
BORGMATIC_CONFIG_DIR="/etc/borgmatic"
BORGMATIC_SCRIPT_DIR="/etc/borgmatic"
MSMTP_CONFIG_DIR="/home/$BACKUP_USER"

echo "Building the Borgmatic Docker image: $DOCKER_IMAGE_NAME..."

# Update and install required packages
echo "Installing required packages..."
sudo apt update
sudo apt install -y borgmatic borgbackup msmtp gzip mailutils

# Set the actual hostname as a prefix in config.yaml
HOSTNAME=$(hostname)
sed -i "s/hostname-/${HOSTNAME}-/" "$SOURCE_DIR/config.yaml"

# Create necessary directories
echo "Creating Borgmatic and log directories..."
sudo mkdir -p "$BORGMATIC_CONFIG_DIR"
sudo mkdir -p "/var/log/BAK"

# Copy configuration files and scripts
echo "Copying Borgmatic configuration files and scripts..."
sudo cp "$SOURCE_DIR/config.yaml" "$BORGMATIC_CONFIG_DIR/config.yaml"
sudo cp "$SOURCE_DIR/backup_config.sh" "$BORGMATIC_SCRIPT_DIR/backup_config.sh"
sudo cp "$SOURCE_DIR/pre_backup_script.sh" "$BORGMATIC_SCRIPT_DIR/pre_backup_script.sh"
sudo cp "$SOURCE_DIR/post_backup_script.sh" "$BORGMATIC_SCRIPT_DIR/post_backup_script.sh"
sudo cp "$SOURCE_DIR/backup_stats_script.sh" "$BORGMATIC_SCRIPT_DIR/backup_stats_script.sh"
sudo cp "$SOURCE_DIR/error_handling_script.sh" "$BORGMATIC_SCRIPT_DIR/error_handling_script.sh"

# Set file permissions for scripts and configuration
echo "Setting file permissions..."
sudo chmod 600 "$BORGMATIC_CONFIG_DIR/config.yaml"
sudo chmod 700 "$BORGMATIC_SCRIPT_DIR"/*.sh

# Configure .msmtprc for email notifications if it exists
if [ -f "$SOURCE_DIR/.msmtprc" ]; then
    echo "Configuring .msmtprc for msmtp..."
    sudo cp "$SOURCE_DIR/.msmtprc" "$MSMTP_CONFIG_DIR/.msmtprc"
    sudo chown $BACKUP_USER:$BACKUP_USER "$MSMTP_CONFIG_DIR/.msmtprc"
    sudo chmod 600 "$MSMTP_CONFIG_DIR/.msmtprc"
else
    echo "WARNING: .msmtprc file not found in the source directory. Please configure manually."
fi

# Print completion message
echo "Borgmatic backup system installation completed successfully."
