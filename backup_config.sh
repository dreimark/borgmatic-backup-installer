#!/bin/bash
# Backup configuration variables

# Borgmatic repository path
BORG_REPO="/mnt/nas/borgbackup"

# Log file path template (directory must exist)
LOG_DIR="/var/log/BAK"
LOG_TIMESTAMP=$(date '+%Y-%m-%d_%H-%M-%S')
LOG_FILE_TEMPLATE="$LOG_DIR/$(hostname)-backup-$LOG_TIMESTAMP.log"

# Network Attached Storage (NAS) Configuration
# IP address or hostname of the NAS
NAS_IP="NAS_IP"
# Name of the shared folder on the NAS
NAS_SHARE="Share"
# Local mount point for the NAS
NAS_MOUNT="/mnt/nas"
# NAS username for access
NAS_USER="NAS_User"
# NAS password for access
NAS_PASSWORD="NAS_Password"

# Email configuration for sending notifications
# Recipient email address for notifications
EMAIL_RECIPIENT="your-recipient@example.com"
# Path to the msmtp configuration file
MSMTP_CONFIG="/path/to/.msmtprc"

# System drive configuration
# Path to the system drive for creating disk images
SYSTEM_DRIVE="/dev/sda"

# Space management configuration
# Minimum free space threshold for backup in bytes (e.g., 10 GB)
MIN_FREE_SPACE=10000000000  
