#include "authentication.h"
#include "ui_authentication.h"
#include "QMessageBox"
#include "QDebug"
#include "DB_choice/db_choice.h"

Authentication::Authentication(QWidget *parent) :
    QWidget(parent),
    ui(new Ui::Authentication)
{
    ui->setupUi(this);

    this->db_choice = new DB_choice(nullptr, this);

    this->Ret_key = new QShortcut(this);
    this->Enter_key = new QShortcut(this);

    this->Ret_key->setKey(Qt::Key_Return);
    this->Enter_key->setKey(Qt::Key_Enter);

    connect(Ret_key, SIGNAL(activated()), this, SLOT(on_pushButton_ok_clicked()));
    connect(Enter_key, SIGNAL(activated()), this, SLOT(on_pushButton_ok_clicked()));

}

Authentication::~Authentication()
{
    delete ui;
    delete this->db_choice;
}

void Authentication::on_pushButton_cancel_clicked()
{
    this->close();
}

void Authentication::on_pushButton_ok_clicked()
{

    if(this->is_autentificate)
    {
        //QMessageBox::information(nullptr, "Информация", "Аутентификация пройденна", QMessageBox::Ok);
        emit this->autentificated();
        this->close();
    }
    else
    {
        QMessageBox::critical(nullptr, "Внимание!!!", "Аутентификация не пройденна");
    }
}

void Authentication::on_pushButton_servers_clicked()
{
    this->hide();
    this->db_choice->showNormal();

    this->is_autentificate = true;
}

void Authentication::on_pushButton_info_clicked()
{
    QMessageBox::information(nullptr, "Информация","Здесь будет информация об аутентификации");
}
