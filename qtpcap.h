#ifndef QTPCAP_H
#define QTPCAP_H

#include <QObject>
#include <pcap/pcap.h>
#include <vector>

class Qtpcap : public QObject
{
    Q_OBJECT
public:
    explicit Qtpcap(QObject *parent = 0);
    std::vector<u_char*> packets;
    static void loop_callback(u_char *args,const struct pcap_pkthdr* pkthdr,const u_char* packet);
    ~Qtpcap();
signals:

public slots:
    void start();
    void stop();


private:
    pcap_t *handle;			/* Session handle */
};

#endif // QTPCAP_H
