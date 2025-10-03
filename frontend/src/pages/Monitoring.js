import React, { useState, useEffect } from 'react';
import { useMonitoring } from '../contexts/MonitoringContext';
import { websitesAPI } from '../services/api';
import { 
  Wifi, 
  WifiOff, 
  Server, 
  RefreshCw, 
  AlertCircle, 
  CheckCircle,
  Filter,
  X,
  Clock
} from 'lucide-react';

const Monitoring = () => {
  const { statuses, manualCheck } = useMonitoring();
  const [websites, setWebsites] = useState([]);
  const [manualChecking, setManualChecking] = useState({});
  const [filter, setFilter] = useState('all');
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    loadWebsites();
  }, []);

  const loadWebsites = async () => {
    try {
      const response = await websitesAPI.getAll();
      setWebsites(response.data);
    } catch (error) {
      console.error('Error loading websites:', error);
    } finally {
      setLoading(false);
    }
  };

  const handleManualCheck = async (websiteId) => {
    setManualChecking(prev => ({ ...prev, [websiteId]: true }));
    try {
      await manualCheck(websiteId);
    } catch (error) {
      console.error('Manual check failed:', error);
    } finally {
      setManualChecking(prev => ({ ...prev, [websiteId]: false }));
    }
  };

  const getStatusCount = (status) => {
    return Object.values(statuses).filter(s => s.status === status).length;
  };

  const getFilteredWebsites = () => {
    if (filter === 'all') {
      return websites;
    }
    return websites.filter(website => {
      const status = statuses[website.id]?.status || 'unknown';
      return status === filter;
    });
  };

  const getStatusConfig = (websiteId) => {
    const status = statuses[websiteId]?.status || 'unknown';
    const configs = {
      up: { 
        color: 'bg-emerald-100 text-emerald-800 border-emerald-200',
        icon: Wifi,
        iconColor: 'text-emerald-500',
        label: 'Operational'
      },
      down: { 
        color: 'bg-rose-100 text-rose-800 border-rose-200',
        icon: WifiOff,
        iconColor: 'text-rose-500',
        label: 'Down'
      },
      unknown: { 
        color: 'bg-slate-100 text-slate-800 border-slate-200',
        icon: Server,
        iconColor: 'text-slate-400',
        label: 'Unknown'
      }
    };
    return configs[status];
  };

  const filteredWebsites = getFilteredWebsites();

  if (loading) {
    return (
      <div className="min-h-screen bg-gradient-to-br from-slate-50 to-blue-50/30 flex items-center justify-center">
        <div className="text-center">
          <div className="animate-spin rounded-full h-12 w-12 border-b-2 border-blue-600 mx-auto mb-4"></div>
          <p className="text-slate-600 text-lg">Loading monitoring data...</p>
        </div>
      </div>
    );
  }

  return (
    <div className="min-h-screen bg-gradient-to-br from-slate-50 to-blue-50/30">
      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-8">
        
        {/* Header */}
        <div className="mb-8 text-center">
          <h1 className="text-4xl font-bold text-slate-900 mb-3">Real-time Monitoring</h1>
          <p className="text-lg text-slate-600">Live status updates for all monitored websites</p>
        </div>

        {/* Filter Buttons */}
        <div className="flex flex-wrap gap-3 items-center justify-center mb-8">
          <span className="text-sm font-medium text-slate-700 flex items-center">
            <Filter className="h-4 w-4 mr-2" />
            Filter:
          </span>
          
          <button
            onClick={() => setFilter('all')}
            className={`px-4 py-2.5 rounded-lg text-sm font-medium transition-all duration-200 flex items-center space-x-2 ${
              filter === 'all'
                ? 'bg-blue-600 text-white shadow-md'
                : 'bg-slate-200 text-slate-700 hover:bg-slate-300'
            }`}
          >
            <span>All Sites</span>
            <span className="bg-white bg-opacity-20 px-2 py-1 rounded-full text-xs">
              {websites.length}
            </span>
          </button>

          <button
            onClick={() => setFilter('up')}
            className={`px-4 py-2.5 rounded-lg text-sm font-medium transition-all duration-200 flex items-center space-x-2 ${
              filter === 'up'
                ? 'bg-emerald-600 text-white shadow-md'
                : 'bg-emerald-100 text-emerald-700 hover:bg-emerald-200'
            }`}
          >
            <CheckCircle className="h-4 w-4" />
            <span>Websites Up</span>
            <span className="bg-white bg-opacity-20 px-2 py-1 rounded-full text-xs">
              {getStatusCount('up')}
            </span>
          </button>

          <button
            onClick={() => setFilter('down')}
            className={`px-4 py-2.5 rounded-lg text-sm font-medium transition-all duration-200 flex items-center space-x-2 ${
              filter === 'down'
                ? 'bg-rose-600 text-white shadow-md'
                : 'bg-rose-100 text-rose-700 hover:bg-rose-200'
            }`}
          >
            <AlertCircle className="h-4 w-4" />
            <span>Websites Down</span>
            <span className="bg-white bg-opacity-20 px-2 py-1 rounded-full text-xs">
              {getStatusCount('down')}
            </span>
          </button>

          <button
            onClick={() => setFilter('unknown')}
            className={`px-4 py-2.5 rounded-lg text-sm font-medium transition-all duration-200 flex items-center space-x-2 ${
              filter === 'unknown'
                ? 'bg-slate-600 text-white shadow-md'
                : 'bg-slate-100 text-slate-700 hover:bg-slate-200'
            }`}
          >
            <Server className="h-4 w-4" />
            <span>Not Checked</span>
            <span className="bg-white bg-opacity-20 px-2 py-1 rounded-full text-xs">
              {websites.length - Object.keys(statuses).length}
            </span>
          </button>

          {/* Clear Filter Button */}
          {filter !== 'all' && (
            <button
              onClick={() => setFilter('all')}
              className="px-3 py-2.5 text-sm text-slate-600 hover:text-slate-800 flex items-center space-x-1"
            >
              <X className="h-4 w-4" />
              <span>Clear Filter</span>
            </button>
          )}
        </div>

        {/* Status Overview Cards */}
        <div className="grid grid-cols-1 md:grid-cols-3 gap-6 mb-8">
          <div className={`bg-white rounded-2xl p-6 shadow-sm border-2 transition-all duration-200 ${
            filter === 'up' ? 'border-emerald-400 shadow-lg' : 'border-emerald-200'
          }`}>
            <div className="flex items-center">
              <CheckCircle className="h-8 w-8 text-emerald-600 mr-4" />
              <div>
                <p className="text-2xl font-bold text-emerald-600">{getStatusCount('up')}</p>
                <p className="text-sm font-medium text-emerald-600">Websites Up</p>
              </div>
            </div>
          </div>

          <div className={`bg-white rounded-2xl p-6 shadow-sm border-2 transition-all duration-200 ${
            filter === 'down' ? 'border-rose-400 shadow-lg' : 'border-rose-200'
          }`}>
            <div className="flex items-center">
              <AlertCircle className="h-8 w-8 text-rose-600 mr-4" />
              <div>
                <p className="text-2xl font-bold text-rose-600">{getStatusCount('down')}</p>
                <p className="text-sm font-medium text-rose-600">Websites Down</p>
              </div>
            </div>
          </div>

          <div className={`bg-white rounded-2xl p-6 shadow-sm border-2 transition-all duration-200 ${
            filter === 'unknown' ? 'border-slate-400 shadow-lg' : 'border-slate-200'
          }`}>
            <div className="flex items-center">
              <Server className="h-8 w-8 text-slate-600 mr-4" />
              <div>
                <p className="text-2xl font-bold text-slate-600">{websites.length - Object.keys(statuses).length}</p>
                <p className="text-sm font-medium text-slate-600">Not Checked</p>
              </div>
            </div>
          </div>
        </div>

        {/* Websites Section */}
        <div className="bg-white rounded-2xl shadow-sm border border-slate-200/60 overflow-hidden">
          
          {/* Section Header */}
          <div className="px-6 py-5 border-b border-slate-200/60 flex flex-col sm:flex-row sm:items-center sm:justify-between">
            <div>
              <h2 className="text-xl font-semibold text-slate-900">Website Status</h2>
              <p className="text-slate-600 text-sm mt-1">
                Showing {filteredWebsites.length} of {websites.length} websites
                {filter !== 'all' && ` (Filtered by: ${filter})`}
              </p>
            </div>
            
            {filter !== 'all' && (
              <button
                onClick={() => setFilter('all')}
                className="mt-4 sm:mt-0 text-sm text-blue-600 hover:text-blue-800 flex items-center space-x-1"
              >
                <X className="h-4 w-4" />
                <span>Show All</span>
              </button>
            )}
          </div>

          {/* Websites List */}
          <div className="p-6">
            {websites.length === 0 ? (
              <div className="text-center py-12">
                <Server className="mx-auto h-16 w-16 text-slate-300 mb-4" />
                <p className="text-slate-600">No websites configured for monitoring</p>
              </div>
            ) : filteredWebsites.length === 0 ? (
              <div className="text-center py-12">
                <Filter className="mx-auto h-16 w-16 text-slate-300 mb-4" />
                <p className="text-slate-600">No websites match the current filter</p>
                <p className="text-sm text-slate-500 mt-1">
                  Try selecting a different filter or clear the filter to see all websites
                </p>
                <button
                  onClick={() => setFilter('all')}
                  className="mt-4 bg-blue-600 text-white px-4 py-2.5 rounded-lg font-medium hover:bg-blue-700 transition-colors"
                >
                  Show All Websites
                </button>
              </div>
            ) : (
              <div className="grid gap-3">
                {filteredWebsites.map((website) => {
                  const statusConfig = getStatusConfig(website.id);
                  const Icon = statusConfig.icon;
                  const status = statuses[website.id];
                  
                  return (
                    <div key={website.id} className="flex items-center justify-between p-4 bg-slate-50/50 rounded-xl border border-slate-200/60 hover:bg-slate-100/50 transition-colors duration-200 group">
                      
                      {/* Website Info */}
                      <div className="flex items-center space-x-4 flex-1 min-w-0">
                        <div className={`p-2 rounded-lg ${statusConfig.color} border`}>
                          <Icon className={`h-5 w-5 ${statusConfig.iconColor}`} />
                        </div>
                        
                        <div className="min-w-0 flex-1">
                          <div className="flex items-center space-x-3 mb-1">
                            <h3 className="font-semibold text-slate-900 truncate text-sm">
                              {website.name || website.url}
                            </h3>
                            <span className={`px-2 py-1 rounded-full text-xs font-medium border ${statusConfig.color}`}>
                              {statusConfig.label}
                            </span>
                          </div>
                          
                          <div className="flex items-center space-x-4 text-xs text-slate-600 flex-wrap gap-2">
                            <span className="truncate">{website.url}</span>
                            <span>•</span>
                            <span>Every {website.interval}min</span>
                            {status?.lastChecked && (
                              <>
                                <span>•</span>
                                <span className="flex items-center space-x-1">
                                  <Clock className="h-3 w-3" />
                                  <span>{new Date(status.lastChecked).toLocaleTimeString()}</span>
                                </span>
                              </>
                            )}
                            {status?.responseTime && (
                              <>
                                <span>•</span>
                                <span>{status.responseTime}ms</span>
                              </>
                            )}
                          </div>
                        </div>
                      </div>

                      {/* Action Button */}
                      <button 
                        onClick={() => handleManualCheck(website.id)}
                        disabled={manualChecking[website.id]}
                        className="p-2 text-slate-600 hover:bg-white rounded-lg transition-colors disabled:opacity-50 opacity-0 group-hover:opacity-100 ml-4"
                        title="Check now"
                      >
                        {manualChecking[website.id] ? (
                          <RefreshCw className="h-4 w-4 animate-spin" />
                        ) : (
                          <RefreshCw className="h-4 w-4" />
                        )}
                      </button>
                    </div>
                  );
                })}
              </div>
            )}
          </div>
        </div>
      </div>
    </div>
  );
};

export default Monitoring;