# SudokuVS

SudokuVS is a competitive Sudoku game built with Qt6 using QML and C++. It includes both a client and server component, allowing players to connect and compete against each other in real-time. The project also supports an Android client for mobile users.

## Features

- **Solo Mode**: Play Sudoku solo with a range of difficulties.
- **Versus Mode**: Compete against another player in real-time.

## Project Structure

The repository contains three main projects:

- **Server**: The server application that manages game sessions and player interactions.
- **Client**: The desktop client application that players use to play the game.
- **Android Client**: The mobile client designed specifically for Android devices.

## Getting Started

### Prerequisites

- CMake (version 3.16 or higher)
- Qt6 (version 6.5 or higher)
- A C++ compiler compatible with C++17
- Android SDK and NDK for building the Android client

### Building with Qt Creator
1. Install **Qt Creator** with Qt6 components.
2. Open `CMakeLists.txt` in Qt Creator for the desired project (Client, Server, or Android Client).
3. Configure the build using the appropriate kit (Desktop for Client/Server or Android for mobile).
4. Build and run the project.