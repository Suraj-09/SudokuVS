#!/bin/bash

# Paths to necessary directories
BIN_DIR="./build/Desktop_Qt_6_7_2-Release/"
LIB_DIR="~/Qt/6.7.2/gcc_64/libs"  # Adjust this to the location of Qt libraries
PLUGIN_OUT="./deploy/plugins"
SQLITE_PLUGIN_DIR="~/Qt/6.7.2/gcc_64/plugins/sqldrivers"  # Adjust this to your SQLite plugin directory

# Output directory
OUTPUT_DIR="./deploy"

TARGET_DIR="$(dirname "$(readlink -f "$0")")/deploy"

# Create necessary directories if they don't exist
mkdir -p "$BIN_DIR"
mkdir -p "$LIB_DIR"
mkdir -p "$PLUGIN_OUT"
mkdir -p "$OUTPUT_DIR"

# Run cqtdeployer with appropriate options
cqtdeployer -targetDir "$TARGET_DIR" \
            -bin "$BIN_DIR/appSudokuVSServer" \
            -libDir "$LIB_DIR" \
            -pluginOut "$TARGET_DIR/plugins" \
            --add-sqlite="$SQLITE_PLUGIN_DIR" \
            --verbose 2 \
            --output "$OUTPUT_DIR"


# # Run cqtdeployer with appropriate options
# cqtdeployer -bin "$BIN_DIR/appSudokuVSServer" \
#             -libDir "$LIB_DIR" \
#             -qmlDir "$QML_DIR" \
#             -pluginOut "$PLUGIN_OUT" \
#             --extraLibs "libsqlite3,libQt5Network.so" \
#             --add-sqlite="$SQLITE_PLUGIN_DIR" \
#             --verbose 2 \
#             --output "$OUTPUT_DIR"


# Check if cqtdeployer ran successfully
if [ $? -eq 0 ]; then
    echo "Deployment successful."
else
    echo "Deployment failed. Check the logs for details."
    exit 1
fi
