#ifndef BINARY_H
#define BINARY_H

#include <QObject>
#include <pcap/pcap.h>
#include <QAbstractTableModel>
#include <QVariant>
#include <QList>

struct Rowdata
{
    qint32 number;
    QString content;
};

class Binary : public QAbstractTableModel
{
    Q_OBJECT
public:
    explicit Binary(QObject *parent = 0);
    QString binaryString;
    int rowCount(const QModelIndex &parent) const Q_DECL_OVERRIDE;
    int columnCount(const QModelIndex &parent) const Q_DECL_OVERRIDE;
    QVariant data(const QModelIndex &index, int role = Qt::DisplayRole) const Q_DECL_OVERRIDE;
signals:

public slots:
    void on_packet_received(const struct pcap_pkthdr* pkthdr, const u_char* packet);

private:
    QList<Rowdata> tableDatas;
};

#endif // BINARY_H
