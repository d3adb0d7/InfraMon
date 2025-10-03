'use strict';

module.exports = {
  async up(queryInterface, Sequelize) {
    // Update existing users with default cooldown value
    await queryInterface.sequelize.query(`
      UPDATE "Users" 
      SET "alertPreferences" = jsonb_set(
        COALESCE("alertPreferences", '{}'::jsonb),
        '{alertCooldown}',
        '30'
      )
      WHERE "alertPreferences" IS NULL OR "alertPreferences"->'alertCooldown' IS NULL
    `);
  },

  async down(queryInterface, Sequelize) {
    // Remove alertCooldown from preferences
    await queryInterface.sequelize.query(`
      UPDATE "Users" 
      SET "alertPreferences" = "alertPreferences" - 'alertCooldown'
      WHERE "alertPreferences"->'alertCooldown' IS NOT NULL
    `);
  }
};