#!/bin/bash
# Script for handling errors during the backup process

# Load configuration variables from the backup configuration file
source /etc/borgmatic/backup_config.sh

# Function to log messages to the log file
log_message() {
    # Formats and writes messages to the log file defined in backup_config.sh
    echo "$(date '+%Y-%m-%d %H:%M:%S')-[$1]: $2" >> "$LOG_FILE"
}

# Log the occurrence of an error
log_message "ERROR" "Backup encountered an error"

# Prepare an email notification for the error
echo "Subject: BorgBackup Error" > email.txt
echo "An error occurred during the backup process. Check the log file for details." >> email.txt

# Send the email using msmtp
msmtp --file="$MSMTP_CONFIG" "$EMAIL_RECIPIENT" < email.txt
