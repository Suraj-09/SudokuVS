#!/bin/bash

# Define the source and destination directories
SOURCE_DIR="/home/suraj/Qt/6.7.2/gcc_64/lib"
DEST_DIR="/home/suraj/code/qt/SudokuVS/Server/deploy/lib"

# List of libraries to copy
libraries=(
    "libicui18n.so.73"
    "libicuuc.so.73"
    "libicudata.so.73"
    "libQt6Core.so.6"
    "libQt6WebSockets.so.6"
    "libQt6Network.so.6"
    "libQt6Sql.so.6"
    "libQt6Sql.so.6.7.2"
)

# Copy each library to the destination directory
for lib in "${libraries[@]}"; do
    cp "$SOURCE_DIR/$lib" "$DEST_DIR"
    echo "Copied $lib to $DEST_DIR"
done


SOURCE_DIR="/home/suraj/Qt/6.7.2/gcc_64/plugins/sqldrivers"
DEST_DIR="/home/suraj/code/qt/SudokuVS/Server/deploy/plugins/sqldrivers"

mkdir -p "$DEST_DIR"

# List of libraries to copy
libraries=(
    "libqsqlite.so"
)

# Copy each library to the destination directory
for lib in "${libraries[@]}"; do
    cp "$SOURCE_DIR/$lib" "$DEST_DIR"
    echo "Copied $lib to $DEST_DIR"
done


echo "All libraries copied successfully."
