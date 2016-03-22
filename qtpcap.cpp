#include "qtpcap.h"
#include <QDebug>
#include <QApplication>
#include <netinet/if_ether.h>
#include <QJsonObject>
#include <QJsonDocument>
#include <netinet/ip.h>
#include <arpa/inet.h>
//#include <netinet/if_ether.h>
//#include <netinet/in.h>
//#include <stdlib.h>
#include <net/ethernet.h>
//#include <netinet/ether.h>
#include <sys/socket.h>

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
//    u_char *pk = new u_char[pkthdr->caplen];
//    memcpy(pk, packet, pkthdr->caplen);
//    qtpcap->packets.push_back(pk);
    qtpcap->packetCount++;
    ether_header *eptr = (ether_header *) packet;
    QJsonObject ipHeader;
    ip *myip = (ip *)packet;
    qDebug() << inet_ntoa(myip->ip_src);
    ipHeader["version"] = (myip->ip_v & 0xf0) >> 4;
    qDebug() << ipHeader["version"].toInt();

    QString bstring; //binary string
    QString hstring; //hexadecimal string
    QJsonObject etherHeader; //ethernet header json object
    for(int n=0; n<int(pkthdr->caplen); ++n){
        //binary mode
        for(u_char z=0b10000000; z>0; z>>=1){
            bstring += (((*packet & z) > 0) ? "1" : "0");
        }

        //hexadecimal mode
        hstring += QString("%1").arg(*packet, 0, 16).toUpper();

        //diagram mode
//        QJsonObject jsonObj; // assume this has been populated with Json data QJsonValue
//        jsonObj.insert("a", "aaaaa");
//        jsonObj.insert("b", jsonObj);
//        QJsonDocument doc(jsonObj);
//        QString strJson(doc.toJson(QJsonDocument::Compact));
//        if(n<6){
//            etherHeader["destination"] = etherHeader["destination"].toString()
//                    + QString("%1").arg(*packet, 0, 16).toUpper();
//        }else if(n<12){
//            etherHeader["source"] = etherHeader["destination"].toString()
//                    + QString("%1").arg(*packet, 0, 16).toUpper();
//        }else if(n<14){
//        }

        packet++;
    }


    /*********BINARY*********/
    QString binaryString = "{\"number\":\""+QString::number(qtpcap->packetCount)+"\",\"content\":\""+bstring+"\"}";
    emit(qtpcap->sendBinary(binaryString));
    qDebug() << binaryString;
    /**********HEXADECIMAL*********/
    QString hexString = "{\"number\":\""+QString::number(qtpcap->packetCount)+"\",\"content\":\""+hstring+"\"}";
    emit(qtpcap->sendHexadecimal(hexString));
    /*********DIAGRAM*********/
    /* check to see if we have an ip packet */
    etherHeader["destination"] = ether_ntoa((const struct ether_addr *)&eptr->ether_dhost);
    etherHeader["source"] = ether_ntoa((const struct ether_addr *)&eptr->ether_shost);
    if (ntohs (eptr->ether_type) == ETHERTYPE_IP){
        etherHeader["type"] = "IP";
    }else  if (ntohs (eptr->ether_type) == ETHERTYPE_ARP){
        etherHeader["type"] = "ARP";
    }else  if (ntohs (eptr->ether_type) == ETHERTYPE_REVARP){
        etherHeader["type"] = "RARP";
    }else {
        etherHeader["type"] = "UNKNOWN!";
    }
    //qDebug() << etherHeader["source"].toString();
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
