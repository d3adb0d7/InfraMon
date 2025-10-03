'use strict';
const {
  Model
} = require('sequelize');
module.exports = (sequelize, DataTypes) => {
  class Alert extends Model {
    static associate(models) {
      Alert.belongsTo(models.Website, { foreignKey: 'websiteId' });
      Alert.belongsTo(models.User, { foreignKey: 'userId' });
    }
  }
  Alert.init({
    type: DataTypes.ENUM('email', 'telegram'),
    sentAt: DataTypes.DATE,
    message: DataTypes.TEXT,
    websiteId: DataTypes.INTEGER,
    userId: DataTypes.INTEGER
  }, {
    sequelize,
    modelName: 'Alert',
  });
  return Alert;
};