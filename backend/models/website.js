'use strict';
const {
  Model
} = require('sequelize');
module.exports = (sequelize, DataTypes) => {
  class Website extends Model {
    static associate(models) {
      Website.belongsTo(models.User, { foreignKey: 'userId' });
      Website.hasMany(models.MonitorLog, { foreignKey: 'websiteId' });
      Website.hasMany(models.Alert, { foreignKey: 'websiteId' });
    }
  }
  Website.init({
    url: DataTypes.STRING,
    name: DataTypes.STRING,
    interval: DataTypes.INTEGER,
    httpMethod: DataTypes.ENUM('GET', 'POST', 'HEAD', 'OPTIONS', 'PING', 'CURL_GET', 'CURL_POST', 'CUSTOM_CURL'),
    expectedStatusCodes: DataTypes.ARRAY(DataTypes.INTEGER),
    isActive: DataTypes.BOOLEAN,
    userId: DataTypes.INTEGER,
    headers: {
      type: DataTypes.JSONB,
      defaultValue: []
    },
    customCurlCommand: DataTypes.TEXT
  }, {
    sequelize,
    modelName: 'Website',
  });
  return Website;
};