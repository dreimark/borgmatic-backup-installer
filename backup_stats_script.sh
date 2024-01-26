#!/bin/bash
# Script to gather and send backup statistics

# Load configuration variables from the backup configuration file
source /etc/borgmatic/backup_config.sh

# Function to log messages to the log file
log_message() {
    # Formats and writes messages to the log file defined in backup_config.sh
    echo "$(date '+%Y-%m-%d %H:%M:%S')-[$1]: $2" >> "$LOG_FILE"
}

# Fetching system and backup information
current_date=$(date '+%Y-%m-%d')
hostname=$(hostname --fqdn)
ipv4_address=$(hostname -I | cut -d' ' -f1)
architecture=$(uname -m)
total_ram=$(free -h | grep "Mem:" | awk '{print $2}')
used_ram=$(free -h | grep "Mem:" | awk '{print $3}')
partition_table=$(lsblk -o NAME,FSTYPE,LABEL,SIZE,TYPE,MOUNTPOINT)
filesystem_details=$(df -hT | awk 'NR>1')

# Fetching and processing backup list from Borg repository
backup_list=$(borg list --format "{archive}{TAB}{start}{TAB}{time}{TAB}{size}{TAB}{duration}{NL}" "${BORG_REPO}")
total_backups=$(echo "$backup_list" | wc -l)
previous_size=0
backup_details=""

# Analyzing each backup and compiling details
echo "$backup_list" | while IFS=$'\t' read -r name start time size duration; do
    # Calculating size change and deduplication rate
    size_change="N/A"
    dedup_rate="N/A"
    if [ $previous_size -ne 0 ]; then
        size_change=$(echo "scale=2; (($size - $previous_size) / $previous_size) * 100" | bc)
        dedup_rate=$(echo "scale=2; (1 - ($size / $previous_size)) * 100" | bc)
    fi
    backup_details+="$name\n    Date: $start\n    Size: $size\n    Duration: $duration\n    Size Change: $size_change%\n    Deduplication Rate: $dedup_rate%\n\n"
    previous_size=$size
done

# Preparing email content with all the gathered information
email_subject="BorgBackup and System Stats - $current_date"
email_content="----- System Information -----\n"
email_content+="Hostname: $hostname\n"
email_content+="IPv4 Address: $ipv4_address\n"
email_content+="Architecture: $architecture\n"
email_content+="Total RAM: $total_ram\n"
email_content+="Used RAM: $used_ram\n\n"
email_content+="----- Partition Table -----\n$partition_table\n\n"
email_content+="----- Filesystem Details -----\n$filesystem_details\n\n"
email_content+="----- Backup Summary -----\n"
email_content+="Total Backups: $total_backups\n\n"
email_content+="----- Backup Details -----\n$backup_details"

# Saving the email content to a temporary file
echo -e "$email_content" > /tmp/email_content.txt

# Sending the email
echo "Subject: $email_subject" | cat - /tmp/email_content.txt | msmtp --file="$MSMTP_CONFIG" "$EMAIL_RECIPIENT"
