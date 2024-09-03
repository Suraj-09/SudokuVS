#!/bin/bash

# Define variables
TARGET_DIR="./Server/deploy"
BIN_DIR="./Server/build/Desktop_Qt_6_7_2-Debug/"
SSH_KEY_PATH="~/.ssh/ssh-key-2024-07-30.key"
REMOTE_SERVER="ubuntu@168.132.89.52"
REMOTE_PATH="/home/ubuntu/code/"

# Run cqtdeployer
cqtdeployer -targetDir "$TARGET_DIR" -bin "$BIN_DIR"

# Run copy_libraries.sh script
./Server/copy_libraries.sh

# Secure copy the Server directory to the remote server
scp -i "$SSH_KEY_PATH" -r Server "$REMOTE_SERVER:$REMOTE_PATH"
