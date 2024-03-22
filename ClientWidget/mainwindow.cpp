#include "mainwindow.h"
#include "ui_mainwindow.h"


MainWindow::MainWindow(QWidget *parent)
    : QMainWindow(parent)
    , ui(new Ui::MainWindow)
{
    ui->setupUi(this);
}

MainWindow::~MainWindow()
{
    delete ui;
}


void MainWindow::on_connectButton_clicked()
{
    ws = new QWebSocket;
    ws->open(QUrl("ws://127.0.0.1:8080"));
    ui->chatBrowser->append("Connected");
    qDebug() << "Connected";

    connect(ws, &QWebSocket::textMessageReceived, [&](QString message) {
        ui->chatBrowser->append(message);
    });

    connect(ws, &QWebSocket::disconnected, ws, &QWebSocket::deleteLater);
}


void MainWindow::on_sendButton_clicked()
{
    ws->sendTextMessage(ui->writeMessage->text());
    ui->writeMessage->clear();
}

