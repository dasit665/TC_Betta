#include <QApplication>
#include <QScreen>
#include "Authentication/authentication.h"
#include "QDebug"
#include "MainWindow/mainwindow.h"

int main(int argc, char *argv[])
{
    QApplication a(argc, argv);

    QScreen *screen = QGuiApplication::primaryScreen();
    QRect  screenGeometry = screen->geometry();

    Authentication aut(nullptr);
    MainWindow mw(nullptr, screenGeometry.width(), screenGeometry.height());

    aut.show();
    aut.move((screenGeometry.width() - aut.width())/2, (screenGeometry.height() - aut.height())/2);

    QObject::connect(&aut, &Authentication::autentificated, [&mw]()
    {
        qInfo()<<"connect is rised";
        mw.showMaximized();
    });

    return a.exec();
}
