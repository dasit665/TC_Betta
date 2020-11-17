#ifndef DB_CHOICE_H
#define DB_CHOICE_H

#include <QWidget>

namespace Ui {
class DB_choice;
}

class DB_choice : public QWidget
{
    Q_OBJECT

    QWidget * caller;

public:
    explicit DB_choice(QWidget *parent = nullptr, QWidget * caller = nullptr);
    ~DB_choice();

private slots:
    void on_pushButton_ok_clicked();

    void on_pushButton_Cancel_clicked();

private:
    Ui::DB_choice *ui;
};

#endif // DB_CHOICE_H
