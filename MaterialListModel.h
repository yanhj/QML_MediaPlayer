//********************************************************
/// @brief 配方列表模型类
/// @author yanhuajian
/// @date 2023/7/6
/// @note
/// @version 1.0.0
//********************************************************

#pragma once

#include <QAbstractItemModel>

struct stCommonMaterialNode
{
    int64_t id;
    QString name;
    QString thumbnail;
    QString thumbnailUrl;
    QString previewUrl;
    QString file;
    QString fileUrl;
    QString category;
    bool downloaded;
};

class MaterialListModel : public QAbstractItemModel {
    Q_OBJECT
public:
enum MaterialListRole {
        kMaterialID = Qt::UserRole + 1,
        kName,
        kThumbnail,
        kThumbnailUrl,
        kPreviewUrl,
        kFile,
        kFileUrl,
        kCategory,
        kDownloaded,
    };
    explicit MaterialListModel(QObject*parent = nullptr);
    ~MaterialListModel();

public:
    // QAbstractItemModel interface
    Q_INVOKABLE QModelIndex index(int row, int column, const QModelIndex &parent) const override;
    Q_INVOKABLE QModelIndex parent(const QModelIndex &child) const override;
    Q_INVOKABLE int rowCount(const QModelIndex &parent) const override;
    Q_INVOKABLE int columnCount(const QModelIndex &parent) const override;
    Q_INVOKABLE QVariant data(const QModelIndex &index, int role = Qt::DisplayRole) const override;

    Q_INVOKABLE void setColumnCount(int columnCount);
    Q_INVOKABLE QHash<int, QByteArray> roleNames() const override;

    void setCategory(const QString& category);
    void resetData(const QList<stCommonMaterialNode *> &lstData);
    void appendData(const QList<stCommonMaterialNode *> &lstData);

Q_SIGNALS:
    void downloadThumbnail(int64_t id, const QString& url) const;

private:
    QList<stCommonMaterialNode*> m_lstData; //内部不会进行指针删除
    int m_columnCount;
    QString m_category;
};


