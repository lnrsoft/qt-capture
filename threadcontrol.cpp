#include "threadcontrol.h"

ThreadControl::ThreadControl(QObject *parent) : QObject(parent),qtpcap(new Qtpcap(parent))
{

}


void ThreadControl::pcapStart()
{
    emit(send2qml(111));
    QFuture<void> pcap = QtConcurrent::run(qtpcap, &Qtpcap::start);
}

void ThreadControl::pcapStop()
{
    emit(send2qml(222));
    qtpcap->stop();
}
