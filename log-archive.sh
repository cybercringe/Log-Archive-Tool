#!/bin/bash

# Check if the user provided the log directory
if [ $# -ne 1 ]; then
    echo "Usage: $0 <log-directory>"
    exit 1
fi

LOG_DIR=$1
ARCHIVE_DIR="./archived-logs"
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
ARCHIVE_FILE="logs_archive_${TIMESTAMP}.tar.gz"
LOG_FILE="./archive_log.txt"

# Ensure the log directory exists
if [ ! -d "$LOG_DIR" ]; then
    echo "Error: Log directory '$LOG_DIR' does not exist."
    exit 1
fi

# Create the archive directory if it doesn't exist
mkdir -p $ARCHIVE_DIR

# Compress the logs (ignore file changes and failed reads)
tar --warning=no-file-changed --ignore-failed-read -czf "${ARCHIVE_DIR}/${ARCHIVE_FILE}" -C "$LOG_DIR" .

# Check if the tar command was successful
if [ $? -eq 0 ]; then
    echo "Logs successfully archived to ${ARCHIVE_DIR}/${ARCHIVE_FILE}"
    echo "$(date +"%Y-%m-%d %H:%M:%S") - Archived logs to ${ARCHIVE_DIR}/${ARCHIVE_FILE}" >> $LOG_FILE
else
    echo "Error: Failed to archive logs."
    exit 1
fi
