const sequelize = require('../config/database');
const { DataTypes } = require('sequelize');
const bcrypt = require('bcryptjs');

const User = sequelize.define('User', {
  id: {
    type: DataTypes.INTEGER,
    primaryKey: true,
    autoIncrement: true
  },
  username: {
    type: DataTypes.STRING,
    allowNull: false,
    unique: true
  },
  email: {
    type: DataTypes.STRING,
    allowNull: false,
    unique: true,
    validate: {
      isEmail: true
    }
  },
  password: {
    type: DataTypes.STRING,
    allowNull: false
  },
  firstName: {
    type: DataTypes.STRING,
    allowNull: true
  },
  lastName: {
    type: DataTypes.STRING,
    allowNull: true
  },
  phone: {
    type: DataTypes.STRING,
    allowNull: true
  },
  role: {
    type: DataTypes.ENUM('admin', 'user', 'monitoring_user'),
    defaultValue: 'user'
  },
  telegramChatId: {
    type: DataTypes.STRING,
    allowNull: true
  },
  isActive: {
    type: DataTypes.BOOLEAN,
    defaultValue: true
  },
  alertPreferences: {
    type: DataTypes.JSONB,
    allowNull: false,
    defaultValue: {
      email: true,
      telegram: false,
      minUptime: 99.5,
      notifyOnUp: true,
      notifyOnDown: true,
      alertCooldown: 30,
      quietHours: {
        enabled: false,
        start: '22:00',
        end: '06:00'
      }
    }
  }
}, {
  hooks: {
    beforeCreate: async (user) => {
      if (user.password) {
        user.password = await bcrypt.hash(user.password, 12);
      }
    },
    beforeUpdate: async (user) => {
      // Only hash if password is being changed
      if (user.changed('password') && user.password) {
        user.password = await bcrypt.hash(user.password, 12);
      }
    }
  }
});

const Website = sequelize.define('Website', {
  id: {
    type: DataTypes.INTEGER,
    primaryKey: true,
    autoIncrement: true
  },
  url: {
    type: DataTypes.STRING,
    allowNull: false
  },
  name: {
    type: DataTypes.STRING,
    allowNull: true
  },
  interval: {
    type: DataTypes.INTEGER,
    defaultValue: 5
  },
  httpMethod: {
    type: DataTypes.ENUM('GET', 'POST', 'HEAD', 'OPTIONS', 'PING', 'CURL_GET', 'CURL_POST', 'CUSTOM_CURL'),
    defaultValue: 'GET'
  },
  expectedStatusCodes: {
    type: DataTypes.ARRAY(DataTypes.INTEGER),
    defaultValue: [200]
  },
  isActive: {
    type: DataTypes.BOOLEAN,
    defaultValue: true
  },
  headers: {
    type: DataTypes.JSONB,
    defaultValue: []
  },
  customCurlCommand: {
    type: DataTypes.TEXT,
    allowNull: true
  }
});

const MonitorLog = sequelize.define('MonitorLog', {
  id: {
    type: DataTypes.INTEGER,
    primaryKey: true,
    autoIncrement: true
  },
  status: {
    type: DataTypes.ENUM('up', 'down'),
    allowNull: false
  },
  responseTime: {
    type: DataTypes.INTEGER,
    allowNull: true
  },
  statusCode: {
    type: DataTypes.INTEGER,
    allowNull: true
  },
  message: {
    type: DataTypes.TEXT,
    allowNull: true
  }
});

const Alert = sequelize.define('Alert', {
  id: {
    type: DataTypes.INTEGER,
    primaryKey: true,
    autoIncrement: true
  },
  type: {
    type: DataTypes.ENUM('email', 'telegram'),
    allowNull: false
  },
  sentAt: {
    type: DataTypes.DATE,
    defaultValue: DataTypes.NOW
  },
  message: {
    type: DataTypes.TEXT,
    allowNull: false
  }
});

// Define relationships with proper onDelete constraints
User.hasMany(Website, { 
  foreignKey: 'userId', 
  onDelete: 'CASCADE' 
});
Website.belongsTo(User, { 
  foreignKey: 'userId' 
});

Website.hasMany(MonitorLog, { 
  foreignKey: 'websiteId', 
  onDelete: 'CASCADE' 
});
MonitorLog.belongsTo(Website, { 
  foreignKey: 'websiteId' 
});

Website.hasMany(Alert, { 
  foreignKey: 'websiteId', 
  onDelete: 'CASCADE' 
});
Alert.belongsTo(Website, { 
  foreignKey: 'websiteId' 
});

User.hasMany(Alert, { 
  foreignKey: 'userId', 
  onDelete: 'CASCADE' 
});
Alert.belongsTo(User, { 
  foreignKey: 'userId' 
});

module.exports = {
  sequelize,
  User,
  Website,
  MonitorLog,
  Alert
};