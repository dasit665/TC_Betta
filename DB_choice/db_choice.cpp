#include "db_choice.h"
#include "ui_db_choice.h"

DB_choice::DB_choice(QWidget *parent, QWidget * caller) :
    QWidget(parent),
    ui(new Ui::DB_choice)
{
    ui->setupUi(this);
    this->caller = caller;

    this->ui->tableWidget->insertRow(this->ui->tableWidget->rowCount());
    this->ui->tableWidget->setItem(this->ui->tableWidget->rowCount()-1, 0, new QTableWidgetItem("192.168.0.1"));
    this->ui->tableWidget->setItem(this->ui->tableWidget->rowCount()-1, 1, new QTableWidgetItem("postgress"));
    this->ui->tableWidget->setItem(this->ui->tableWidget->rowCount()-1, 2, new QTableWidgetItem("toor123"));
}

DB_choice::~DB_choice()
{
    delete ui;
}

void DB_choice::on_pushButton_ok_clicked()
{
    this->caller->showNormal();
    this->close();
}

void DB_choice::on_pushButton_Cancel_clicked()
{
    this->caller->showNormal();
    this->close();
}
