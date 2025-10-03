'use strict';

module.exports = {
  async up(queryInterface, Sequelize) {
    // Create Users table first
    await queryInterface.createTable('Users', {
      // ... user table definition
    });

    // Create Websites table with PING enum
    await queryInterface.createTable('Websites', {
      id: {
        allowNull: false,
        autoIncrement: true,
        primaryKey: true,
        type: Sequelize.INTEGER
      },
      url: {
        type: Sequelize.STRING,
        allowNull: false
      },
      name: {
        type: Sequelize.STRING,
        allowNull: true
      },
      interval: {
        type: Sequelize.INTEGER,
        defaultValue: 5
      },
      httpMethod: {
        type: Sequelize.ENUM('GET', 'POST', 'HEAD', 'OPTIONS', 'PING'), // PING included
        defaultValue: 'GET'
      },
      expectedStatusCodes: {
        type: Sequelize.ARRAY(Sequelize.INTEGER),
        defaultValue: [200]
      },
      isActive: {
        type: Sequelize.BOOLEAN,
        defaultValue: true
      },
      userId: {
        type: Sequelize.INTEGER,
        references: {
          model: 'Users',
          key: 'id'
        },
        onUpdate: 'CASCADE',
        onDelete: 'CASCADE'
      },
      createdAt: {
        allowNull: false,
        type: Sequelize.DATE
      },
      updatedAt: {
        allowNull: false,
        type: Sequelize.DATE
      }
    });

    // Create other tables...
  },

  async down(queryInterface, Sequelize) {
    // Drop tables in reverse order
    await queryInterface.dropTable('Alerts');
    await queryInterface.dropTable('MonitorLogs');
    await queryInterface.dropTable('Websites');
    await queryInterface.dropTable('Users');
  }
};