#include "authentication.h"
#include "ui_authentication.h"
#include "QMessageBox"
#include "QDebug"
#include <QString>
#include <QStringList>
#include "DB_choice/db_choice.h"

#include <QtSql>
#include <QSqlDatabase>
#include <QSqlError>
#include <QSqlQuery>



Authentication::Authentication(QWidget *parent) :
    QWidget(parent),
    ui(new Ui::Authentication)
{
    ui->setupUi(this);

    this->db_choice = new DB_choice(nullptr, this);

    this->settings = new QSettings("RUSH", "TC_Betta");

    this->Ret_key = new QShortcut(this);
    this->Enter_key = new QShortcut(this);

    this->Ret_key->setKey(Qt::Key_Return);
    this->Enter_key->setKey(Qt::Key_Enter);

    connect(Ret_key, SIGNAL(activated()), this, SLOT(on_pushButton_ok_clicked()));
    connect(Enter_key, SIGNAL(activated()), this, SLOT(on_pushButton_ok_clicked()));

    this->init_list();
    this->init_line();

}

Authentication::~Authentication()
{
    delete ui;

    delete this->db_choice;
    delete this->settings;
}

void Authentication::init_list()
{
    this->ui->comboBox->clear();

    auto size = this->settings->beginReadArray("DBLogins");
    QStringList dnss = QStringList();
    QString login;
    QString server;

    for (int i = 0; i < size; ++i)
    {
        this->settings->setArrayIndex(i);
        login.clear();

        login += this->settings->value("DNS").value<QString>();
        login +="=>";

        login += this->settings->value("Port").toString();
        login +="=>";

        login += this->settings->value("DBName").value<QString>();
        login +="=>";

        login += this->settings->value("Login").value<QString>();
        login +=";";

        dnss.append(login);
    }


    this->ui->comboBox->addItems(dnss);

    this->settings->endArray();

    this->ui->comboBox->setCurrentIndex(this->settings->value("LastServerIndex", 0).toInt());

    this->ui->spinBox_number->clear();


    QWidget::setTabOrder(this->ui->spinBox_number, this->ui->lineEdit_password);
    QWidget::setTabOrder(this->ui->lineEdit_password, this->ui->comboBox);
    QWidget::setTabOrder(this->ui->comboBox, this->ui->pushButton_ok);
    QWidget::setTabOrder(this->ui->pushButton_ok, this->ui->pushButton_cancel);
    QWidget::setTabOrder(this->ui->pushButton_cancel, this->ui->pushButton_info);
    QWidget::setTabOrder(this->ui->pushButton_info, this->ui->pushButton_servers);

}

void Authentication::init_line()
{

    this->ui->lineEdit_server->setStyleSheet("background: rgb(139, 0, 0); color: rgb(255, 255, 255);");
    this->ui->pushButton_ok->setEnabled(false);

    auto index = settings->value("LastServerIndex", 0).toInt();

    QString server = "";

    this->settings->beginReadArray("DBLogins");

    settings->setArrayIndex(index);


    server += settings->value("DNS").value<QString>();

    this->ui->lineEdit_server->setText(server);

    this->settings->endArray();


    this->settings->beginReadArray("DBLogins");
    this->settings->setArrayIndex(index);

    this->database.setPort(this->settings->value("Port").toInt());
    this->database.setDatabaseName(this->settings->value("DBName").toString());
    this->database.setHostName(this->settings->value("DNS").toString());
    this->database.setUserName(this->settings->value("Login").toString());
    this->database.setPassword(this->settings->value("Password").toString());
    this->settings->endArray();


    if(this->database.open()==true)
    {
        this->ui->lineEdit_server->setStyleSheet("background: rgb(0, 255, 0); color: rgb(0, 0, 255);");
        this->ui->pushButton_ok->setEnabled(true);
    }
}

void Authentication::on_pushButton_cancel_clicked()
{
    this->close();
}

void Authentication::on_pushButton_ok_clicked()
{

    int ppo_id = 0;

    if(this->database.open()==true)
    {
        QSqlQuery query;
        query.prepare("select * from app_func_get_ppo_id(?, ?)");
        query.bindValue(0, this->ui->spinBox_number->value());
        query.bindValue(1, this->ui->lineEdit_password->text());


        if(query.exec() == true)
        {
            while(query.next()==true)
            {
                ppo_id = query.value(0).toInt();
            }
        }
        else
        {
            QMessageBox::critical(nullptr, "Error PostgreSQL", this->database.lastError().text());
            return;
        }

    }
    else
    {
        QMessageBox::critical(nullptr, "Error PostgreSQL", this->database.lastError().text());
        return;
    }

    if(ppo_id!=0)
    {
        this->settings->setValue("PPO_ID", ppo_id);
        this->settings->setValue("PPO_Number", this->ui->spinBox_number->text());
        emit autentificated();
    }
    else
    {
        QMessageBox::critical(nullptr, "Authentication Error", "PPO number or password is not valid");
    }

    this->database.close();

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


void Authentication::on_comboBox_activated(int index)
{
    settings->setValue("LastServerIndex", index);

    this->init_line();
}

