
# Borgmatic Backup System

## Overview

This Borgmatic backup system automates creating secure and efficient backups of your system using BorgBackup. It includes features like pre- and post-backup operations, detailed backup statistics, error handling, and email notifications. The preferred setup method is via an installation script, though traditional and Docker-based setups are also supported.

## Features

-   **Automated BorgBackup Management:** Utilizes Borgmatic for managing BorgBackup operations.
-   **Pre- and Post-Backup Scripts:** Custom scripts for tasks like NAS mounting and disk image creation.
-   **Backup Statistics and Email Notifications:** Generates detailed reports and alerts for backup activities and errors.
-   **Flexible Deployment:** Supports script-based installation, traditional, and Docker-based setups.
-   **Systemd Integration:** Scheduled backups using systemd timers.

## Getting Started

### Prerequisites

-   Debian-based system or Docker environment.
-   NAS or other storage for backups.
-   Email account for notifications (configured with `msmtp`).

### Installation Using Script (Preferred Method)

1.  **Run the `borgmatic-backup.sh` Script:**
    -   Place all configuration files and scripts in the same directory as `borgmatic-backup.sh`.
    -   Run the script: `sudo bash borgmatic-backup.sh`.
    -   The script will install all necessary components, set up the system, and schedule the backups.

### Traditional Installation

1.  **Install Dependencies:**
    
    bashCopy code
    
    `sudo apt update sudo apt install borgmatic borgbackup msmtp gzip mailutils`
    
2.  **Setup Scripts and Configuration:**
    
    -   Copy configuration files and scripts to `/etc/borgmatic/`.
    -   Make scripts executable: `sudo chmod +x /etc/borgmatic/*.sh`.
3.  **Configure Email Notifications:**
    
    -   Setup `.msmtprc` in the home directory of the backup user.
4.  **Schedule Backups:**
    
    -   Use systemd or cron to schedule backups.

### Usage

-   Backups will run automatically as per the configured schedule.
-   Check emails for backup reports and error notifications.

## Support

For issues or questions, refer to the Borgmatic and BorgBackup documentation, or consult the community forums of your Debian-based distribution or Docker environment.