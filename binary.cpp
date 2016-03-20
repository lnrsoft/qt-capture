#include "binary.h"
#include "pcap/pcap.h"
#include <QDebug>

Binary::Binary(QObject *parent) : QAbstractTableModel(parent)
{
    //tableDatas <<
    Rowdata a = {1, "aaaaaaa"};
    Rowdata b = {1, "aaaaaaa"};
    tableDatas.append(a);
    tableDatas.append(b);

    setHeaderData(0, Qt::Horizontal, QObject::tr("number"));
    setHeaderData(1, Qt::Horizontal, QObject::tr("content"));
}



void Binary::on_packet_received(const struct pcap_pkthdr* pkthdr, const u_char* packet)
{
    QString bstring;
    for(int n=0; n<pkthdr->caplen; ++n){
        for(u_char z=0b11111111; z>0; z>>=1){
            bstring += (((*packet & z) == z) ? "1" : "0");
        }
        packet++;
    }
    binaryString = bstring;
}


int Binary::rowCount(const QModelIndex &parent) const
{
    Q_UNUSED(parent)
    //return tableDatas.size();
    return 0;
}

int Binary::columnCount(const QModelIndex &parent) const
{
    Q_UNUSED(parent)
    return 2;
}

QVariant Binary::data(const QModelIndex &index, int role) const
{
    qDebug() << "MyModel::data: " << index.column() << "; " << index.row();

    switch(index.column())
    {
        case 0:
            return tableDatas[index.row()].number;
        case 1:
            return  tableDatas[index.row()].content;
        default:
            qDebug() << "Not supposed to happen";
            return QVariant();
    }
    return QVariant();
}
