#include "qtpcap.h"
#include <QDebug>
#include <QApplication>
#include <netinet/if_ether.h>


Qtpcap::Qtpcap(QObject *parent) : QObject(parent)
{
    char* device;           //currently active device
    char errbuf[PCAP_ERRBUF_SIZE];
    bpf_u_int32 net;		// Our local IP
    bpf_u_int32 mask;		// Our netmask

    //The currently active device
    device = pcap_lookupdev(errbuf);
    if(device == NULL){
        qDebug() << "Couldn't find default device: " << device << " " << errbuf;
        qApp->quit();
    }else{
        qDebug() << device;
    }
    if (pcap_lookupnet(device, &net, &mask, errbuf) == -1) {
        qDebug() << "Couldn't get netmask for device " << device << ":" << errbuf;
        net = 0;
        mask = 0;
    }
    /* Open the session in promiscuous mode */
    handle = pcap_open_live(device, BUFSIZ, 1, 1000, errbuf);
    if(handle == NULL){
        qDebug() << "Couldn't open device " << device << ":" << errbuf;
        qApp->quit();
    }

    //all network devices
    pcap_if_t *alldevsp;
    if(pcap_findalldevs(&alldevsp, errbuf) == 0){
        do{
            devices.push_back(QString(alldevsp->name));
        }while((alldevsp=alldevsp->next));
    }
    pcap_freealldevs(alldevsp);
}

void Qtpcap::loop_callback(u_char *self,const struct pcap_pkthdr* pkthdr,const u_char* packet)
{
    Qtpcap* qtpcap = reinterpret_cast<Qtpcap *>(self);
    u_char *pk = new u_char[pkthdr->caplen];
    memcpy(pk, packet, pkthdr->caplen);
    qtpcap->packets.push_back(pk);
    qtpcap->packetCount++;


    /*********BINARY*********/
    QString bstring;
    QString hstring;
    for(int n=0; n<int(pkthdr->caplen); ++n){
        for(u_char z=0b11111111; z>0; z>>=1){
            bstring += (((*packet & z) == z) ? "1" : "0");
        }
        hstring += QString("%1").arg(*packet, 0, 16);
        packet++;
    }
    QString binaryString = "{\"number\":\""+QString::number(qtpcap->packetCount)+"\",\"content\":\""+bstring+"\"}";
    emit(qtpcap->sendBinary(binaryString));
    /**********HEXADECIMAL*********/
    QString hexString = "{\"number\":\""+QString::number(qtpcap->packetCount)+"\",\"content\":\""+hstring+"\"}";
    emit(qtpcap->sendHexadecimal(hexString));
}

void Qtpcap::start()
{
    int n = pcap_loop(handle,0,(pcap_handler)&Qtpcap::loop_callback,(uchar *)this);
    qDebug() << "this is loop return: " << n;

}

void Qtpcap::stop()
{
    pcap_breakloop(this->handle);
//    if(!packets.empty()){
//        u_char* packet = packets[0];
//        int i = ETHER_ADDR_LEN;
//        qDebug() << " Destination Address:  ";
//        do{
//            qDebug(":%x", *packet++);
//        }while(--i>0);
//            qDebug();

//        i = ETHER_ADDR_LEN;
//        qDebug() << " Source Address:  ";
//        do{
//            qDebug(":%x", *packet++);
//        }while(--i>0);
//            qDebug();
//    }
}




Qtpcap::~Qtpcap()
{
    parent()->~QObject();
    if(!packets.empty()){
        for(auto ite: packets){
            delete[] ite;
        }
        packets.clear();
    }
}
