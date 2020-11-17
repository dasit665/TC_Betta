#ifndef ADDITIONALWINDOW_H
#define ADDITIONALWINDOW_H

#include <QMainWindow>
#include <QShortcut>

namespace Ui {
class AdditionalWindow;
}

class AdditionalWindow : public QMainWindow
{
    Q_OBJECT
    Ui::AdditionalWindow *ui;

    QShortcut * key_escape;

public:
    explicit AdditionalWindow(QWidget *parent = nullptr);
    ~AdditionalWindow();


private:
    void init_shortcut_keys();

private slots:
    void on_escape_pressed();
};

#endif // ADDITIONALWINDOW_H
