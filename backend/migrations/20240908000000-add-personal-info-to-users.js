'use strict';

module.exports = {
  async up(queryInterface, Sequelize) {
    // Add new columns for personal information
    await queryInterface.addColumn('Users', 'firstName', {
      type: Sequelize.STRING,
      allowNull: true
    });

    await queryInterface.addColumn('Users', 'lastName', {
      type: Sequelize.STRING,
      allowNull: true
    });

    await queryInterface.addColumn('Users', 'phone', {
      type: Sequelize.STRING,
      allowNull: true
    });
  },

  async down(queryInterface, Sequelize) {
    // Remove the columns if rolling back
    await queryInterface.removeColumn('Users', 'firstName');
    await queryInterface.removeColumn('Users', 'lastName');
    await queryInterface.removeColumn('Users', 'phone');
  }
};