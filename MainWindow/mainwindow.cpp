#include "mainwindow.h"
#include "ui_mainwindow.h"
#include <QShortcut>
#include <QMessageBox>
#include <AdditionalWindow/additionalwindow.h>

MainWindow::MainWindow(QWidget *parent, int width, int height) :
    QMainWindow(parent),
    ui(new Ui::MainWindow)
{
    this->screen_width = width;
    this->screen_heigth = height;

    ui->setupUi(this);
    this->aw = new AdditionalWindow(nullptr);

    this->table_formating(width);
    this->shotr_keys_initialising();

}

MainWindow::~MainWindow()
{
    delete ui;
    delete this->aw;
}

void MainWindow::table_formating(int width)
{
    this->ui->tableWidget_check->setColumnWidth(0, width-750);
    this->ui->tableWidget_check->setColumnWidth(1, 75);
    this->ui->tableWidget_check->setColumnWidth(2, 75);
    this->ui->tableWidget_check->setColumnWidth(3, 100);
    this->ui->tableWidget_check->setColumnWidth(4, 100);
    this->ui->tableWidget_check->setColumnWidth(5, 200);

    this->ui->tableWidget_sum->setColumnCount(7);
    this->ui->tableWidget_sum->setColumnWidth(0, width-700);
    this->ui->tableWidget_sum->setColumnWidth(1, 75);
    this->ui->tableWidget_sum->setColumnWidth(2, 75);
    this->ui->tableWidget_sum->setColumnWidth(3, 100);
    this->ui->tableWidget_sum->setColumnWidth(4, 100);
    this->ui->tableWidget_sum->setColumnWidth(5, 200);


    this->ui->tableWidget_sum->insertRow(0);
    this->ui->tableWidget_sum->setItem(0, 0, new QTableWidgetItem("Итого:"));
    this->ui->tableWidget_sum->setItem(0, 2, new QTableWidgetItem("0"));
    this->ui->tableWidget_sum->setItem(0, 3, new QTableWidgetItem("0.00"));
}

void MainWindow::shotr_keys_initialising()
{
    this->KeyF5 = new QShortcut(this);
    this->KeyF5->setKey(Qt::Key_F5);
    connect(this->KeyF5, SIGNAL(activated()), this, SLOT(on_pushButton_more_clicked()));


}


void MainWindow::on_pushButton_more_clicked()
{
    this->aw->show();
    this->aw->move((this->screen_width - aw->width())/2, (this->screen_heigth - aw->height())/2);
}
