cmake_minimum_required(VERSION 3.16)

project(SudokuVSServer LANGUAGES CXX)

set(CMAKE_AUTOUIC ON)
set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTORCC ON)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

find_package(QT NAMES Qt6 Qt5 REQUIRED COMPONENTS Core Sql)
find_package(Qt${QT_VERSION_MAJOR} REQUIRED COMPONENTS Core Network Sql)


set(PARENT_PROJECT_PATH "${CMAKE_CURRENT_SOURCE_DIR}/../")
set(SUDOKU_DB_PATH "C:/code/qt/QtQuick/SudokuVS/Utils/databases/sudoku.db")

add_executable(appSudokuVSServer
  main.cpp
  servertcphandler.h servertcphandler.cpp
  servergamemanager.h servergamemanager.cpp
  servermessageprocessor.h servermessageprocessor.cpp
  servergamelobbyhandler.h servergamelobbyhandler.cpp
  ../Utils/includes/sudokuhelper.h
  ../Utils/src/sudokuhelper.cpp
)


target_link_libraries(appSudokuVSServer Qt${QT_VERSION_MAJOR}::Core Qt6::Network Qt${QT_VERSION_MAJOR}::Sql)

include(GNUInstallDirs)
install(TARGETS appSudokuVSServer
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
)
