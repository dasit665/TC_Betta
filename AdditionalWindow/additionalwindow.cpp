#include "additionalwindow.h"
#include "ui_additionalwindow.h"
#include <QShortcut>
#include <QMessageBox>

AdditionalWindow::AdditionalWindow(QWidget *parent) :
    QMainWindow(parent),
    ui(new Ui::AdditionalWindow)
{
    ui->setupUi(this);
    this->init_shortcut_keys();
}

AdditionalWindow::~AdditionalWindow()
{
    delete ui;
}

void AdditionalWindow::init_shortcut_keys()
{
    this->key_escape = new QShortcut(this);
    this->key_escape->setKey(Qt::Key_Escape);
    connect(this->key_escape, SIGNAL(activated()), this, SLOT(on_escape_pressed()));

}
void AdditionalWindow::on_escape_pressed()
{
    this->close();
}


