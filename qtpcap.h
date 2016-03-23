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


/* TCP header */
typedef u_int tcp_seq;
struct sniff_tcp {
        u_short th_sport;               /* source port */
        u_short th_dport;               /* destination port */
        tcp_seq th_seq;                 /* sequence number */
        tcp_seq th_ack;                 /* acknowledgement number */
        u_char  th_offx2;               /* data offset, rsvd */
#define TH_OFF(th)      (((th)->th_offx2 & 0xf0) >> 4)
        u_char  th_flags;
        #define TH_FIN  0x01
        #define TH_SYN  0x02
        #define TH_RST  0x04
        #define TH_PUSH 0x08
        #define TH_ACK  0x10
        #define TH_URG  0x20
        #define TH_ECE  0x40
        #define TH_CWR  0x80
        #define TH_FLAGS        (TH_FIN|TH_SYN|TH_RST|TH_ACK|TH_URG|TH_ECE|TH_CWR)
        u_short th_win;                 /* window */
        u_short th_sum;                 /* checksum */
        u_short th_urp;                 /* urgent pointer */
};





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

public slots:
    void start();
    void stop();

private:
    pcap_t *handle;			/* Session handle */
};

#endif // QTPCAP_H
