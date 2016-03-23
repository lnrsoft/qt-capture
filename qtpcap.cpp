#include "qtpcap.h"
#include <QDebug>
#include <QApplication>
#include <netinet/if_ether.h>
#include <QJsonObject>
#include <QJsonDocument>


Qtpcap::Qtpcap(QObject *parent) : QObject(parent)
{
    char* device;           //currently active device
    char errbuf[PCAP_ERRBUF_SIZE];
    bpf_u_int32 net;		// Our local IP
    bpf_u_int32 mask;		// Our netmask
    char filter_exp[] = "port 443";	/* The filter expression */
    bpf_program fp;		/* The compiled filter expression */

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

    if (pcap_compile(handle, &fp, filter_exp, 0, net) == -1) {
        fprintf(stderr, "Couldn't parse filter %s: %s\n", filter_exp, pcap_geterr(handle));
        //return(2);
    }
    if (pcap_setfilter(handle, &fp) == -1) {
        fprintf(stderr, "Couldn't install filter %s: %s\n", filter_exp, pcap_geterr(handle));
        //return(2);
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
    QJsonObject etherHeader; //ethernet header json object
    ether_header *eptr = (ether_header *) packet;
    //6 bytes
    etherHeader["destination"] = ether_ntoa((const struct ether_addr *)&eptr->ether_dhost);
    //6 bytes
    etherHeader["source"] = ether_ntoa((const struct ether_addr *)&eptr->ether_shost);
    //2 bytes
    if (ntohs (eptr->ether_type) == ETHERTYPE_IP){
        etherHeader["type"] = "IP";
    }else  if (ntohs (eptr->ether_type) == ETHERTYPE_ARP){
        etherHeader["type"] = "ARP";
    }else  if (ntohs (eptr->ether_type) == ETHERTYPE_REVARP){
        etherHeader["type"] = "RARP";
    }else {
        etherHeader["type"] = "UNKNOWN!";
    }

    QJsonObject ipHeader;
    const ip *myip = (ip*)(packet + 14);
    ipHeader["version"] = myip->ip_v; //4 bits
    ipHeader["headLength"] = myip->ip_hl * 4; //4 bits
    ipHeader["type"] = myip->ip_tos; //1 byte
    ipHeader["totalLength"] = myip->ip_len; //2 bytes
    ipHeader["identification"] = myip->ip_id; //2 bytes
    ipHeader["fragment"] = myip->ip_off; //2 bytes
    ipHeader["ttl"] = myip->ip_ttl; //1 byte
    ipHeader["protocol"] = myip->ip_p; //1 byte
    ipHeader["checksum"] = myip->ip_sum; //2 bytes
    ipHeader["dest"] = inet_ntoa(myip->ip_dst); //4 bytes
    ipHeader["source"] = inet_ntoa(myip->ip_src); //4 bytes
    //QString strJson(doc.toJson(QJsonDocument::Compact));
    qDebug() << ipHeader["dest"];

    QJsonObject tcpHeader;
    const tcphdr *mytcp = (tcphdr*)(packet+14+myip->ip_hl*4);
    tcpHeader["sourcePort"] = ntohs(mytcp->th_sport);  //2 bytes
    tcpHeader["destPort"] = ntohs(mytcp->th_dport);  //2 bytes
    tcpHeader["seqNumber"] = QString("%1").arg(mytcp->th_seq, 0, 16).toUpper();
    tcpHeader["ackNumber"] = QString("%1").arg(mytcp->th_ack, 0, 16).toUpper(); //4 bytes
    tcpHeader["windowSize"] = mytcp->th_win; //2 bytes
    tcpHeader["checksum"] = mytcp->th_sum; //2 bytes
    tcpHeader["urgentPoint"] = mytcp->th_urp; //2 bytes
    QJsonDocument doc(tcpHeader);

    QString strJson(doc.toJson(QJsonDocument::Compact));
    qDebug() << tcpHeader["destPort"];


    QString bstring; //binary string
    QString hstring; //hexadecimal string
    for(int n=0; n<int(pkthdr->caplen); ++n){
        //binary mode
        for(u_char z=0b10000000; z>0; z>>=1){
            bstring += (((*packet & z) > 0) ? "1" : "0");
        }

        //hexadecimal mode
        hstring += QString("%1").arg(*packet, 0, 16).toUpper();
        packet++;
    }


    /*********BINARY*********/
    QString binaryString = "{\"number\":\""+QString::number(qtpcap->packetCount)+"\",\"content\":\""+bstring+"\"}";
    emit(qtpcap->sendBinary(binaryString));
    /**********HEXADECIMAL*********/
    QString hexString = "{\"number\":\""+QString::number(qtpcap->packetCount)+"\",\"content\":\""+hstring+"\"}";
    emit(qtpcap->sendHexadecimal(hexString));
    /*********DIAGRAM*********/
    /* check to see if we have an ip packet */

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
