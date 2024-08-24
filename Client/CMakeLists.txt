cmake_minimum_required(VERSION 3.16)

project(SudokuVSClient VERSION 0.1 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_AUTORCC ON)

find_package(Qt6 6.5 REQUIRED COMPONENTS Quick Sql)

qt_standard_project_setup(REQUIRES 6.5)

qt_add_executable(appSudokuVSClient
    main.cpp
)

qt_add_qml_module(appSudokuVSClient
    URI SudokuVS
    VERSION 1.0
    QML_FILES
        Main.qml

        qml/screens/WelcomePage.qml
        qml/screens/DifficultyPage.qml

        qml/screens/SudokuPausePopup.qml
        qml/screens/SudokuWinPopup.qml
        qml/screens/SudokuLossPopup.qml
        qml/screens/VersusOptionsPage.qml
        qml/screens/LobbyScreen.qml
        qml/screens/JoinLobbyScreen.qml
        qml/screens/SudokuVSBoard.qml
        qml/screens/SudokuQuitPopup.qml
        qml/screens/SudokuOpponentQuitPopup.qml

        qml/components/SudokuTextField.qml
        qml/components/CustomBorder.qml
        qml/components/SudokuNumButton.qml
        qml/components/GameButton.qml
        qml/components/ButtonComponent.qml

)

# Include C++ sources and headers
target_sources(appSudokuVSClient PRIVATE
    sudokuhelper.h
    sudokuhelper.cpp
    clienttcphandler.h
    clienttcphandler.cpp
    clientmessageprocessor.h
    clientmessageprocessor.cpp
    clientgamemanager.h
    clientgamemanager.cpp
    resources.qrc
)


# Include directories
include_directories(${CMAKE_BINARY_DIR})


# Qt for iOS sets MACOSX_BUNDLE_GUI_IDENTIFIER automatically since Qt 6.1.
# If you are developing for iOS or macOS you should consider setting an
# explicit, fixed bundle identifier manually though.
set_target_properties(appSudokuVSClient PROPERTIES
#    MACOSX_BUNDLE_GUI_IDENTIFIER com.example.appSudokuVS
    MACOSX_BUNDLE_BUNDLE_VERSION ${PROJECT_VERSION}
    MACOSX_BUNDLE_SHORT_VERSION_STRING ${PROJECT_VERSION_MAJOR}.${PROJECT_VERSION_MINOR}
    MACOSX_BUNDLE TRUE
    WIN32_EXECUTABLE TRUE
)

target_link_libraries(appSudokuVSClient
    PRIVATE Qt6::Quick Qt6::Sql
)

target_compile_definitions(appSudokuVSClient PRIVATE SUDOKU_DB_PATH="${SUDOKU_DB_PATH}")


include(GNUInstallDirs)
install(TARGETS appSudokuVSClient
    BUNDLE DESTINATION .
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
)
