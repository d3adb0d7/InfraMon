// frontend/src/components/Alerts/AlertStats.js
import React from 'react';
import { Mail, MessageSquare, AlertTriangle, TrendingUp, Clock } from 'lucide-react';

const AlertStats = ({ stats, loading }) => {
  const statCards = [
    {
      title: 'Total Alerts',
      value: stats?.total || 0,
      icon: AlertTriangle,
      color: 'red',
      description: 'All time alerts'
    },
    {
      title: 'Email Alerts',
      value: stats?.byType?.email || 0,
      icon: Mail,
      color: 'blue',
      description: 'Sent via email'
    },
    {
      title: 'Telegram Alerts',
      value: stats?.byType?.telegram || 0,
      icon: MessageSquare,
      color: 'green',
      description: 'Sent via Telegram'
    },
    {
      title: 'Recent Alerts',
      value: stats?.recentAlerts?.length || 0,
      icon: Clock,
      color: 'purple',
      description: 'Last 7 days'
    }
  ];

  const colorClasses = {
    red: 'bg-red-50 border-red-200 text-red-600',
    blue: 'bg-blue-50 border-blue-200 text-blue-600',
    green: 'bg-green-50 border-green-200 text-green-600',
    purple: 'bg-purple-50 border-purple-200 text-purple-600'
  };

  if (loading) {
    return (
      <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6 mb-8">
        {[...Array(4)].map((_, index) => (
          <div key={index} className="bg-gray-100 rounded-xl p-6 animate-pulse">
            <div className="h-6 bg-gray-300 rounded w-3/4 mb-4"></div>
            <div className="h-8 bg-gray-300 rounded w-1/2"></div>
          </div>
        ))}
      </div>
    );
  }

  return (
    <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6 mb-8">
      {statCards.map((stat, index) => {
        const Icon = stat.icon;
        return (
          <div key={index} className={`border-2 rounded-xl p-6 transition-all duration-200 hover:shadow-lg ${colorClasses[stat.color]}`}>
            <div className="flex items-center justify-between">
              <div>
                <p className="text-sm font-medium opacity-80">{stat.title}</p>
                <p className="text-2xl font-bold mt-2">{stat.value.toLocaleString()}</p>
                <p className="text-xs opacity-70 mt-1">{stat.description}</p>
              </div>
              <div className="p-3 rounded-full bg-white bg-opacity-50">
                <Icon className="h-6 w-6" />
              </div>
            </div>
          </div>
        );
      })}
    </div>
  );
};

export default AlertStats;