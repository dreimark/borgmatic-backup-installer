#!/bin/bash
# Post-backup tasks script

# Load configuration variables from the backup configuration file
source /etc/borgmatic/backup_config.sh

# Function to log messages to the log file
log_message() {
    # Formats and writes messages to the log file defined in backup_config.sh
    echo "$(date '+%Y-%m-%d %H:%M:%S')-[$1]: $2" >> "$LOG_FILE"
}

# Unmount the NAS from the specified mount point
# Uses NAS mount point from backup_config.sh
if umount "${NAS_MOUNT}"; then
    # Log success message if unmounting is successful
    log_message "INFO" "NAS unmounted successfully"
else
    # Log error message if unmounting fails
    log_message "ERROR" "Failed to unmount NAS"
fi
