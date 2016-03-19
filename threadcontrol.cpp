#include "threadcontrol.h"

ThreadControl::ThreadControl(QObject *parent) : QObject(parent)
{

}


void ThreadControl::pcapStart()
{
    Qtpcap* qtpcap = new Qtpcap;
    QFuture<void> pcap = QtConcurrent::run(qtpcap, &Qtpcap::start);
}
