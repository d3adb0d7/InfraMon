'use strict';

module.exports = {
  async up(queryInterface, Sequelize) {
    await queryInterface.addColumn('Websites', 'headers', {
      type: Sequelize.JSONB,
      defaultValue: [],
      allowNull: true
    });
  },

  async down(queryInterface, Sequelize) {
    await queryInterface.removeColumn('Websites', 'headers');
  }
};