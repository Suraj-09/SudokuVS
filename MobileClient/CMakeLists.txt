cmake_minimum_required(VERSION 3.16)

project(MobileClient VERSION 0.1 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD_REQUIRED ON)

find_package(Qt6 6.5 REQUIRED COMPONENTS Quick Sql)

qt_standard_project_setup(REQUIRES 6.5)

qt_add_executable(appMobileClient
    main.cpp
)

qt_add_qml_module(appMobileClient
    URI MobileClient
    VERSION 1.0
    QML_FILES
        Main.qml
        qml/DifficultyPage.qml
        qml/SudokuBoard.qml
        qml/WelcomePage.qml
        qml/SudokuTextField.qml
        qml/CustomBorder.qml
        qml/SudokuNumButton.qml
        qml/SudokuWinPopup.qml
        qml/SudokuPausePopup.qml
        qml/SudokuLossPopup.qml
        qml/VersusOptionsPage.qml
        qml/LobbyScreen.qml
        qml/GameButton.qml
        qml/SudokuVSBoard.qml
        qml/JoinLobbyScreen.qml
        qml/ButtonComponent.qml
        qml/SudokuQuitPopup.qml
        qml/SudokuOpponentQuitPopup.qml

        SOURCES
            sudokuhelper.h
            sudokuhelper.cpp
            clienttcphandler.h clienttcphandler.cpp
            clientmessageprocessor.h clientmessageprocessor.cpp
            clientgamemanager.h clientgamemanager.cpp

        RESOURCES
            resources.qrc
            utils/databases/sudoku.db
            assets/sudoku.db
            sudoku.db
            resources/check.png
)

qt_add_resources(${PROJECT_SOURCES} resources.qrc)

# # Include the resource file
# qt_add_resources(appSudokuVSClient "resources"
#     PREFIX "/"
#     FILES resources.qrc
# )

# if(ANDROID)
#     add_library(appMobileClient SHARED ${PROJECT_SOURCES})
# else()
#     add_executable(appMobileClient ${PROJECT_SOURCES})
# endif()

# Qt for iOS sets MACOSX_BUNDLE_GUI_IDENTIFIER automatically since Qt 6.1.
# If you are developing for iOS or macOS you should consider setting an
# explicit, fixed bundle identifier manually though.
set_target_properties(appMobileClient PROPERTIES
#    MACOSX_BUNDLE_GUI_IDENTIFIER com.example.appMobileClient
    MACOSX_BUNDLE_BUNDLE_VERSION ${PROJECT_VERSION}
    MACOSX_BUNDLE_SHORT_VERSION_STRING ${PROJECT_VERSION_MAJOR}.${PROJECT_VERSION_MINOR}
    MACOSX_BUNDLE TRUE
    WIN32_EXECUTABLE TRUE
)

target_link_libraries(appMobileClient
    PRIVATE Qt6::Quick Qt6::Sql
)

include(GNUInstallDirs)
install(TARGETS appMobileClient
    BUNDLE DESTINATION .
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
)
