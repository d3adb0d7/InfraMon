import React, { useState, useEffect } from 'react';
import { X, BarChart3, Clock, AlertCircle, CheckCircle } from 'lucide-react';
import { websitesAPI } from '../../services/api';

const WebsiteStats = ({ isOpen, onClose, website }) => {
  const [stats, setStats] = useState(null);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState('');

  useEffect(() => {
    if (isOpen && website) {
      loadStats();
    }
  }, [isOpen, website]);

  const loadStats = async () => {
    try {
      setLoading(true);
      const response = await websitesAPI.getStats(website.id);
      setStats(response.data);
    } catch (error) {
      setError(error.response?.data?.error || 'Failed to load statistics');
    } finally {
      setLoading(false);
    }
  };

  // Helper function to format percentage with 2 decimal places
  const formatPercentage = (value) => {
    if (value === null || value === undefined) return '0.00';
    return parseFloat(value).toFixed(2);
  };

  if (!isOpen || !website) return null;

  return (
    <div className="fixed inset-0 bg-gray-600 bg-opacity-75 flex items-center justify-center z-50">
      <div className="bg-white rounded-lg shadow-xl max-w-2xl w-full mx-4 max-h-[90vh] overflow-y-auto">
        <div className="flex items-center justify-between p-6 border-b border-gray-200">
          <h2 className="text-xl font-semibold text-gray-900">
            Statistics for {website.name || website.url}
          </h2>
          <button
            onClick={onClose}
            className="text-gray-400 hover:text-gray-600 transition-colors"
          >
            <X className="h-6 w-6" />
          </button>
        </div>

        <div className="p-6">
          {error && (
            <div className="bg-red-50 border border-red-200 text-red-600 px-4 py-3 rounded-md mb-4">
              {error}
            </div>
          )}

          {loading ? (
            <div className="flex justify-center items-center py-12">
              <div className="animate-spin rounded-full h-12 w-12 border-b-2 border-indigo-600"></div>
            </div>
          ) : stats ? (
            <div className="space-y-6">
              {/* Overview Stats */}
              <div className="grid grid-cols-1 md:grid-cols-3 gap-4">
                <div className="bg-blue-50 p-4 rounded-lg">
                  <div className="flex items-center">
                    <CheckCircle className="h-8 w-8 text-blue-600 mr-3" />
                    <div>
                      <p className="text-sm font-medium text-blue-600">Uptime</p>
                      <p className="text-2xl font-bold text-gray-900">
                        {formatPercentage(stats.uptimePercentage)}%
                      </p>
                    </div>
                  </div>
                </div>

                <div className="bg-green-50 p-4 rounded-lg">
                  <div className="flex items-center">
                    <CheckCircle className="h-8 w-8 text-green-600 mr-3" />
                    <div>
                      <p className="text-sm font-medium text-green-600">Up Checks</p>
                      <p className="text-2xl font-bold text-gray-900">
                        {stats.upChecks}
                      </p>
                    </div>
                  </div>
                </div>

                <div className="bg-red-50 p-4 rounded-lg">
                  <div className="flex items-center">
                    <AlertCircle className="h-8 w-8 text-red-600 mr-3" />
                    <div>
                      <p className="text-sm font-medium text-red-600">Down Checks</p>
                      <p className="text-2xl font-bold text-gray-900">
                        {stats.downChecks}
                      </p>
                    </div>
                  </div>
                </div>
              </div>

              {/* Response Time */}
              <div className="bg-gray-50 p-4 rounded-lg">
                <div className="flex items-center mb-4">
                  <Clock className="h-5 w-5 text-gray-600 mr-2" />
                  <h3 className="text-lg font-medium text-gray-900">Response Time</h3>
                </div>
                <p className="text-3xl font-bold text-gray-900">
                  {stats.avgResponseTime}ms
                </p>
                <p className="text-sm text-gray-600 mt-1">Average response time</p>
              </div>

              {/* Total Checks */}
              <div className="bg-gray-50 p-4 rounded-lg">
                <h3 className="text-lg font-medium text-gray-900 mb-4">Total Checks</h3>
                <p className="text-3xl font-bold text-gray-900">
                  {stats.totalChecks}
                </p>
                <p className="text-sm text-gray-600 mt-1">
                  {stats.upChecks} up • {stats.downChecks} down
                </p>
              </div>

              {/* Chart Data (if available) */}
              {stats.chartData && stats.chartData.length > 0 && (
                <div className="bg-gray-50 p-4 rounded-lg">
                  <div className="flex items-center mb-4">
                    <BarChart3 className="h-5 w-5 text-gray-600 mr-2" />
                    <h3 className="text-lg font-medium text-gray-900">Daily Uptime</h3>
                  </div>
                  <div className="space-y-2">
                    {stats.chartData.slice(-7).map((day, index) => (
                      <div key={index} className="flex items-center justify-between">
                        <span className="text-sm text-gray-600">{day.date}</span>
                        <div className="flex items-center space-x-2">
                          <div className="w-20 bg-gray-200 rounded-full h-2">
                            <div
                              className="bg-green-500 h-2 rounded-full"
                              style={{ width: `${day.uptime}%` }}
                            ></div>
                          </div>
                          <span className="text-sm font-medium text-gray-900 w-12">
                            {formatPercentage(day.uptime)}%
                          </span>
                        </div>
                      </div>
                    ))}
                  </div>
                </div>
              )}
            </div>
          ) : (
            <div className="text-center py-12">
              <BarChart3 className="mx-auto h-12 w-12 text-gray-400 mb-4" />
              <p className="text-gray-600">No statistics available yet.</p>
              <p className="text-sm text-gray-500 mt-1">
                Statistics will appear after the first monitoring check.
              </p>
            </div>
          )}
        </div>

        <div className="flex justify-end p-6 border-t border-gray-200">
          <button
            onClick={onClose}
            className="px-4 py-2 text-sm font-medium text-gray-700 bg-gray-200 rounded-md hover:bg-gray-300 focus:outline-none focus:ring-2 focus:ring-gray-500"
          >
            Close
          </button>
        </div>
      </div>
    </div>
  );
};

export default WebsiteStats;