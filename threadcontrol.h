#ifndef THREADCONTROL_H
#define THREADCONTROL_H

#include <QObject>
#include <QtConcurrent>
#include "qtpcap.h"

class ThreadControl : public QObject
{
    Q_OBJECT
public:
    explicit ThreadControl(QObject *parent = 0);
    Qtpcap* qtpcap;

signals:
    void send2qml(int count);

public slots:
    void pcapStart();
    void pcapStop();
};

#endif // THREADCONTROL_H
