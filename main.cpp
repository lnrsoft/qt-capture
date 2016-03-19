#include <QApplication>
#include <QQmlApplicationEngine>
#include <QMessageBox>
#include <QQmlContext>
#include <QDebug>
#include "qtpcap.h"
#include <QtConcurrent>

#include "threadcontrol.h"


int main(int argc, char *argv[])
{
    QApplication app(argc, argv);

    QQmlApplicationEngine engine;
    engine.load(QUrl(QStringLiteral("qrc:/main.qml")));

    ThreadControl* threadPcap = new ThreadControl;

    engine.rootContext()->setContextProperty("_qtpcap", threadPcap);
    return app.exec();
}

