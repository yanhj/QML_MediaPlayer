//********************************************************
/// @brief 
/// @author yanhuajian
/// @date 2023/7/6
/// @note
/// @version 1.0.0
//********************************************************

#include <QFile>
#include <QJsonObject>
#include "MaterialListModel.h"

MaterialListModel::MaterialListModel(QObject* parent)
: QAbstractItemModel(parent)
, m_columnCount(1) {
}

MaterialListModel::~MaterialListModel() {
}

QModelIndex MaterialListModel::index(int row, int column, const QModelIndex &parent) const {
    if (row < 0 || column < 0) {
        return QModelIndex();
    }
    int index = row * columnCount(parent) + column;
    if(index < m_lstData.size()) {
        return createIndex(row, column, m_lstData[index]);
    }
    return QModelIndex();
}

QModelIndex MaterialListModel::parent(const QModelIndex &child) const {
    return QModelIndex();
}

int MaterialListModel::rowCount(const QModelIndex &parent) const {
    if(m_columnCount <= 0) {
        return m_lstData.size();
    }
    return m_lstData.size() / m_columnCount;
}

int MaterialListModel::columnCount(const QModelIndex &parent) const {
    return qMax(1, m_columnCount);
}

void MaterialListModel::setColumnCount(int columnCount) {
    auto newColumn = qMax(1, columnCount);
    if(newColumn == m_columnCount) {
        return;
    }
    beginResetModel();
    m_columnCount = newColumn;
    endResetModel();
}

QVariant MaterialListModel::data(const QModelIndex &index, int role) const {
    if(!index.isValid()) {
        return QVariant();
    }
    auto record = static_cast<stCommonMaterialNode*>(index.internalPointer());
    if(nullptr == record) {
        return QVariant();
    }
    switch (role) {
        case Qt::DecorationRole:
            return record->thumbnailUrl;
        case Qt::DisplayRole:
            return record->name;
        case MaterialListRole::kMaterialID:
            return QString::number(1);
        case MaterialListRole::kName:
            return record->name;
        case MaterialListRole::kThumbnailUrl:
            return record->thumbnailUrl;
        case MaterialListRole::kThumbnail:
            if(record->thumbnail.startsWith("qrc:")) {
                return record->thumbnail;
            }
            if(record->thumbnail.isNull() && !record->thumbnailUrl.isEmpty()) {
                return "";
            }
            return "file:///" + record->thumbnail;
        case MaterialListRole::kPreviewUrl:
            return record->previewUrl;
        case MaterialListRole::kFile:
            return record->file;
        case MaterialListRole::kFileUrl:
            return record->fileUrl;
        case MaterialListRole::kCategory:
            return m_category;
        case MaterialListRole::kDownloaded:
            return QFile::exists(record->file)
            || (record->fileUrl.isEmpty() && record->file.isEmpty());
    }

    return QVariant();
}

QHash<int, QByteArray> MaterialListModel::roleNames() const {
    QHash<int, QByteArray> roles;
    roles.insert(kMaterialID, "materialId");
    roles.insert(kName, "name");
    roles.insert(kThumbnailUrl, "thumbnailUrl");
    roles.insert(kThumbnail, "thumbnail");
    roles.insert(kPreviewUrl, "previewUrl");
    roles.insert(kFile, "file");
    roles.insert(kFileUrl, "fileUrl");
    roles.insert(kCategory, "category");
    roles.insert(kDownloaded, "downloaded");
    return roles;
}

void MaterialListModel::setCategory(const QString &category) {
    m_category = category;
}

void MaterialListModel::resetData(const QList<stCommonMaterialNode *> &lstData) {
    beginResetModel();
    m_lstData.clear();
    m_lstData.append(lstData);
    endResetModel();
}

void MaterialListModel::appendData(const QList<stCommonMaterialNode *> &lstData) {
    int oldRow = m_lstData.size() / columnCount(QModelIndex());
    beginInsertRows(QModelIndex(), oldRow, (m_lstData.size() + lstData.size()) - 1);
    m_lstData.append(lstData);
    endInsertRows();
}

