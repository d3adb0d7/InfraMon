'use strict';
const {
  Model
} = require('sequelize');
module.exports = (sequelize, DataTypes) => {
  class MonitorLog extends Model {
    static associate(models) {
      MonitorLog.belongsTo(models.Website, { foreignKey: 'websiteId' });
    }
  }
  MonitorLog.init({
    status: DataTypes.ENUM('up', 'down'),
    responseTime: DataTypes.INTEGER,
    statusCode: DataTypes.INTEGER,
    message: DataTypes.TEXT,
    websiteId: DataTypes.INTEGER
  }, {
    sequelize,
    modelName: 'MonitorLog',
  });
  return MonitorLog;
};