// frontend/src/pages/Dashboard.js
import React, { useState, useEffect } from 'react';
import { websitesAPI, reportsAPI } from '../services/api';
import { useMonitoring } from '../contexts/MonitoringContext';
import { useAuth } from '../contexts/AuthContext';
import { 
  Globe, 
  CheckCircle, 
  AlertTriangle, 
  Bell,
  Plus,
  Activity,
  Server,
  Edit3,
  Trash2,
  RefreshCw,
  Wifi,
  WifiOff,
  TrendingUp,
  BarChart3,
  Search,
  Filter,
  Clock,
  Zap
} from 'lucide-react';
import AddWebsiteModal from '../components/Monitoring/AddWebsiteModal';
import EditWebsiteModal from '../components/Monitoring/EditWebsiteModal';
import WebsiteStats from '../components/Monitoring/WebsiteStats';
import Tooltip from '../components/Common/Tooltip';

const Dashboard = () => {
  const [websites, setWebsites] = useState([]);
  const [overviewData, setOverviewData] = useState(null);
  const [loading, setLoading] = useState(true);
  const [showAddModal, setShowAddModal] = useState(false);
  const [showEditModal, setShowEditModal] = useState(false);
  const [showStatsModal, setShowStatsModal] = useState(false);
  const [editingWebsite, setEditingWebsite] = useState(null);
  const [statsWebsite, setStatsWebsite] = useState(null);
  const [manualChecking, setManualChecking] = useState({});
  const [searchTerm, setSearchTerm] = useState('');
  const [statusFilter, setStatusFilter] = useState('all');
  const { statuses, manualCheck } = useMonitoring();
  const { user } = useAuth();

  useEffect(() => {
    if (user) {
      loadData();
    }
  }, [user]);

  const loadData = async () => {
    try {
      setLoading(true);
      
      console.log('Loading dashboard data...');
      
      // Load websites
      const websitesResponse = await websitesAPI.getAll();
      console.log('Websites loaded:', websitesResponse.data);
      setWebsites(websitesResponse.data);

      // Load overview data
      const overviewResponse = await reportsAPI.getOverview();
      console.log('Overview data loaded:', overviewResponse.data);
      setOverviewData(overviewResponse.data);

    } catch (error) {
      console.error('Error loading dashboard data:', error);
      const errorMessage = error.response?.data?.error || error.message || 'Failed to load dashboard data';
      // You might want to show this error to the user
    } finally {
      setLoading(false);
    }
  };

  const handleWebsiteAdded = (newWebsite) => {
    setWebsites(prev => [...prev, newWebsite]);
    setShowAddModal(false);
    loadData(); // Reload data to update stats
  };

  const handleWebsiteUpdated = (updatedWebsite) => {
    setWebsites(prev => prev.map(website => 
      website.id === updatedWebsite.id ? updatedWebsite : website
    ));
    setShowEditModal(false);
    setEditingWebsite(null);
    loadData(); // Reload data to update stats
  };

  const handleEditWebsite = (website) => {
    setEditingWebsite(website);
    setShowEditModal(true);
  };

  const handleShowStats = (website) => {
    setStatsWebsite(website);
    setShowStatsModal(true);
  };

  const handleManualCheck = async (websiteId) => {
    setManualChecking(prev => ({ ...prev, [websiteId]: true }));
    try {
      const result = await manualCheck(websiteId);
      console.log('Manual check result:', result);
      // Reload data after manual check to update stats
      setTimeout(loadData, 1000);
    } catch (error) {
      console.error('Manual check failed:', error);
    } finally {
      setManualChecking(prev => ({ ...prev, [websiteId]: false }));
    }
  };

  const handleDeleteWebsite = async (id) => {
    if (!window.confirm('Are you sure you want to delete this website?')) return;

    try {
      await websitesAPI.delete(id);
      setWebsites(prev => prev.filter(website => website.id !== id));
      loadData(); // Reload data to update stats
    } catch (error) {
      console.error('Error deleting website:', error);
      const errorMessage = error.response?.data?.error || error.message || 'Failed to delete website';
      alert(errorMessage);
    }
  };

  // Calculate statistics from current data
  const stats = {
    total: websites.length,
    up: Object.values(statuses).filter(s => s.status === 'up').length,
    down: Object.values(statuses).filter(s => s.status === 'down').length,
    unknown: websites.length - Object.values(statuses).filter(s => s.status === 'up' || s.status === 'down').length
  };

  stats.uptimePercentage = stats.total > 0 ? ((stats.up / stats.total) * 100).toFixed(1) : 0;

  const statCards = [
    {
      title: 'Websites Monitored',
      value: overviewData?.totalWebsites || stats.total,
      icon: Globe,
      color: 'blue',
      description: 'Active monitoring'
    },
    {
      title: 'Uptime Percentage',
      value: overviewData?.uptimePercentage ? `${overviewData.uptimePercentage}%` : `${stats.uptimePercentage}%`,
      icon: CheckCircle,
      color: 'emerald',
      description: 'Overall reliability'
    },
    {
      title: 'Active Issues',
      value: overviewData?.statusDistribution?.down || stats.down,
      icon: AlertTriangle,
      color: 'rose',
      description: 'Websites down'
    },
    {
      title: 'Alerts Sent',
      value: overviewData?.alertsCount || 0,
      icon: Bell,
      color: 'violet',
      description: 'Recent notifications'
    }
  ];

  // Filter websites based on search and status
  const filteredWebsites = websites.filter(website => {
    const matchesSearch = website.name?.toLowerCase().includes(searchTerm.toLowerCase()) || 
                         website.url.toLowerCase().includes(searchTerm.toLowerCase());
    const matchesStatus = statusFilter === 'all' || statuses[website.id]?.status === statusFilter;
    return matchesSearch && matchesStatus;
  });

  const getStatusBadge = (websiteId) => {
    const status = statuses[websiteId]?.status || 'unknown';
    const config = {
      up: { color: 'bg-emerald-100 text-emerald-800 border-emerald-200', label: 'Operational' },
      down: { color: 'bg-rose-100 text-rose-800 border-rose-200', label: 'Down' },
      unknown: { color: 'bg-slate-100 text-slate-800 border-slate-200', label: 'Unknown' }
    };
    return config[status];
  };

  const getStatusIcon = (websiteId) => {
    const status = statuses[websiteId]?.status || 'unknown';
    const config = {
      up: { icon: Wifi, color: 'text-emerald-500' },
      down: { icon: WifiOff, color: 'text-rose-500' },
      unknown: { icon: Server, color: 'text-slate-400' }
    };
    const { icon: Icon, color } = config[status];
    return <Icon className={`h-4 w-4 ${color}`} />;
  };

  if (loading) {
    return (
      <div className="min-h-screen bg-gradient-to-br from-slate-50 to-blue-50/30 flex items-center justify-center">
        <div className="text-center">
          <div className="animate-spin rounded-full h-12 w-12 border-b-2 border-blue-600 mx-auto mb-4"></div>
          <p className="text-slate-600 text-lg">Loading dashboard...</p>
        </div>
      </div>
    );
  }

  return (
    <div className="min-h-screen bg-gradient-to-br from-slate-50 to-blue-50/30">
      {/* Modals */}
      <AddWebsiteModal
        isOpen={showAddModal}
        onClose={() => setShowAddModal(false)}
        onWebsiteAdded={handleWebsiteAdded}
      />

      <EditWebsiteModal
        isOpen={showEditModal}
        onClose={() => {
          setShowEditModal(false);
          setEditingWebsite(null);
        }}
        website={editingWebsite}
        onWebsiteUpdated={handleWebsiteUpdated}
      />

      <WebsiteStats
        isOpen={showStatsModal}
        onClose={() => {
          setShowStatsModal(false);
          setStatsWebsite(null);
        }}
        website={statsWebsite}
      />

      {/* Main Layout */}
      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-8">
        
        {/* Header Section */}
        <div className="mb-8 text-center">
          <h1 className="text-4xl font-bold text-slate-900 mb-3">Infrastructure Monitoring Dashboard</h1>
          <p className="text-lg text-slate-600 max-w-2xl mx-auto">
            Real-time monitoring and alerting for your infrastructure
          </p>
        </div>

        {/* Stats Overview */}
        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6 mb-8">
          {statCards.map((stat, index) => {
            const Icon = stat.icon;
            const colorMap = {
              blue: 'from-blue-500 to-blue-600',
              emerald: 'from-emerald-500 to-emerald-600',
              rose: 'from-rose-500 to-rose-600',
              violet: 'from-violet-500 to-violet-600'
            };
            
            return (
              <div 
                key={index} 
                className="bg-white rounded-2xl p-6 shadow-sm border border-slate-200/60 hover:shadow-md transition-all duration-300"
              >
                <div className="flex items-center justify-between mb-4">
                  <div className={`p-3 rounded-xl bg-gradient-to-br ${colorMap[stat.color]} shadow-lg`}>
                    <Icon className="h-6 w-6 text-white" />
                  </div>
                  <div className={`text-xs font-semibold px-3 py-1 rounded-full ${
                    stat.color === 'rose' && stat.value > 0 
                      ? 'bg-rose-50 text-rose-700 border border-rose-200' 
                      : 'bg-slate-50 text-slate-700 border border-slate-200'
                  }`}>
                    {stat.color === 'rose' && stat.value > 0 ? 'Attention Needed' : 'Stable'}
                  </div>
                </div>
                
                <h3 className="text-3xl font-bold text-slate-900 mb-1">{stat.value}</h3>
                <p className="text-slate-700 font-medium text-sm">{stat.title}</p>
                <p className="text-slate-500 text-xs mt-1">{stat.description}</p>
              </div>
            );
          })}
        </div>

        {/* Websites Section */}
        <div className="bg-white rounded-2xl shadow-sm border border-slate-200/60 overflow-hidden">
          
          {/* Section Header */}
          <div className="px-6 py-5 border-b border-slate-200/60">
            <div className="flex flex-col lg:flex-row lg:items-center lg:justify-between gap-4">
              <div>
                <h2 className="text-xl font-semibold text-slate-900">Monitored Websites</h2>
                <p className="text-slate-600 text-sm mt-1">
                  {filteredWebsites.length} of {websites.length} websites
                </p>
              </div>
              
              <div className="flex flex-col sm:flex-row gap-3">
                {/* Search */}
                <div className="relative">
                  <Search className="absolute left-3 top-1/2 transform -translate-y-1/2 h-4 w-4 text-slate-400" />
                  <input
                    type="text"
                    placeholder="Search websites..."
                    value={searchTerm}
                    onChange={(e) => setSearchTerm(e.target.value)}
                    className="pl-10 pr-4 py-2.5 border border-slate-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-blue-500 text-sm w-full sm:w-64"
                  />
                </div>
                
                {/* Status Filter */}
                <select
                  value={statusFilter}
                  onChange={(e) => setStatusFilter(e.target.value)}
                  className="px-4 py-2.5 border border-slate-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-blue-500 text-sm"
                >
                  <option value="all">All Status</option>
                  <option value="up">Operational</option>
                  <option value="down">Down</option>
                  <option value="unknown">Unknown</option>
                </select>
                
                {/* Add Website Button */}
                <button 
                  onClick={() => setShowAddModal(true)}
                  className="bg-blue-600 text-white px-4 py-2.5 rounded-lg font-medium hover:bg-blue-700 transition-colors duration-200 flex items-center justify-center space-x-2"
                >
                  <Plus className="h-4 w-4" />
                  <span>Add Website</span>
                </button>
              </div>
            </div>
          </div>

          {/* Websites List */}
          <div className="p-6">
            {websites.length === 0 ? (
              <div className="text-center py-12">
                <Server className="mx-auto h-16 w-16 text-slate-300 mb-4" />
                <h3 className="text-lg font-medium text-slate-900 mb-2">No websites configured</h3>
                <p className="text-slate-600 mb-6">Start by adding your first website to monitor</p>
                <button 
                  onClick={() => setShowAddModal(true)}
                  className="bg-blue-600 text-white px-6 py-2.5 rounded-lg font-medium hover:bg-blue-700 transition-colors duration-200"
                >
                  Add Your First Website
                </button>
              </div>
            ) : filteredWebsites.length === 0 ? (
              <div className="text-center py-12">
                <Filter className="mx-auto h-16 w-16 text-slate-300 mb-4" />
                <h3 className="text-lg font-medium text-slate-900 mb-2">No websites found</h3>
                <p className="text-slate-600">Try adjusting your search or filters</p>
              </div>
            ) : (
              <div className="grid gap-3">
                {filteredWebsites.map((website) => {
                  const statusConfig = getStatusBadge(website.id);
                  const lastChecked = statuses[website.id]?.lastChecked;
                  
                  return (
                    <div key={website.id} className="flex items-center justify-between p-4 bg-slate-50/50 rounded-xl border border-slate-200/60 hover:bg-slate-100/50 transition-colors duration-200 group">
                      
                      {/* Website Info */}
                      <div className="flex items-center space-x-4 flex-1 min-w-0">
                        <div className="flex-shrink-0">
                          {getStatusIcon(website.id)}
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
                          
                          <div className="flex items-center space-x-4 text-xs text-slate-600">
                            <span className="truncate">{website.url}</span>
                            <span>•</span>
                            <span>Every {website.interval}min</span>
                            {lastChecked && (
                              <>
                                <span>•</span>
                                <span>Checked: {new Date(lastChecked).toLocaleTimeString()}</span>
                              </>
                            )}
                          </div>
                        </div>
                      </div>

                      {/* Action Buttons */}
                      <div className="flex items-center space-x-1 opacity-0 group-hover:opacity-100 transition-opacity duration-200 ml-4">
                        <Tooltip text="Check Now">
                          <button 
                            onClick={() => handleManualCheck(website.id)}
                            disabled={manualChecking[website.id]}
                            className="p-2 text-slate-600 hover:bg-white rounded-lg transition-colors disabled:opacity-50"
                          >
                            {manualChecking[website.id] ? (
                              <RefreshCw className="h-4 w-4 animate-spin" />
                            ) : (
                              <RefreshCw className="h-4 w-4" />
                            )}
                          </button>
                        </Tooltip>

                        <Tooltip text="View Statistics">
                          <button 
                            onClick={() => handleShowStats(website)}
                            className="p-2 text-slate-600 hover:bg-white rounded-lg transition-colors"
                          >
                            <BarChart3 className="h-4 w-4" />
                          </button>
                        </Tooltip>

                        <Tooltip text="Edit Website">
                          <button 
                            onClick={() => handleEditWebsite(website)}
                            className="p-2 text-slate-600 hover:bg-white rounded-lg transition-colors"
                          >
                            <Edit3 className="h-4 w-4" />
                          </button>
                        </Tooltip>

                        <Tooltip text="Delete Website">
                          <button 
                            onClick={() => handleDeleteWebsite(website.id)}
                            className="p-2 text-rose-600 hover:bg-rose-50 rounded-lg transition-colors"
                          >
                            <Trash2 className="h-4 w-4" />
                          </button>
                        </Tooltip>
                      </div>
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

export default Dashboard;