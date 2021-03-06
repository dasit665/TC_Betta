#include <QtDebug>
#include "db_choice.h"
#include "ui_db_choice.h"
#include <QVector>
#include <Authentication/authentication.h>


DB_choice::DB_choice(QWidget *parent, QWidget * caller) :
    QWidget(parent),
    ui(new Ui::DB_choice)
{
    ui->setupUi(this);
    this->caller = caller;


    this->init_table();
}

void DB_choice::init_table()
{

    auto DBLogins = QVector<DBLogin>();


    auto size = this->settings->beginReadArray("DBLogins");

    if(size == 0)
    {
        settings->endArray();
        return;
    }

    for(int i = 0; i < size; i++)
    {
        DBLogin login;


        this->settings->setArrayIndex(i);

        login.DNS = settings->value("DNS").value<QString>();
        login.Port = settings->value("Port").value<int>();
        login.DBName = settings->value("DBName").value<QString>();
        login.Login = settings->value("Login").value<QString>();
        login.Password = settings->value("Password").value<QString>();

        DBLogins.append(login);
    }

    settings->endArray();

    for(int i = 0; i < size; i++)
    {
        this->ui->tableWidget->insertRow(i);

        this->ui->tableWidget->setItem(i, 0, new QTableWidgetItem(DBLogins.at(i).DNS));
        this->ui->tableWidget->setItem(i, 1, new QTableWidgetItem(QString::number(DBLogins.at(i).Port)));
        this->ui->tableWidget->setItem(i, 2, new QTableWidgetItem(DBLogins.at(i).DBName));
        this->ui->tableWidget->setItem(i, 3, new QTableWidgetItem(DBLogins.at(i).Login));
        this->ui->tableWidget->setItem(i, 4, new QTableWidgetItem(DBLogins.at(i).Password));
    }
}


DB_choice::~DB_choice()
{
    delete ui;
    delete this->settings;
}


void DB_choice::on_pushButton_ok_clicked()
{
    QVector<DBLogin> logins = QVector<DBLogin>();

    for(int i = 0; i < this->ui->tableWidget->rowCount(); i++)
    {
        DBLogin login;

        login.DNS = this->ui->tableWidget->item(i, 0)->text();
        login.Port = this->ui->tableWidget->item(i, 1)->text().toInt();
        login.DBName = this->ui->tableWidget->item(i, 2)->text();
        login.Login = this->ui->tableWidget->item(i, 3)->text();
        login.Password = this->ui->tableWidget->item(i, 4)->text();

        logins.append(login);
    }

    this->settings->clear();

    this->settings->beginWriteArray("DBLogins");
    for (int i = 0; i < logins.count(); ++i)
    {
        settings->setArrayIndex(i);
        this->settings->setValue("DNS", logins.at(i).DNS);
        this->settings->setValue("Port", logins.at(i).Port);
        this->settings->setValue("DBName", logins.at(i).DBName);
        this->settings->setValue("Login", logins.at(i).Login);
        this->settings->setValue("Password", logins.at(i).Password);
    }
    this->settings->endArray();


    dynamic_cast<Authentication *>(this->caller)->init_list();
    dynamic_cast<Authentication *>(this->caller)->init_line();
    this->caller->showNormal();
    this->close();
}

void DB_choice::on_pushButton_Cancel_clicked()
{
    this->caller->showNormal();
    this->close();
}


void DB_choice::on_tableWidget_cellClicked(int row, int column)
{
    this->ui->tableWidget->selectRow(row);
}

void DB_choice::on_pushButton_add_clicked()
{
    this->ui->tableWidget->insertRow(this->ui->tableWidget->rowCount());
    this->ui->tableWidget->setItem(this->ui->tableWidget->rowCount()-1, 0, new QTableWidgetItem("localhost"));
    this->ui->tableWidget->setItem(this->ui->tableWidget->rowCount()-1, 1, new QTableWidgetItem("5432"));
    this->ui->tableWidget->setItem(this->ui->tableWidget->rowCount()-1, 2, new QTableWidgetItem("tc_db"));
    this->ui->tableWidget->setItem(this->ui->tableWidget->rowCount()-1, 3, new QTableWidgetItem("postgres"));
    this->ui->tableWidget->setItem(this->ui->tableWidget->rowCount()-1, 4, new QTableWidgetItem("postgres"));
}

void DB_choice::on_pushButton_remove_clicked()
{
    if(this->ui->tableWidget->rowCount()==0)
    {
        return;
    }

    if(this->ui->tableWidget->selectedItems().count()==0)
    {
        return;
    }

    this->ui->tableWidget->removeRow(this->ui->tableWidget->selectedItems()[0]->row());

}
