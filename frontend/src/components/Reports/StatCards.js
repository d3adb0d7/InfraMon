import React from 'react';
import { 
  Globe, 
  CheckCircle, 
  AlertCircle, 
  Clock, 
  Bell,
  TrendingUp,
  Zap
} from 'lucide-react';

const StatCards = ({ overviewData, loading }) => {
  const stats = [
    {
      title: 'Websites Monitored',
      value: overviewData?.totalWebsites || 0,
      icon: Globe,
      color: 'blue',
      change: null
    },
    {
      title: 'Uptime Percentage',
      value: overviewData?.uptimePercentage ? `${overviewData.uptimePercentage}%` : '0%',
      icon: CheckCircle,
      color: 'green',
      change: null
    },
    {
      title: 'Avg Response Time',
      value: overviewData?.avgResponseTime ? `${overviewData.avgResponseTime}ms` : '0ms',
      icon: Clock,
      color: 'purple',
      change: null
    },
    {
      title: 'Total Checks',
      value: overviewData?.totalChecks || 0,
      icon: TrendingUp,
      color: 'indigo',
      change: null
    },
    {
      title: 'Alerts Sent',
      value: overviewData?.alertsCount || 0,
      icon: Bell,
      color: 'red',
      change: null
    },
    {
      title: 'Current Status',
      value: overviewData?.statusDistribution ? 
        `${overviewData.statusDistribution.up || 0} Up / ${overviewData.statusDistribution.down || 0} Down` : 
        '0 Up / 0 Down',
      icon: Zap,
      color: 'yellow',
      change: null
    }
  ];

  const colorClasses = {
    blue: 'bg-blue-50 text-blue-600 border-blue-200',
    green: 'bg-green-50 text-green-600 border-green-200',
    purple: 'bg-purple-50 text-purple-600 border-purple-200',
    indigo: 'bg-indigo-50 text-indigo-600 border-indigo-200',
    red: 'bg-red-50 text-red-600 border-red-200',
    yellow: 'bg-yellow-50 text-yellow-600 border-yellow-200'
  };

  if (loading) {
    return (
      <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6 mb-8">
        {[...Array(6)].map((_, index) => (
          <div key={index} className="bg-gray-100 rounded-xl p-6 animate-pulse">
            <div className="h-6 bg-gray-300 rounded w-3/4 mb-4"></div>
            <div className="h-8 bg-gray-300 rounded w-1/2"></div>
          </div>
        ))}
      </div>
    );
  }

  return (
    <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6 mb-8">
      {stats.map((stat, index) => {
        const Icon = stat.icon;
        return (
          <div key={index} className={`border-2 rounded-xl p-6 transition-all duration-200 hover:shadow-lg ${colorClasses[stat.color]}`}>
            <div className="flex items-center justify-between">
              <div>
                <p className="text-sm font-medium opacity-80">{stat.title}</p>
                <p className="text-2xl font-bold mt-2">{stat.value}</p>
              </div>
              <div className={`p-3 rounded-full bg-white bg-opacity-50`}>
                <Icon className="h-6 w-6" />
              </div>
            </div>
            {stat.change && (
              <div className={`mt-2 text-sm ${stat.change > 0 ? 'text-green-600' : 'text-red-600'}`}>
                {stat.change > 0 ? '↑' : '↓'} {Math.abs(stat.change)}% from previous period
              </div>
            )}
          </div>
        );
      })}
    </div>
  );
};

export default StatCards;