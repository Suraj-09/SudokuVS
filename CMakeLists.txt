cmake_minimum_required(VERSION 3.16)

project(SudokuVS VERSION 0.1 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD_REQUIRED ON)

find_package(Qt6 6.5 REQUIRED COMPONENTS Quick)

qt_standard_project_setup(REQUIRES 6.5)

qt_add_executable(appSudokuVS
    main.cpp
)

qt_add_qml_module(appSudokuVS
    URI SudokuVS
    VERSION 1.0
    QML_FILES
        Main.qml
        QML_FILES qml/DifficultyPage.qml
        QML_FILES qml/SudokuBoard.qml
        QML_FILES qml/WelcomePage.qml
        QML_FILES qml/SudokuTextField.qml
        RESOURCES resources.qrc
        SOURCES sudokuhelper.h sudokuhelper.cpp
        RESOURCES res/sudoku1.txt
        QML_FILES qml/CustomBorder.qml
        QML_FILES qml/SudokuNumButton.qml
        RESOURCES res/sudoku2.txt
        QML_FILES qml/SudokuPopup.qml
        QML_FILES qml/SudokuPausePopup.qml
)


# Include the resource file
qt_add_resources(appSudokuVS "resources"
    PREFIX "/"
    FILES resources.qrc
)

# Specify resource files
qt_add_resources(appSudokuVS "res"
    PREFIX "/"
    FILES
        res/sudoku.txt
)
# Qt for iOS sets MACOSX_BUNDLE_GUI_IDENTIFIER automatically since Qt 6.1.
# If you are developing for iOS or macOS you should consider setting an
# explicit, fixed bundle identifier manually though.
set_target_properties(appSudokuVS PROPERTIES
#    MACOSX_BUNDLE_GUI_IDENTIFIER com.example.appSudokuVS
    MACOSX_BUNDLE_BUNDLE_VERSION ${PROJECT_VERSION}
    MACOSX_BUNDLE_SHORT_VERSION_STRING ${PROJECT_VERSION_MAJOR}.${PROJECT_VERSION_MINOR}
    MACOSX_BUNDLE TRUE
    WIN32_EXECUTABLE TRUE
)

target_link_libraries(appSudokuVS
    PRIVATE Qt6::Quick
)

include(GNUInstallDirs)
install(TARGETS appSudokuVS
    BUNDLE DESTINATION .
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
)
