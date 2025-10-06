// migrations/20240910000000-complete-initial-schema.js
'use strict';

module.exports = {
  async up(queryInterface, Sequelize) {
    console.log('Creating complete initial schema...');

    // Create enum types first
    await queryInterface.sequelize.query(`
      DO $$ BEGIN
        CREATE TYPE "enum_Users_role" AS ENUM ('admin', 'user', 'monitoring_user');
      EXCEPTION
        WHEN duplicate_object THEN null;
      END $$;
    `);

    await queryInterface.sequelize.query(`
      DO $$ BEGIN
        CREATE TYPE "enum_Websites_httpMethod" AS ENUM ('GET', 'POST', 'HEAD', 'OPTIONS', 'PING', 'CURL_GET', 'CURL_POST', 'CUSTOM_CURL');
      EXCEPTION
        WHEN duplicate_object THEN null;
      END $$;
    `);

    await queryInterface.sequelize.query(`
      DO $$ BEGIN
        CREATE TYPE "enum_MonitorLogs_status" AS ENUM ('up', 'down');
      EXCEPTION
        WHEN duplicate_object THEN null;
      END $$;
    `);

    await queryInterface.sequelize.query(`
      DO $$ BEGIN
        CREATE TYPE "enum_Alerts_type" AS ENUM ('email', 'telegram');
      EXCEPTION
        WHEN duplicate_object THEN null;
      END $$;
    `);

    // Create Users table (no dependencies)
    const usersTableExists = await queryInterface.sequelize.query(`
      SELECT EXISTS (
        SELECT FROM information_schema.tables 
        WHERE table_schema = 'public' 
        AND table_name = 'Users'
      );
    `);

    if (!usersTableExists[0][0].exists) {
      await queryInterface.createTable('Users', {
        id: {
          allowNull: false,
          autoIncrement: true,
          primaryKey: true,
          type: Sequelize.INTEGER
        },
        username: {
          type: Sequelize.STRING,
          allowNull: false,
          unique: true
        },
        email: {
          type: Sequelize.STRING,
          allowNull: false,
          unique: true
        },
        password: {
          type: Sequelize.STRING,
          allowNull: false
        },
        firstName: {
          type: Sequelize.STRING,
          allowNull: true
        },
        lastName: {
          type: Sequelize.STRING,
          allowNull: true
        },
        phone: {
          type: Sequelize.STRING,
          allowNull: true
        },
        role: {
          type: Sequelize.ENUM('admin', 'user', 'monitoring_user'),
          defaultValue: 'user'
        },
        telegramChatId: {
          type: Sequelize.STRING,
          allowNull: true
        },
        isActive: {
          type: Sequelize.BOOLEAN,
          defaultValue: true
        },
        alertPreferences: {
          type: Sequelize.JSONB,
          allowNull: true,
          defaultValue: null
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
    }

    // Create Websites table (depends on Users)
    const websitesTableExists = await queryInterface.sequelize.query(`
      SELECT EXISTS (
        SELECT FROM information_schema.tables 
        WHERE table_schema = 'public' 
        AND table_name = 'Websites'
      );
    `);

    if (!websitesTableExists[0][0].exists) {
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
          type: Sequelize.ENUM('GET', 'POST', 'HEAD', 'OPTIONS', 'PING', 'CURL_GET', 'CURL_POST', 'CUSTOM_CURL'),
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
        headers: {
          type: Sequelize.JSONB,
          defaultValue: []
        },
        customCurlCommand: {
          type: Sequelize.TEXT,
          allowNull: true
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
    }

    // Create MonitorLogs table (depends on Websites)
    const monitorLogsTableExists = await queryInterface.sequelize.query(`
      SELECT EXISTS (
        SELECT FROM information_schema.tables 
        WHERE table_schema = 'public' 
        AND table_name = 'MonitorLogs'
      );
    `);

    if (!monitorLogsTableExists[0][0].exists) {
      await queryInterface.createTable('MonitorLogs', {
        id: {
          allowNull: false,
          autoIncrement: true,
          primaryKey: true,
          type: Sequelize.INTEGER
        },
        status: {
          type: Sequelize.ENUM('up', 'down'),
          allowNull: false
        },
        responseTime: {
          type: Sequelize.INTEGER,
          allowNull: true
        },
        statusCode: {
          type: Sequelize.INTEGER,
          allowNull: true
        },
        message: {
          type: Sequelize.TEXT,
          allowNull: true
        },
        websiteId: {
          type: Sequelize.INTEGER,
          references: {
            model: 'Websites',
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
    }

    // Create Alerts table (depends on Websites and Users)
    const alertsTableExists = await queryInterface.sequelize.query(`
      SELECT EXISTS (
        SELECT FROM information_schema.tables 
        WHERE table_schema = 'public' 
        AND table_name = 'Alerts'
      );
    `);

    if (!alertsTableExists[0][0].exists) {
      await queryInterface.createTable('Alerts', {
        id: {
          allowNull: false,
          autoIncrement: true,
          primaryKey: true,
          type: Sequelize.INTEGER
        },
        type: {
          type: Sequelize.ENUM('email', 'telegram'),
          allowNull: false
        },
        sentAt: {
          type: Sequelize.DATE,
          defaultValue: Sequelize.NOW
        },
        message: {
          type: Sequelize.TEXT,
          allowNull: false
        },
        websiteId: {
          type: Sequelize.INTEGER,
          references: {
            model: 'Websites',
            key: 'id'
          },
          onUpdate: 'CASCADE',
          onDelete: 'CASCADE'
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
    }

    console.log('Complete initial schema created successfully');
  },

  async down(queryInterface, Sequelize) {
    // Drop tables in reverse order
    await queryInterface.dropTable('Alerts');
    await queryInterface.dropTable('MonitorLogs');
    await queryInterface.dropTable('Websites');
    await queryInterface.dropTable('Users');

    // Drop enum types
    await queryInterface.sequelize.query(`
      DROP TYPE IF EXISTS "enum_Alerts_type";
    `);
    await queryInterface.sequelize.query(`
      DROP TYPE IF EXISTS "enum_MonitorLogs_status";
    `);
    await queryInterface.sequelize.query(`
      DROP TYPE IF EXISTS "enum_Websites_httpMethod";
    `);
    await queryInterface.sequelize.query(`
      DROP TYPE IF EXISTS "enum_Users_role";
    `);
  }
};