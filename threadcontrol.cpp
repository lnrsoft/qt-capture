#include "threadcontrol.h"

ThreadControl::ThreadControl(QObject *parent) : QObject(parent),qtpcap(new Qtpcap(parent))
{

}


void ThreadControl::pcapStart()
{
    QFuture<void> pcap = QtConcurrent::run(qtpcap, &Qtpcap::start);
}
