'use strict';

module.exports = {
  async up(queryInterface, Sequelize) {
    // First add the column as nullable temporarily
    await queryInterface.addColumn('Users', 'alertPreferences', {
      type: Sequelize.JSONB,
      allowNull: true, // Temporary - allow null during migration
      defaultValue: null
    });

    // Then update existing records with default values
    await queryInterface.sequelize.query(`
      UPDATE "Users" 
      SET "alertPreferences" = '{
        "email": true,
        "telegram": false,
        "minUptime": 99.5,
        "notifyOnUp": true,
        "notifyOnDown": true,
        "alertCooldown": 30,
        "quietHours": {
          "enabled": false,
          "start": "22:00",
          "end": "06:00"
        }
      }'::jsonb
      WHERE "alertPreferences" IS NULL
    `);

    // Finally, change the column to NOT NULL with proper default
    await queryInterface.changeColumn('Users', 'alertPreferences', {
      type: Sequelize.JSONB,
      allowNull: false,
      defaultValue: Sequelize.literal(`'{
        "email": true,
        "telegram": false,
        "minUptime": 99.5,
        "notifyOnUp": true,
        "notifyOnDown": true,
        "alertCooldown": 30,
        "quietHours": {
          "enabled": false,
          "start": "22:00",
          "end": "06:00"
        }
      }'::jsonb`)
    });
  },

  async down(queryInterface, Sequelize) {
    await queryInterface.removeColumn('Users', 'alertPreferences');
  }
};