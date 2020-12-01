#ifndef AUTHENTICATION_H
#define AUTHENTICATION_H

#include <QWidget>
#include <QShortcut>
#include "DB_choice/db_choice.h"

namespace Ui {
class Authentication;
}

class Authentication : public QWidget
{
    Q_OBJECT

public:
    explicit Authentication(QWidget *parent = nullptr);
    ~Authentication();

signals:
    void autentificated();


private slots:
    void on_pushButton_cancel_clicked();
    void on_pushButton_ok_clicked();
    void on_pushButton_servers_clicked();
    void on_pushButton_info_clicked();


    void on_comboBox_activated(const QString &arg1);

private:

    void init_list();

    Ui::Authentication *ui;
    bool is_autentificate = false;

    QSettings * settings;

    QShortcut * Ret_key, * Enter_key;

    DB_choice * db_choice;
};

#endif // AUTHENTICATION_H
