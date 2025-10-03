// frontend/src/pages/Alerts.js
import React, { useState, useEffect, useCallback } from 'react';
import { Bell, Settings, CheckCircle, AlertTriangle, X } from 'lucide-react';
import { alertsAPI } from '../services/api';
import AlertStats from '../components/Alerts/AlertStats';
import AlertsList from '../components/Alerts/AlertsList';
import AlertSettings from '../components/Alerts/AlertSettings';
import DateRangeSelector from '../components/Reports/DateRangeSelector';
import { getTodayDate, getDaysAgo } from '../utils/dateUtils';

const Alerts = () => {
  const [activeTab, setActiveTab] = useState('history');
  const [alerts, setAlerts] = useState([]);
  const [stats, setStats] = useState(null);
  const [loading, setLoading] = useState(false);
  const [pagination, setPagination] = useState({});
  const [filters, setFilters] = useState({
  page: 1,
  limit: 20,
  type: 'all',
  search: '',
  startDate: getDaysAgo(30),
  endDate: getTodayDate(),
  preset: 30
});

  // Animation states
  const [showSuccess, setShowSuccess] = useState(false);
  const [successMessage, setSuccessMessage] = useState('');
  const [showDeleteModal, setShowDeleteModal] = useState(false);
  const [deleteConfig, setDeleteConfig] = useState({ type: 'single', alertId: null, alertIds: [] });
  const [showError, setShowError] = useState(false);
  const [errorMessage, setErrorMessage] = useState('');

  const loadStats = useCallback(async () => {
  try {
    console.log('Loading alert stats with date range:', {
      startDate: filters.startDate,
      endDate: filters.endDate
    });
    
    const response = await alertsAPI.getStats({
      startDate: filters.startDate,
      endDate: filters.endDate
    });
    console.log('Alert stats loaded:', response.data);
    
    // Log debug info if available
    if (response.data.debug) {
      console.log('Stats debug info:', response.data.debug);
    }
    
    setStats(response.data);
  } catch (error) {
    console.error('Error loading stats:', error);
    const errorMessage = error.response?.data?.error || error.message || 'Failed to load statistics';
    showErrorAnimation(errorMessage);
  }
}, [filters.startDate, filters.endDate]);
  const loadAlerts = useCallback(async () => {
  try {
    setLoading(true);
    
    console.log('Loading alerts with filters:', filters);
    
    // Prepare API parameters
    const params = {
      page: filters.page,
      limit: filters.limit,
      startDate: filters.startDate,
      endDate: filters.endDate
    };

    // Add type filter if not 'all'
    if (filters.type !== 'all') {
      params.type = filters.type;
    }

    // Add search filter if provided
    if (filters.search) {
      params.search = filters.search;
    }

    console.log('API call parameters:', params);

    const response = await alertsAPI.getAll(params);
    console.log('Alerts API response:', response.data);
    
    setAlerts(response.data.alerts || []);
    setPagination(response.data.pagination || {});
    
    // Log debug info if available
    if (response.data.debug) {
      console.log('Debug info:', response.data.debug);
    }
  } catch (error) {
    console.error('Error loading alerts:', error);
    const errorMessage = error.response?.data?.error || error.message || 'Failed to load alerts';
    showErrorAnimation(errorMessage);
  } finally {
    setLoading(false);
  }
}, [filters]);

  useEffect(() => {
    loadStats();
  }, [loadStats]);

  useEffect(() => {
    if (activeTab === 'history') {
      loadAlerts();
    }
  }, [filters, activeTab, loadAlerts]);

  // Success animation handler
  const showSuccessAnimation = (message) => {
    setSuccessMessage(message);
    setShowSuccess(true);
    setTimeout(() => {
      setShowSuccess(false);
    }, 3000);
  };

  // Error animation handler
  const showErrorAnimation = (message) => {
    setErrorMessage(message);
    setShowError(true);
    setTimeout(() => {
      setShowError(false);
    }, 4000);
  };

  // Smart pagination after deletion
  const handleSmartPagination = (deletedCount) => {
    const currentPage = pagination.currentPage;
    const totalPages = pagination.totalPages;
    const itemsPerPage = pagination.itemsPerPage;
    const totalItems = pagination.totalItems;
    
    // Calculate remaining items after deletion
    const remainingItems = totalItems - deletedCount;
    
    // If current page is empty and there are previous pages, go to previous page
    if (alerts.length === deletedCount && currentPage > 1) {
      const newPage = currentPage - 1;
      setFilters(prev => ({ ...prev, page: newPage }));
      showSuccessAnimation(`Deleted ${deletedCount} alert(s). Navigated to page ${newPage}`);
    } 
    // If it's the last page and we deleted all items, but there are previous pages
    else if (remainingItems <= 0 && currentPage > 1) {
      const newPage = currentPage - 1;
      setFilters(prev => ({ ...prev, page: newPage }));
      showSuccessAnimation(`Deleted ${deletedCount} alert(s). Navigated to page ${newPage}`);
    }
    // If we're on page 1 and delete all items, reload to show empty state
    else if (remainingItems <= 0 && currentPage === 1) {
      showSuccessAnimation(`Deleted ${deletedCount} alert(s)`);
    }
    // Otherwise, just show success message
    else {
      showSuccessAnimation(`Deleted ${deletedCount} alert(s)`);
    }
  };

  // Delete confirmation modal
  const showDeleteConfirmation = (type, alertId = null, alertIds = []) => {
    setDeleteConfig({ type, alertId, alertIds });
    setShowDeleteModal(true);
  };

  const handleConfirmDelete = async () => {
    setShowDeleteModal(false);
    
    try {
      if (deleteConfig.type === 'single') {
        await alertsAPI.delete(deleteConfig.alertId);
        const deletedCount = 1;
        setAlerts(prevAlerts => prevAlerts.filter(alert => alert.id !== deleteConfig.alertId));
        
        // Update pagination totals
        setPagination(prev => ({
          ...prev,
          totalItems: prev.totalItems - deletedCount
        }));
        
        handleSmartPagination(deletedCount);
      } else {
        await alertsAPI.bulkDelete({ alertIds: deleteConfig.alertIds });
        const deletedCount = deleteConfig.alertIds.length;
        setAlerts(prevAlerts => prevAlerts.filter(alert => !deleteConfig.alertIds.includes(alert.id)));
        
        // Update pagination totals
        setPagination(prev => ({
          ...prev,
          totalItems: prev.totalItems - deletedCount
        }));
        
        handleSmartPagination(deletedCount);
      }
      
      // Reload stats to reflect changes
      loadStats();
    } catch (error) {
      console.error('Error deleting alert:', error);
      const errorMessage = error.response?.data?.error || error.message || 'Failed to delete alert';
      showErrorAnimation(errorMessage);
    }
  };

  const handleCancelDelete = () => {
    setShowDeleteModal(false);
    setDeleteConfig({ type: 'single', alertId: null, alertIds: [] });
  };

  const handleDeleteAlert = (alertId) => {
    showDeleteConfirmation('single', alertId);
  };

  const handleBulkDelete = (alertIds) => {
    if (!alertIds || alertIds.length === 0) {
      showErrorAnimation('No alerts selected for deletion');
      return;
    }
    showDeleteConfirmation('bulk', null, alertIds);
  };

  const handlePageChange = (newPage) => {
    setFilters(prev => ({ ...prev, page: newPage }));
  };

  const handleFilterChange = (newFilters) => {
    setFilters(prev => ({ ...prev, ...newFilters, page: 1 }));
  };

  const handleSearchChange = (searchTerm) => {
    setFilters(prev => ({ ...prev, search: searchTerm, page: 1 }));
  };

  const handleTypeFilterChange = (type) => {
    setFilters(prev => ({ ...prev, type, page: 1 }));
  };

  const tabs = [
    { id: 'history', label: 'Alert History', icon: Bell },
    { id: 'settings', label: 'Alert Settings', icon: Settings }
  ];

  const getDeleteMessage = () => {
    if (deleteConfig.type === 'single') {
      return 'Are you sure you want to delete this alert? This action cannot be undone.';
    } else {
      return `Are you sure you want to delete ${deleteConfig.alertIds.length} selected alerts? This action cannot be undone.`;
    }
  };

  return (
    <div className="min-h-screen bg-gradient-to-br from-slate-50 to-blue-50/30 relative">
      {/* Success Notification */}
      {showSuccess && (
        <div className="fixed top-4 right-4 z-50 animate-fade-in-down">
          <div className="bg-emerald-50 border border-emerald-200 rounded-2xl p-4 shadow-lg max-w-sm">
            <div className="flex items-center space-x-3">
              <div className="animate-scale-in">
                <CheckCircle className="h-6 w-6 text-emerald-600" />
              </div>
              <div className="flex-1">
                <p className="text-emerald-800 font-medium text-sm">{successMessage}</p>
              </div>
              <button
                onClick={() => setShowSuccess(false)}
                className="text-emerald-600 hover:text-emerald-800 transition-colors"
              >
                <X className="h-4 w-4" />
              </button>
            </div>
          </div>
        </div>
      )}

      {/* Error Notification */}
      {showError && (
        <div className="fixed top-4 right-4 z-50 animate-fade-in-down">
          <div className="bg-rose-50 border border-rose-200 rounded-2xl p-4 shadow-lg max-w-sm">
            <div className="flex items-center space-x-3">
              <div className="animate-scale-in">
                <AlertTriangle className="h-6 w-6 text-rose-600" />
              </div>
              <div className="flex-1">
                <p className="text-rose-800 font-medium text-sm">{errorMessage}</p>
              </div>
              <button
                onClick={() => setShowError(false)}
                className="text-rose-600 hover:text-rose-800 transition-colors"
              >
                <X className="h-4 w-4" />
              </button>
            </div>
          </div>
        </div>
      )}

      {/* Delete Confirmation Modal */}
      {showDeleteModal && (
        <div className="fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center z-50 p-4 animate-fade-in">
          <div className="bg-white rounded-2xl max-w-md w-full animate-scale-in">
            <div className="p-6">
              <div className="flex items-center space-x-3 mb-4">
                <div className="p-2 bg-rose-100 rounded-xl">
                  <AlertTriangle className="h-6 w-6 text-rose-600" />
                </div>
                <h3 className="text-lg font-semibold text-slate-900">Confirm Deletion</h3>
              </div>
              
              <p className="text-slate-600 mb-6">{getDeleteMessage()}</p>
              
              <div className="flex justify-end space-x-3">
                <button
                  onClick={handleCancelDelete}
                  className="px-4 py-2.5 border border-slate-300 text-slate-700 rounded-lg hover:bg-slate-50 transition-colors font-medium"
                >
                  Cancel
                </button>
                <button
                  onClick={handleConfirmDelete}
                  className="px-4 py-2.5 bg-rose-600 text-white rounded-lg hover:bg-rose-700 transition-colors font-medium"
                >
                  Delete
                </button>
              </div>
            </div>
          </div>
        </div>
      )}

      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-8">
        
        {/* Header */}
        <div className="mb-8">
          <div className="flex flex-col lg:flex-row lg:items-center lg:justify-between gap-4">
            <div className="text-center lg:text-left">
              <h1 className="text-4xl font-bold text-slate-900 mb-3">Alerts & Notifications</h1>
              <p className="text-lg text-slate-600">Manage alert history and notification preferences</p>
            </div>
          </div>
        </div>

        {/* Stats */}
        {activeTab === 'history' && <AlertStats stats={stats} loading={loading} />}

        {/* Date Range Selector */}
        {activeTab === 'history' && (
          <DateRangeSelector
            dateRange={filters}
            onDateRangeChange={handleFilterChange}
            loading={loading}
          />
        )}

        {/* Tabs */}
        <div className="bg-white rounded-2xl shadow-sm border border-slate-200/60 overflow-hidden">
          <div className="border-b border-slate-200/60">
            <nav className="flex space-x-8 px-6">
              {tabs.map((tab) => {
                const Icon = tab.icon;
                return (
                  <button
                    key={tab.id}
                    onClick={() => setActiveTab(tab.id)}
                    className={`py-4 px-1 border-b-2 font-medium text-sm flex items-center space-x-2 transition-colors ${
                      activeTab === tab.id
                        ? 'border-blue-500 text-blue-600'
                        : 'border-transparent text-slate-500 hover:text-slate-700 hover:border-slate-300'
                    }`}
                  >
                    <Icon className="h-4 w-4" />
                    <span>{tab.label}</span>
                  </button>
                );
              })}
            </nav>
          </div>

          {/* Tab Content */}
          <div className="p-6">
            {activeTab === 'history' ? (
              <AlertsList
                alerts={alerts}
                pagination={pagination}
                loading={loading}
                onDelete={handleDeleteAlert}
                onBulkDelete={handleBulkDelete}
                onPageChange={handlePageChange}
                onSearchChange={handleSearchChange}
                onTypeFilterChange={handleTypeFilterChange}
                currentFilters={filters}
                loadAlerts={loadAlerts}
              />
            ) : (
              <AlertSettings />
            )}
          </div>
        </div>
      </div>
    </div>
  );
};

export default Alerts;