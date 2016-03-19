TEMPLATE = app

QT += qml quick widgets concurrent

SOURCES += main.cpp \
    qtpcap.cpp \
    binary.cpp \
    threadcontrol.cpp

RESOURCES += qml.qrc

# Additional import path used to resolve QML modules in Qt Creator's code model
QML_IMPORT_PATH =

# Default rules for deployment.
include(deployment.pri)

HEADERS += \
    qtpcap.h \
    binary.h \
    threadcontrol.h

LIBS += -lpcap

