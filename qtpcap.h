#ifndef QTPCAP_H
#define QTPCAP_H

#include <QObject>
#include <pcap/pcap.h>
#include <vector>
#include <netinet/ip.h>
#include <arpa/inet.h>
#include <net/ethernet.h>
#include <netinet/in.h>
#include <netinet/tcp.h>

class Qtpcap : public QObject
{
    Q_OBJECT
public:
    explicit Qtpcap(QObject *parent = 0);
    std::vector<u_char*> packets;
    static void loop_callback(u_char *args,const struct pcap_pkthdr* pkthdr,const u_char* packet);
    ~Qtpcap();
    std::vector<QString> devices;
    int packetCount=0;

signals:
    void onPacket(const struct pcap_pkthdr*, const u_char*);
    void sendBinary(QString binaryString);
    void sendHexadecimal(QString hexString);
    void sendDiagram(QString diaString);

public slots:
    void start();
    void stop();

private:
    pcap_t *handle;			/* Session handle */
};

#endif // QTPCAP_H
