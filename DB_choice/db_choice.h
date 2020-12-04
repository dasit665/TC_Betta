#ifndef DB_CHOICE_H
#define DB_CHOICE_H

#include <QCoreApplication>
#include <QWidget>
#include <QSettings>
#include <QVector>
#include <QString>


struct DBLogin
{
    QString DNS;
    int Port;
    QString DBName;
    QString Login;
    QString Password;

    DBLogin(QString DNS = "", int Port =0, QString DBName ="", QString Login = "", QString Password = "")
    {
        this->DNS = DNS;
        this->Port = Port;
        this->DBName = DBName;
        this->Login = Login;
        this->Password = Password;
    }
};

namespace Ui {
class DB_choice;
}

class DB_choice : public QWidget
{
public:
    Q_OBJECT

    QWidget * caller;

    QSettings * settings = new QSettings("RUSH", "TC_Betta");

public:
    explicit DB_choice(QWidget *parent = nullptr, QWidget * caller = nullptr);
    ~DB_choice();

private:
    void init_table();

private slots:
    void on_pushButton_ok_clicked();

    void on_pushButton_Cancel_clicked();

    void on_tableWidget_cellClicked(int row, int column);

    void on_pushButton_add_clicked();

    void on_pushButton_remove_clicked();

private:
    Ui::DB_choice *ui;
};

#endif // DB_CHOICE_H
