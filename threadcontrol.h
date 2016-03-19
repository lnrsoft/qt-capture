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


public slots:
    void pcapStart();
};

#endif // THREADCONTROL_H
