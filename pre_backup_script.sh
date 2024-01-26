#!/bin/bash
# pre_backup_script.sh - Pre-backup tasks

# Load configuration variables
source /etc/borgmatic/backup_config.sh

# Create a new log file for this run
LOG_FILE="$LOG_FILE_TEMPLATE"
touch "$LOG_FILE"

log_message() {
    echo "$(date '+%Y-%m-%d %H:%M:%S')-[$1]: $2" >> "$LOG_FILE"
}

# Mount the NAS to the specified mount point
# Uses NAS credentials and mount point from backup_config.sh
if mount -t cifs "//${NAS_IP}/${NAS_SHARE}" "${NAS_MOUNT}" -o vers=1.0,username="${NAS_USER}",password="${NAS_PASSWORD}"; then
    # Log success message
    log_message "INFO" "NAS mounted successfully"
else
    # Log error message and exit if mounting fails
    log_message "ERROR" "Failed to mount NAS"
    exit 1
fi

# Create a compressed disk image of the system drive
# Uses system drive path from backup_config.sh
# Saves the compressed image to the mounted NAS location
if dd if="${SYSTEM_DRIVE}" | gzip > "${NAS_MOUNT}/system_drive_backup.img.gz"; then
    # Log success message
    log_message "INFO" "Disk image created and compressed successfully"
else
    # Log error message if disk image creation fails
    log_message "ERROR" "Disk image creation failed"
fi
