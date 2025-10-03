'use strict';

module.exports = {
  async up(queryInterface, Sequelize) {
    // Step 1: Remove the default value constraint temporarily
    await queryInterface.sequelize.query(`
      ALTER TABLE "Websites" 
      ALTER COLUMN "httpMethod" 
      DROP DEFAULT;
    `);

    // Step 2: Change the column type to TEXT temporarily
    await queryInterface.sequelize.query(`
      ALTER TABLE "Websites" 
      ALTER COLUMN "httpMethod" 
      TYPE TEXT;
    `);

    // Step 3: Drop the old enum type
    await queryInterface.sequelize.query(`
      DROP TYPE IF EXISTS "enum_Websites_httpMethod";
    `);

    // Step 4: Create the new enum type with CURL methods
    await queryInterface.sequelize.query(`
      CREATE TYPE "enum_Websites_httpMethod" AS ENUM (
        'GET', 'POST', 'HEAD', 'OPTIONS', 'PING', 'CURL_GET', 'CURL_POST'
      );
    `);

    // Step 5: Convert the column back to the new enum type
    await queryInterface.sequelize.query(`
      ALTER TABLE "Websites" 
      ALTER COLUMN "httpMethod" 
      TYPE "enum_Websites_httpMethod" 
      USING "httpMethod"::"enum_Websites_httpMethod";
    `);

    // Step 6: Restore the default value
    await queryInterface.sequelize.query(`
      ALTER TABLE "Websites" 
      ALTER COLUMN "httpMethod" 
      SET DEFAULT 'GET';
    `);
  },

  async down(queryInterface, Sequelize) {
    // Reverse the process
    await queryInterface.sequelize.query(`
      ALTER TABLE "Websites" 
      ALTER COLUMN "httpMethod" 
      DROP DEFAULT;
    `);

    await queryInterface.sequelize.query(`
      ALTER TABLE "Websites" 
      ALTER COLUMN "httpMethod" 
      TYPE TEXT;
    `);

    await queryInterface.sequelize.query(`
      DROP TYPE IF EXISTS "enum_Websites_httpMethod";
    `);

    await queryInterface.sequelize.query(`
      CREATE TYPE "enum_Websites_httpMethod" AS ENUM (
        'GET', 'POST', 'HEAD', 'OPTIONS', 'PING'
      );
    `);

    await queryInterface.sequelize.query(`
      ALTER TABLE "Websites" 
      ALTER COLUMN "httpMethod" 
      TYPE "enum_Websites_httpMethod" 
      USING CASE 
        WHEN "httpMethod" IN ('CURL_GET', 'CURL_POST') THEN 'GET'::"enum_Websites_httpMethod"
        ELSE "httpMethod"::"enum_Websites_httpMethod"
      END;
    `);

    await queryInterface.sequelize.query(`
      ALTER TABLE "Websites" 
      ALTER COLUMN "httpMethod" 
      SET DEFAULT 'GET';
    `);
  }
};