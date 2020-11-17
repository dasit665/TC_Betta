#ifndef MAINWINDOW_H
#define MAINWINDOW_H

#include <QMainWindow>
#include <QShortcut>
#include <AdditionalWindow/additionalwindow.h>

namespace Ui {
class MainWindow;
}

class MainWindow : public QMainWindow
{
    Q_OBJECT

    Ui::MainWindow *ui;

    AdditionalWindow * aw;

    QShortcut * KeyF5;

    int screen_width, screen_heigth;
public:
    explicit MainWindow(QWidget *parent = nullptr, int wigth = 0, int height = 0);

    ~MainWindow();


private slots:
    void on_pushButton_more_clicked();

private:
    void table_formating(int width);
    void shotr_keys_initialising();



};

#endif // MAINWINDOW_H
