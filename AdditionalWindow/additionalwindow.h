#ifndef ADDITIONALWINDOW_H
#define ADDITIONALWINDOW_H

#include <QMainWindow>
#include <QShortcut>
#include <QSettings>

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
    QSettings * settings = new QSettings("RUSH","TC_Betta");

    void init_shortcut_keys();
    void init_footer();

private slots:
    void on_escape_pressed();
};

#endif // ADDITIONALWINDOW_H
