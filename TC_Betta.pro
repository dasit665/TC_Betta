QT       += core gui

greaterThan(QT_MAJOR_VERSION, 4): QT += widgets

CONFIG += c++17

# You can make your code fail to compile if it uses deprecated APIs.
# In order to do so, uncomment the following line.
#DEFINES += QT_DISABLE_DEPRECATED_BEFORE=0x060000    # disables all the APIs deprecated before Qt 6.0.0

SOURCES += \
    AdditionalWindow/additionalwindow.cpp \
    Authentication/authentication.cpp \
    DB_choice/db_choice.cpp \
    MainWindow/mainwindow.cpp \
    main.cpp

# Default rules for deployment.
qnx: target.path = /tmp/$${TARGET}/bin
else: unix:!android: target.path = /opt/$${TARGET}/bin
!isEmpty(target.path): INSTALLS += target

FORMS += \
    AdditionalWindow/additionalwindow.ui \
    Authentication/authentication.ui \
    DB_choice/db_choice.ui \
    MainWindow/mainwindow.ui

HEADERS += \
    AdditionalWindow/additionalwindow.h \
    Authentication/authentication.h \
    DB_choice/db_choice.h \
    MainWindow/mainwindow.h
