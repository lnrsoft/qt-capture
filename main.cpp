#include <QApplication>
#include <QQmlApplicationEngine>
#include <QMessageBox>
#include <QQmlContext>
#include <QDebug>
#include "qtpcap.h"
#include <QtConcurrent>
#include <QQuickView>
#include <QQmlComponent>
#include <QQmlProperty>
#include <QVariant>
#include <QAbstractItemModel>
#include <QTableView>
#include "threadcontrol.h"
#include "binary.h"


int main(int argc, char *argv[])
{
    QApplication app(argc, argv);

    QQmlApplicationEngine engine;


    ThreadControl threadPcap;
    Binary binary;
    QObject::connect(threadPcap.qtpcap, SIGNAL(onPacket(const struct pcap_pkthdr*, const u_char*)), &binary,
                     SLOT(on_packet_received(const struct pcap_pkthdr*, const u_char*)));

    QObject::connect(qApp, SIGNAL(aboutToQuit()), threadPcap.qtpcap, SLOT(stop()));


    //engine.rootContext()->setContextProperty("_binary", QVariant::fromValue(&ls));
    engine.rootContext()->setContextProperty("_qtpcap", &threadPcap);
    engine.load(QUrl(QStringLiteral("qrc:/main.qml")));

    return app.exec();
}

