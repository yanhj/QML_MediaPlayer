#include <QApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include "MaterialListModel.h"
#include <QtQuickWidgets/QQuickWidget>
#include <QDialog>

int main(int argc, char *argv[])
{
#if QT_VERSION < QT_VERSION_CHECK(6, 0, 0)
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
#endif

    QApplication app(argc, argv);


    MaterialListModel model;
    QList<stCommonMaterialNode*> datas;
    datas.push_back(new stCommonMaterialNode{1, "name1", "qrc:/assets/thumbnail.jpg"
                                             , "thumbnailUrl1", "previewUrl1", "qrc:/assets/music.mp3"
                                             , "", "category1", true});
    model.appendData(datas);
    QQmlApplicationEngine engine;

    if(0) {

    auto w = new QQuickWidget();
    w->engine()->rootContext()->setContextProperty("appMaterialListModel", &model);
    w->setSource(QUrl("qrc:/AudioMaterialListView.qml"));
    w->show();
    } else {
        engine.rootContext()->setContextProperty("appMaterialListModel", &model);
        const QUrl url(QStringLiteral("qrc:/main.qml"));
        QObject::connect(&engine, &QQmlApplicationEngine::objectCreated,
                         &app, [url](QObject *obj, const QUrl &objUrl) {
                    if (!obj && url == objUrl)
                        QCoreApplication::exit(-1);
                }, Qt::QueuedConnection);
        engine.load(url);
    }

    return app.exec();
}
